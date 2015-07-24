//
//  CSQRCodeOverlayView.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSQRCodeOverlayView.h"
#import "CSConstant.h"
#import "UIImage+CSQRCode.h"
#import "CALayer+CSQuadrilateral.h"

@interface CSQRCodeOverlayView ()

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadata;

@property (nonatomic, strong) NSTimer *animationTimer;

@end

@implementation CSQRCodeOverlayView

- (instancetype)initWithMetadata:(AVMetadataMachineReadableCodeObject*)metadata {
    self = [super init];
    if (!self)
        return nil;
    
    self.metadata = metadata;
    
    self.stringData = metadata.stringValue;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.quad = [CSQuadrilateral new];
    
    self.quad.topLeft = CGPointMake([[metadata.corners objectAtIndex:0][@"X"] floatValue], [[metadata.corners objectAtIndex:0][@"Y"] floatValue]);
    self.quad.topRight = CGPointMake([[metadata.corners objectAtIndex:3][@"X"] floatValue], [[metadata.corners objectAtIndex:3][@"Y"] floatValue]);
    self.quad.bottomLeft = CGPointMake([[metadata.corners objectAtIndex:1][@"X"] floatValue], [[metadata.corners objectAtIndex:1][@"Y"] floatValue]);
    self.quad.bottomRight = CGPointMake([[metadata.corners objectAtIndex:2][@"X"] floatValue], [[metadata.corners objectAtIndex:2][@"Y"] floatValue]);
    
    self.frame = [UIScreen mainScreen].bounds;
    self.layer.anchorPoint = CGPointMake(0, 0);
    self.layer.quadrilateral = self.quad;
    
    self.image = [UIImage QRCodeForString:metadata.stringValue size:256 fillColor:[CSConstant colorWithAlpha:1.0]];
    
    return self;
}

- (void)start {
    [UIView animateWithDuration:.5 animations:^{
        self.frame = CGRectMake(self.superview.frame.size.width / 2 - 100, self.superview.frame.size.height / 2 - 100, 200, 200);
        self.layer.transform = CATransform3DIdentity;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(self.superview.frame.size.width / 2, self.superview.frame.size.height / 2, 200, 200);
        self.layer.anchorPoint = CGPointMake(.5, .5);
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }];
}

- (void)animate {
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, -M_PI / 10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4 animations:^{
            self.transform = CGAffineTransformRotate(self.transform, M_PI / 10 + M_PI_2);
        }];
        
    }];
}

- (void)stop {
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

@end
