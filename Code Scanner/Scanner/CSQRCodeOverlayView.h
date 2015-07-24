//
//  CSQRCodeOverlayView.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CSQuadrilateral.h"

@interface CSQRCodeOverlayView : UIImageView

- (instancetype)initWithMetadata:(AVMetadataMachineReadableCodeObject*)metadata;

@property (nonatomic, strong) NSString *stringData;
@property (nonatomic, strong) CSQuadrilateral *quad;

- (void)start;
- (void)stop;

@end
