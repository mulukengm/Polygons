//
//  PolygonCollectionViewCell.h
//  Polygons
//
//  Created by Muluken Gebremariam on 12/14/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolygonView.h"

@class PolygonCollectionViewCell;

@protocol PolygonCollectionViewCellDelegate <NSObject>

- (void)polygonCollectionViewCellTapped:(PolygonCollectionViewCell*)cell;

@end

@interface PolygonCollectionViewCell : UICollectionViewCell <PolygonViewDelegate>

@property (readonly) PolygonView *polygonView;

@property (nonatomic, weak) id<PolygonCollectionViewCellDelegate> delegate;

+ (NSString *)identifier;

@end
