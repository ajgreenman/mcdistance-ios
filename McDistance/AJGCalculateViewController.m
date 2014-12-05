//
//  AJGCalculateViewController.m
//  McDistance
//
//  Created by X Code User on 12/3/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGCalculateViewController.h"

@interface AJGCalculateViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mcMapView;

@end

@implementation AJGCalculateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mcMapView addGestureRecognizer:tapRecognizer];
}

-(IBAction)tapMap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.mcMapView];
    CLLocationCoordinate2D coordinate = [self.mcMapView convertPoint:point toCoordinateFromView:self.view];
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = coordinate;
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    [self.mcMapView addAnnotation:point1];
}

@end
