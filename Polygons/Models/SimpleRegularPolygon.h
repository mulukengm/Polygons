//
//  SimpleRegularPolygon.h
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSInteger const INVALID_SIDES_COUNT_ERROR_CODE;

@interface SimpleRegularPolygon : NSObject

@property (nonatomic) double rotationAngle;

- (id)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius;

- (NSUInteger)sides;

- (void)setSides:(NSUInteger)sides error:(NSError **)error;

- (double)centralAngle;

- (CGPathRef)path;

@end
