//
//  AJGDirectionsViewController.m
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGDirectionsViewController.h"
#import "AJGShareLocations.h"

@interface AJGDirectionsViewController ()

@property (strong, nonatomic) CLLocationManager *locManager;
@property (weak, nonatomic) IBOutlet MKMapView *mcMapView;

@end

@implementation AJGDirectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.locManager = [AJGShareLocations sharedManager].locationManager;
        
        [self.locManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:@"newLocationNotification" object:nil];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mcMapView.showsUserLocation = YES;
    self.mcMapView.delegate = self;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.destination.coordinate;
    [self.mcMapView addAnnotation:point];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.destination.coordinate addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    [request setDestination:item];
    [request setTransportType:MKDirectionsTransportTypeAny];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if(!error) {
            for(MKRoute *route in [response routes]) {
                [self.mcMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) updateLocation: (NSNotification *) notification
{
    
}

- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor redColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    
    return nil;
}

@end
