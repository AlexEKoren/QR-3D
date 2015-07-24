//
//  CALayer+CSQuadrilateral.h
//  Code Scanner
//
//  Created by Alex Koren on 7/24/15.
//  Copyright (c) 2015 Alex Koren. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CSQuadrilateral.h"

@interface CALayer (CSQuadrilateral)

@property (nonatomic, strong) CSQuadrilateral *quadrilateral;

@end
