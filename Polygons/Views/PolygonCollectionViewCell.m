//
//  PolygonCollectionViewCell.m
//  Polygons
//
//  Created by Muluken Gebremariam on 12/14/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import "PolygonCollectionViewCell.h"

@implementation PolygonCollectionViewCell

+ (NSString *)identifier {
    return @"PolygonCollectionViewCell";
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _polygonView = [[PolygonView alloc] init];
        _polygonView.backgroundColor = [UIColor whiteColor];
        _polygonView.delegate = self;
        [self.contentView addSubview:self.polygonView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if([super initWithCoder:aDecoder]) {
        _polygonView = [[PolygonView alloc] init];
        _polygonView.backgroundColor = [UIColor whiteColor];
        _polygonView.delegate = self;
        [self.contentView addSubview:self.polygonView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _polygonView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

#pragma mark - PolygonView delegate methods

- (void)polygonViewTapped:(PolygonView*)polygonView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(polygonCollectionViewCellTapped:)]) {
        [self.delegate polygonCollectionViewCellTapped:self];
    }
}

@end
