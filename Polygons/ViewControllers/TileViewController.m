//
//  TileViewController.m
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import "TileViewController.h"
#import "SimpleRegularPolygon.h"
#import "PolygonView.h"
#import "PolygonCollectionViewCell.h"

static int const COLUMN_COUNT = 8;
static int const POLYGON_PADDING = 1;
static CGFloat const MIN_SPACING = 0.0;
static double const ROTATION_INCREMENT_ANGLE = 0.08;

@interface TileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, PolygonCollectionViewCellDelegate> {
    NSMutableArray *_polygons;
    NSMutableArray *_polygonFillColors;
    NSMutableArray *_polygonStrokeColors;
    NSMutableSet *_indexesToRotate;
    CADisplayLink *_displayLink;
}

@property (weak, nonatomic) IBOutlet UICollectionView *tileView;

@end

@implementation TileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _polygons = [[NSMutableArray alloc] init];
    _polygonFillColors = [[NSMutableArray alloc] init];
    _polygonStrokeColors = [[NSMutableArray alloc] init];
    _indexesToRotate = [[NSMutableSet alloc] init];

    [self.tileView registerClass:[PolygonCollectionViewCell class] forCellWithReuseIdentifier:[PolygonCollectionViewCell identifier]];
    
    NSArray *colors = @[UIColor.blackColor, UIColor.redColor, UIColor.greenColor, UIColor.blueColor, UIColor.cyanColor, UIColor.yellowColor, UIColor.magentaColor,  UIColor.orangeColor, UIColor.purpleColor, UIColor.brownColor];

    
    for(int i = 0; i < COLUMN_COUNT * COLUMN_COUNT; i++) {
        
        int numberOfSides = [self getRandomNumberFrom:3 to: 8];
        CGFloat radius =  self.tileView.bounds.size.width/(2 * COLUMN_COUNT) - (2 * POLYGON_PADDING);

        SimpleRegularPolygon *polygon = [[SimpleRegularPolygon alloc] initWithCenter:CGPointMake(radius + POLYGON_PADDING, radius + POLYGON_PADDING) andRadius:radius];
        
        NSError *error;
        [polygon setSides:numberOfSides error:&error];
        
        if(error) {
            NSLog(@"Error setting number of sides to polygon object %@", [error localizedDescription] );
        }
        
        [_polygons addObject:polygon];
        
        UIColor * fillColor = [colors objectAtIndex:[self getRandomNumberFrom:0 to: (int)colors.count - 1]];
        [_polygonFillColors addObject:fillColor];
        
        UIColor * strokeColor = [colors objectAtIndex:[self getRandomNumberFrom:0 to: (int)colors.count - 1]];
        [_polygonStrokeColors addObject:strokeColor];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(performDisplayUpdates)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper methods

- (int)getRandomNumberFrom:(int)from to:(int)to {
    return (int)from + arc4random() % (to - from + 1);
}

- (NSSet *)getPolygonsToRotateWithCenterAtIndex:(NSInteger)index {
    NSMutableSet *polySet = [[NSMutableSet alloc] init];
    
    //center
    [polySet addObject:[NSNumber numberWithInteger:index]];

    //top
    if(index >= COLUMN_COUNT) {
        NSInteger topIndex = index - COLUMN_COUNT;
        [polySet addObject:[NSNumber numberWithInteger:topIndex]];
    }
    
    //right
    if(index % COLUMN_COUNT != 7) {
        NSInteger rightIndex = index + 1;
        [polySet addObject:[NSNumber numberWithInteger:rightIndex]];
    }
    
    //bottom
    if(index < COLUMN_COUNT * (COLUMN_COUNT - 1)) {
        NSInteger bottomIndex = index + COLUMN_COUNT;
        [polySet addObject:[NSNumber numberWithInteger:bottomIndex]];
    }
    
    //left
    if(index % COLUMN_COUNT != 0) {
        NSInteger leftIndex = index - 1;
        [polySet addObject:[NSNumber numberWithInteger:leftIndex]];
    }
    
    return polySet;
}

- (void)performDisplayUpdates {
    NSSet *indexes = [NSSet setWithSet:_indexesToRotate];
    
    for(NSNumber *number in indexes){
        NSInteger index = [number integerValue];
        SimpleRegularPolygon *polygon = [_polygons objectAtIndex:index];
        polygon.rotationAngle -= ROTATION_INCREMENT_ANGLE;
        
        if(polygon.rotationAngle < -2 * M_PI) {
            polygon.rotationAngle = 0.0;
            [_indexesToRotate removeObject:number];
        }
        
        PolygonCollectionViewCell *cell = (PolygonCollectionViewCell *)[self.tileView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[number integerValue] inSection:0]];
        cell.polygonView.polygonPath = polygon.path;
    }    
}

- (void)stopAllRotatingPolygons {
    
    NSSet *indexes = [NSSet setWithSet:_indexesToRotate];
    for(NSNumber *number in indexes){
        NSInteger index = [number integerValue];
        SimpleRegularPolygon *polygon = [_polygons objectAtIndex:index];
        polygon.rotationAngle = 0.0;
        
        PolygonCollectionViewCell *cell = (PolygonCollectionViewCell *)[self.tileView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[number integerValue]
                                                                                                                                inSection:0]];
        cell.polygonView.polygonPath = polygon.path;
    }
    
    [_indexesToRotate removeAllObjects];
}

#pragma mark - UICollectionView data source methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SimpleRegularPolygon *polygon = [_polygons objectAtIndex:indexPath.row];
    CGPathRef polygonPath = [polygon path];
    UIColor *fillColor = [_polygonFillColors objectAtIndex:indexPath.row];
    UIColor *strokeColor = [_polygonStrokeColors objectAtIndex:indexPath.row];

    PolygonCollectionViewCell *cell = [self.tileView dequeueReusableCellWithReuseIdentifier:[PolygonCollectionViewCell identifier] forIndexPath:indexPath];
    cell.polygonView.polygonPath = polygonPath;
    cell.polygonView.fillColor = fillColor;
    cell.polygonView.strokeColor = strokeColor;
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _polygons.count;
}

#pragma mark - UICollectionView delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.tileView.bounds.size.width / COLUMN_COUNT, self.tileView.bounds.size.width / COLUMN_COUNT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return MIN_SPACING;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.tileView.bounds.size.height / COLUMN_COUNT - self.tileView.bounds.size.width / COLUMN_COUNT;
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    PolygonCollectionViewCell *polyCell = (PolygonCollectionViewCell *)cell;
    [polyCell.polygonView setNeedsDisplay];
}

#pragma mark - PolygonCollectionViewCell delegate methods

- (void)polygonCollectionViewCellTapped:(PolygonCollectionViewCell*)cell {
    NSIndexPath *indexPath = [self.tileView indexPathForCell:cell];
    if (indexPath) {
        [self stopAllRotatingPolygons];
        _indexesToRotate = [[self getPolygonsToRotateWithCenterAtIndex:indexPath.row] mutableCopy];
    }
}

@end
