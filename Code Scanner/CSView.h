//
//  CSView.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSQRCodeOverlayView.h"

@interface CSView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) UIImageView *scanView;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, strong) CSQRCodeOverlayView *qrCodeOverlayView;

- (void)presentData:(NSString *)data;
- (void)reset;

@end
