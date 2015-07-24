//
//  CSScannerFocusPointView.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSScannerFocusPointView.h"
#import "CSConstant.h"

@implementation CSScannerFocusPointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderColor = [CSConstant colorWithAlpha:.2].CGColor;
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 5.0;
    
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    pulse.toValue = (id)[CSConstant colorWithAlpha:1.0].CGColor;
    pulse.repeatCount = 5;
    [self.layer addAnimation:pulse forKey:@"pulse"];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onHide) userInfo:nil repeats:YES];
    
    return self;
}

- (void)onHide {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0.0;
    }];
}

@end
