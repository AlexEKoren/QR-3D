//
//  UIImage+CSQRCode.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "UIImage+CSQRCode.h"
#import "qrencode.h"

@implementation UIImage (CSQRCode)

+ (void)drawQRCode:(QRcode*)code context:(CGContextRef)context size:(CGFloat)size fillColor:(UIColor*)fillColor {
    unsigned char *data = code->data;
    int width = code->width;
    
    NSInteger pixelSize = size / width;
    CGRect rectDraw = CGRectMake(0.0f, 0.0f, pixelSize, pixelSize);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    for (CGFloat i = 0; i < pixelSize * width; i+= pixelSize) {
        for (CGFloat j = 0; j < pixelSize * width; j+= pixelSize) {
            if (*data & 1) {
                rectDraw.origin = CGPointMake(j, i);
                CGContextAddRect(context, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(context);
}

+ (UIImage*)QRCodeForString:(NSString*)string size:(CGFloat)imageSize fillColor:(UIColor*)fillColor {
    if (string.length == 0)
        return nil;
    
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code)
        return nil;
    
    CGFloat size = ceil(imageSize) * [UIScreen mainScreen].scale;
    if (code->width > size)
        return nil;
    
    int width = code->width;
    NSInteger pixelSize = size / width;
    size = pixelSize * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scale = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(context, CGAffineTransformConcat(translate, scale));
    
    [self drawQRCode:code context:context size:size fillColor:fillColor];
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *image= [UIImage imageWithCGImage:cgImage];
    
    CGContextRelease(context);
    CGImageRelease(cgImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return image;
}

@end
