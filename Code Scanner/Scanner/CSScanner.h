//
//  CSScanner.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CSQuadrilateral.h"

@protocol CSScannerDelegate <NSObject>

- (void)didScanMetadata:(AVMetadataMachineReadableCodeObject*)metadata;
- (void)didAnimatePoints;

@end

@interface CSScanner : NSObject

@property (nonatomic) BOOL flashOn;
@property (nonatomic, strong) UIImageView *scanView;

- (void)setupScanner;
- (void)reset;
- (void)startScanning;
- (void)stopScanning;

- (void)didTapAtLocation:(CGPoint)point;

- (void)animatePointViewsToQuadrilateral:(CSQuadrilateral*)quad;

@property (nonatomic, strong) id<CSScannerDelegate> delegate;

@end

