//
//  CSScannerPointView.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSScannerPointView.h"
#import "CSConstant.h"

@implementation CSScannerPointView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.backgroundColor = [CSConstant colorWithAlpha:1.0];
    self.layer.cornerRadius = frame.size.width / 2;
    self.clipsToBounds = YES;
    
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.isActive = YES;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    self.isActive = NO;
}

- (void)beginAnimationLoop {
    if (!self.isActive)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:(.5 + (double)arc4random() / 0x100000000)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGFloat x = (CGFloat) (arc4random() % (int) self.superview.bounds.size.width);
    CGFloat y = (CGFloat) (arc4random() % (int) self.superview.bounds.size.height);
    
    self.center = CGPointMake(x, y);
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(beginAnimationLoop)];
    
    [UIView commitAnimations];
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    if (isActive)
        [self beginAnimationLoop];
}

@end
