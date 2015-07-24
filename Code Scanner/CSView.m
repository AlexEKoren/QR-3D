//
//  CSView.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSView.h"
#import "CSConstant.h"

@interface CSView ()

@property (nonatomic, strong) UITextView *dataView;

@property (nonatomic, strong) UIView *darkView;

@end

@implementation CSView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.scanView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.scanView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.scanView];
    
    self.darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.darkView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.8];
    self.darkView.alpha = 0.0;
    [self addSubview:self.darkView];
    
    self.flashButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 45, frame.size.height - 45, 40, 40)];
    [self.flashButton setBackgroundImage:[UIImage imageNamed:@"bulbOff.png"] forState:UIControlStateNormal];
    [self addSubview:self.flashButton];
    
    self.redoButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 50, 25, 45, 45)];
    [self.redoButton setTitle:@"↺" forState:UIControlStateNormal];
    [self.redoButton setTitleColor:[CSConstant colorWithAlpha:1.0] forState:UIControlStateNormal];
    self.redoButton.titleLabel.font = [UIFont systemFontOfSize:40];
    self.redoButton.alpha = 0.0;
    [self addSubview:self.redoButton];
    
    self.dataView = [[UITextView alloc]initWithFrame:CGRectMake(10, frame.size.height - 50, frame.size.width - 20, 40)];
    self.dataView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.8];
    self.dataView.textColor = [UIColor whiteColor];
    self.dataView.editable = NO;
    self.dataView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.dataView.layer.cornerRadius = 5.0;
    self.dataView.clipsToBounds = YES;
    self.dataView.alpha = 0.0;
    self.dataView.font = [UIFont systemFontOfSize:25];
    self.dataView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.dataView];
    
    return self;
}

- (void)setQrCodeOverlayView:(CSQRCodeOverlayView *)qrCodeOverlayView {
    _qrCodeOverlayView = qrCodeOverlayView;
    if (!qrCodeOverlayView)
        return;
    qrCodeOverlayView.alpha = 0.0;
    [self addSubview:qrCodeOverlayView];
    [UIView animateWithDuration:.3 animations:^{
        qrCodeOverlayView.alpha = 1.0;
        self.flashButton.alpha = 0.0;
        self.darkView.alpha = 1.0;
        self.redoButton.alpha = 1.0;
    }];
}

- (void)presentData:(NSString *)data {
    [self.qrCodeOverlayView start];
    self.dataView.text = data;
    [UIView animateWithDuration:.3 animations:^{
        self.dataView.alpha = 1.0;
    }];
}

- (void)reset {
    [UIView animateWithDuration:.3 animations:^{
        self.scanView.alpha = 1.0;
        self.flashButton.alpha = 1.0;
        self.qrCodeOverlayView.alpha = 0.0;
        self.redoButton.alpha = 0.0;
        self.dataView.alpha = 0.0;
        self.darkView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.qrCodeOverlayView removeFromSuperview];
        self.qrCodeOverlayView = nil;
    }];
}

@end
