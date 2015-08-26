//
//  CSScanner.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSScanner.h"
#import "CSScannerPointView.h"
#import "CSScannerFocusPointView.h"

@interface CSScanner () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *scannedData;

@property (nonatomic, strong) NSMutableArray *pointViews;
@property (nonatomic, strong) CSScannerFocusPointView *focusPointView;

@end

@implementation CSScanner

- (void)setupScanner {
    NSError *error;
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    self.captureSession = [AVCaptureSession new];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetaDataOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.captureSession addOutput:captureMetaDataOutput];
    dispatch_queue_t metaDataDispatchQueue;
    metaDataDispatchQueue = dispatch_queue_create("dispatchQueue", NULL);
    [captureMetaDataOutput setMetadataObjectsDelegate:self queue:metaDataDispatchQueue];
    [captureMetaDataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.videoPreviewLayer.frame = CGRectMake(0, 0, self.scanView.frame.size.width, self.scanView.frame.size.height);
    [self.scanView.layer addSublayer:self.videoPreviewLayer];
    
    self.pointViews = [NSMutableArray new];
    for (NSInteger i = 0; i < 16; i++) {
        CSScannerPointView *pointView = [[CSScannerPointView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.pointViews addObject:pointView];
        [self.scanView addSubview:pointView];
    }
}

- (void)didTapAtLocation:(CGPoint)point {
    if ([self.captureDevice isFocusPointOfInterestSupported] && [self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        CGPoint focusPoint = [self.videoPreviewLayer captureDevicePointOfInterestForPoint:point];
        if ([self.captureDevice lockForConfiguration:nil]) {
            [self.captureDevice setFocusPointOfInterest:focusPoint];
            [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([self.captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
                [self.captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [self.captureDevice unlockForConfiguration];
            if (!!self.focusPointView)
                [self.focusPointView removeFromSuperview];
            self.focusPointView = [[CSScannerFocusPointView alloc]initWithFrame:CGRectMake(self.scanView.frame.size.width * (1 - focusPoint.y) - 20, self.scanView.frame.size.height * focusPoint.x - 20, 40, 40)];
            [self.scanView addSubview:self.focusPointView];
        }
    }
}

- (void)setFlashOn:(BOOL)flashOn {
    _flashOn = flashOn;
    [self.captureDevice lockForConfiguration:nil];
    if (flashOn) {
        [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
    } else {
        [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
    }
    [self.captureDevice unlockForConfiguration];
    [self.delegate flashDidToggle:flashOn];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject*)[self.videoPreviewLayer transformedMetadataObjectForMetadataObject:metadata];
            
            if (!self.scannedData) {
                [self stopScanning];
                self.scannedData = transformed;
                NSLog(@"%@", self.scannedData.stringValue);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.delegate didScanMetadata:self.scannedData];
                });
            }
        }
    }
}

- (void)animatePointViewsToQuadrilateral:(CSQuadrilateral *)quad {
    [UIView animateWithDuration:.2 animations:^{
        for (NSInteger i = 0; i < self.pointViews.count; i++) {
            CSScannerPointView *pointView = [self.pointViews objectAtIndex:i];
            pointView.layer.cornerRadius = 5;
            pointView.isActive = NO;
            if (i % 4 == 0) {
                pointView.center = quad.topLeft;
            } else if (i % 4 == 1) {
                pointView.center = quad.topRight;
            } else if (i % 4 == 2) {
                pointView.center = quad.bottomRight;
            } else {
                pointView.center = quad.bottomLeft;
            }
        }
    } completion:^(BOOL finished) {
        [self.delegate didAnimatePoints];
    }];
}

- (void)reset {
    self.scannedData = nil;
    for (CSScannerPointView *pointView in self.pointViews) {
        pointView.isActive = YES;
    }
    [self startScanning];
}

- (void)startScanning {
    [self.captureSession startRunning];
}

- (void)stopScanning {
    [self.captureSession stopRunning];
    self.flashOn = NO;
}

@end
