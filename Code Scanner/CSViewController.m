//
//  CSViewController.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSViewController.h"
#import "CSView.h"
#import "CSScanner.h"

@interface CSViewController () <CSScannerDelegate>

@property (nonatomic, retain) CSView *view;

@property (nonatomic, strong) CSScanner *scanner;

@property (nonatomic) BOOL flashOn;

@end

@implementation CSViewController
@dynamic view;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[CSView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view.flashButton addTarget:self action:@selector(onFlash) forControlEvents:UIControlEventTouchUpInside];
    [self.view.redoButton addTarget:self action:@selector(resetScanner) forControlEvents:UIControlEventTouchUpInside];
    [self setupScanner];
}

- (void)setupScanner {
    self.scanner = [CSScanner new];
    self.scanner.delegate = self;
    self.scanner.scanView = self.view.scanView;
    [self.scanner setupScanner];
    [self.scanner startScanning];
}

- (void)resetScanner {
    [self.scanner reset];
    [self.view reset];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    [self.scanner didTapAtLocation:location];
}

- (void)onFlash {
    self.flashOn = !self.flashOn;
}

- (void)setFlashOn:(BOOL)flashOn {
    _flashOn = flashOn;
    self.scanner.flashOn = flashOn;
    if (flashOn)
        [self.view.flashButton setBackgroundImage:[UIImage imageNamed:@"bulbOn.png"] forState:UIControlStateNormal];
    else
        [self.view.flashButton setBackgroundImage:[UIImage imageNamed:@"bulbOff.png"] forState:UIControlStateNormal];
}

- (void)didScanMetadata:(AVMetadataMachineReadableCodeObject*)metadata {
    CSQRCodeOverlayView *qrCodeOverlayView = [[CSQRCodeOverlayView alloc]initWithMetadata:metadata];
    self.view.qrCodeOverlayView = qrCodeOverlayView;
    [self.scanner animatePointViewsToQuadrilateral:qrCodeOverlayView.quad];
}

- (void)didAnimatePoints {
    [self.view presentData:self.view.qrCodeOverlayView.stringData];
}

@end
