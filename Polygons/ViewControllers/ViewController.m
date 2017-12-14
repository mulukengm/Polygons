//
//  ViewController.m
//  Polygons
//
//  Created by Muluken Gebremariam on 12/13/17.
//  Copyright © 2017 Muluken. All rights reserved.
//

#import "ViewController.h"
#import "SimpleRegularPolygon.h"
#import "PolygonView.h"

@interface ViewController ()

@property NSTimer *timer;
@property PolygonView *polyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.polyView = [[PolygonView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
    self.polyView.center = self.view.center;
    self.polyView.strokeColor = [UIColor redColor];
    self.polyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.polyView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __block int counter = 3;
    [self drawPolygonWithSides:counter];
    counter++;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self drawPolygonWithSides:counter];
        counter++;
        if(counter > 11) {
            counter = 3;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    
    _polyView.polygonPath = NULL;
}

- (void)drawPolygonWithSides:(NSUInteger)numberOfSides {
    SimpleRegularPolygon *polygon = [[SimpleRegularPolygon alloc] initWithCenter:CGPointMake(self.polyView.bounds.size.width/2, self.polyView.bounds.size.width/2) andRadius:self.polyView.bounds.size.width/2 - 2];
    NSError *error;
    [polygon setSides:numberOfSides error:&error];
    
    if(error) {
        NSLog(@"Error setting the number of sides to polygon object. %@", [error localizedDescription] );
    }
    
    CGPathRef polygonPath = [polygon path];
    self.polyView.polygonPath = polygonPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
