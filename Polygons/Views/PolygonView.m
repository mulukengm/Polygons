//
//  PolygonView.m
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import "PolygonView.h"

@implementation PolygonView

- (id)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]) {
        _fillColor = UIColor.whiteColor;
        _strokeColor = UIColor.blackColor;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if([super initWithCoder:aDecoder]) {
        _fillColor = UIColor.whiteColor;
        _strokeColor = UIColor.blackColor;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void)setPolygonPath:(CGPathRef)polygonPath {
    _polygonPath = polygonPath;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if(self.polygonPath != NULL) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();        
        CGContextAddPath(ctx, self.polygonPath);
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx,self.strokeColor.CGColor);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGPathRelease(self.polygonPath);
    }
}

#pragma mark - Gesture recognizer methods

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    if(self.delegate && [self.delegate respondsToSelector:@selector(polygonViewTapped:)]) {
        [self.delegate polygonViewTapped:self];
    }
}

@end
