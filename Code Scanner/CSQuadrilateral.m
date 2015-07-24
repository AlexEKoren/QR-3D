//
//  CSQuadrilateral.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CSQuadrilateral.h"

@implementation CSQuadrilateral

+ (CSQuadrilateral*)shift:(CSQuadrilateral*)quadrilateral by:(CGPoint)shift {
    CSQuadrilateral *quad = [CSQuadrilateral new];
    quad.topLeft = CGPointMake(quadrilateral.topLeft.x + shift.x, quadrilateral.topLeft.y + shift.y);
    quad.topRight = CGPointMake(quadrilateral.topRight.x + shift.x, quadrilateral.topRight.y + shift.y);
    quad.bottomLeft = CGPointMake(quadrilateral.bottomLeft.x + shift.x, quadrilateral.bottomLeft.y + shift.y);
    quad.bottomRight = CGPointMake(quadrilateral.bottomRight.x + shift.x, quadrilateral.bottomRight.y + shift.y);
    return quad;
}

- (CGPoint)center {
    CGFloat dx = self.bottomRight.x - self.topLeft.x;
    CGFloat dy = self.bottomRight.y - self.topLeft.y;
    return CGPointMake(self.topLeft.x + dx / 2, self.topLeft.y + dy / 2);
}

@end
