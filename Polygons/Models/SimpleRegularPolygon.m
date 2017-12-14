//
//  SimpleRegularPolygon.m
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import "SimpleRegularPolygon.h"

@interface SimpleRegularPolygon() {
    NSUInteger _sides;
    CGPoint _center;
    CGFloat _radius;
}
@end

@implementation SimpleRegularPolygon

NSInteger const INVALID_SIDES_COUNT_ERROR_CODE = 101;

- (id)initWithCenter:(CGPoint)center andRadius:(CGFloat)radius {
    if (self = [super init]) {
        _center = center;
        _radius = radius;
        _sides = 3;
        _rotationAngle = 0.0;
    }
    
    return self;
}

- (void)setSides:(NSUInteger)sides error:(NSError **)error {
    if(sides > 2) {
        _sides = sides;
    }
    else {
        if (error != NULL) {
            NSString *errorDescription = NSLocalizedString(@"Invalid argument. Polygons should have at least 3 sides.", nil);
            *error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:INVALID_SIDES_COUNT_ERROR_CODE userInfo:[NSDictionary dictionaryWithObject:errorDescription forKey:NSLocalizedDescriptionKey]];
        }
    }
}

- (NSUInteger)sides {
    return _sides;
}

- (double)centralAngle {
    return 2 * M_PI/_sides;
}

- (CGPathRef)path {
    CGMutablePathRef path = CGPathCreateMutable();
    
    double angle = self.rotationAngle - M_PI/2;
    CGFloat x = _radius * cos(angle) + _center.x;
    CGFloat y =  _center.y - _radius * sin(angle);
    CGPoint vertex = CGPointMake(x, y);

    CGPathMoveToPoint(path, NULL, vertex.x, vertex.y);

    for(int pt = 1; pt < _sides; pt++) {
        vertex = [self getNextPolygonVertexFromVertex:vertex
                                               withSeparationAngle:[self centralAngle]
                                                            Radius:_radius
                                                         andCenter:_center];
        CGPathAddLineToPoint(path, NULL, vertex.x, vertex.y);
    }
    
    CGPathCloseSubpath(path);
    return path;
}

- (CGPoint)getNextPolygonVertexFromVertex:(CGPoint)vertex
                 withSeparationAngle:(double)separationAngle
                              Radius:(CGFloat)radius
                           andCenter:(CGPoint)center {


    double prevVertexAngle = asin((center.y - vertex.y) / radius);
    
    if(vertex.x - center.x < 0) {
        if(center.y - vertex.y < 0) {
            prevVertexAngle -= 2 * (M_PI/2 + prevVertexAngle);
        }
        else if (center.y - vertex.y > 0) {
            prevVertexAngle += 2 * (M_PI/2 - prevVertexAngle);
        }
        else if (center.y - vertex.y == 0) {
            prevVertexAngle += M_PI;
        }
    }
    
    double nextVertexAngle = prevVertexAngle + separationAngle;
    CGFloat x = radius * cos(nextVertexAngle) + center.x;
    CGFloat y = center.y - radius * sin(nextVertexAngle);
    
    return CGPointMake(x, y);
}

@end
