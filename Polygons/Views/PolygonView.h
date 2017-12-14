//
//  PolygonView.h
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PolygonView;

@protocol PolygonViewDelegate <NSObject>

- (void)polygonViewTapped:(PolygonView*)polygonView;

@end

@interface PolygonView : UIView

@property (nonatomic) CGPathRef polygonPath;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic, weak) id<PolygonViewDelegate> delegate;

@end
