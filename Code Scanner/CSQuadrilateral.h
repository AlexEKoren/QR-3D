//
//  CSQuadrilateral.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSQuadrilateral : NSObject

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomLeft;
@property (nonatomic) CGPoint bottomRight;

@property (nonatomic, readonly) CGPoint center;

+ (CSQuadrilateral *)shift:(CSQuadrilateral*)quadrilateral by:(CGPoint)shift;

@end
