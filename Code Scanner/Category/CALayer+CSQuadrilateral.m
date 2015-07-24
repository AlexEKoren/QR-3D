//
//  CALayer+CSQuadrilateral.m
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import "CALayer+CSQuadrilateral.h"

@implementation CALayer (CSQuadrilateral)

- (CSQuadrilateral*)quadrilateral {
    return nil;
}

- (void)setQuadrilateral:(CSQuadrilateral *)quadrilateral {
    CSQuadrilateral *innerQuadrilateral = [CSQuadrilateral shift:quadrilateral by:CGPointMake(-self.position.x, -self.position.y)];
    CATransform3D t = [self transformForQuadrilateral:innerQuadrilateral];
    self.transform = t;
}

- (CATransform3D)transformForQuadrilateral:(CSQuadrilateral*)q {
    double W = [self convertFloatToDouble:self.bounds.size.width];
    double H = [self convertFloatToDouble:self.bounds.size.height];
    
    double x1a = [self convertFloatToDouble:q.topLeft.x];
    double y1a = [self convertFloatToDouble:q.topLeft.y];
    
    double x2a = [self convertFloatToDouble:q.topRight.x];
    double y2a = [self convertFloatToDouble:q.topRight.y];
    
    double x3a = [self convertFloatToDouble:q.bottomLeft.x];
    double y3a = [self convertFloatToDouble:q.bottomLeft.y];
    
    double x4a = [self convertFloatToDouble:q.bottomRight.x];
    double y4a = [self convertFloatToDouble:q.bottomRight.y];
    
    double y21 = y2a - y1a;
    double y32 = y3a - y2a;
    double y43 = y4a - y3a;
    double y14 = y1a - y4a;
    double y31 = y3a - y1a;
    double y42 = y4a - y2a;
    
    double a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    double b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    double c = - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43);
    
    double d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    double e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    double f = -(W*(x4a*(H*y1a*y32) - x3a*(H)*y1a*y42 + H*x2a*y1a*y43));
    
    double g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    double h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    double i = H*(W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const double kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon)
    {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}

- (double)convertFloatToDouble:(float)value {
    return [[NSString stringWithFormat:@"%f", value] doubleValue];
}

@end
