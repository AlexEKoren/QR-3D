//
//  UIImage+CSQRCode.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CSQRCode)

+ (UIImage*)QRCodeForString:(NSString*)string size:(CGFloat)imageSize fillColor:(UIColor*)fillColor;

@end
