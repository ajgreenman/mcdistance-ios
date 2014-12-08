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

- (void) setCurrentLocation:(CLLocation *)currentLocation
{
    _currentLocation = currentLocation;
    
    [self updateMap];
}

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
    
    self.mcMapView.delegate = self;
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithTitle:@"McBack" style:UIBarButtonItemStyleBordered target:self action:@selector(popView)];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [self updateMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) updateLocation: (NSNotification *) notification
{
    CLLocation *location = [[notification userInfo] valueForKey:@"newLocationResult"];
    
    self.currentLocation = location;}

- (void) updateMap
{
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = self.destination.location.coordinate;
    point1.title = @"Nearest McDonald's";
    [self.mcMapView addAnnotation:point1];
    
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = self.currentLocation.coordinate;
    point2.title = @"Current Location";
    [self.mcMapView addAnnotation:point2];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.destination.location.coordinate addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    [request setDestination:item];
    [request setTransportType:MKDirectionsTransportTypeAny];
    [request setRequestsAlternateRoutes:YES];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if(!error) {
            [self.mcMapView removeOverlays:self.mcMapView.overlays];
            MKRoute *route = [response.routes firstObject];
            [self.mcMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
        }
    }];
    
    double span = [self.locManager.location distanceFromLocation:self.destination.location] * 2;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locManager.location.coordinate, span, span);
    [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
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

- (void) popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = nil;
    if([annotation isKindOfClass:[MKPointAnnotation class]]) {
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinView"];
            pinView.canShowCallout = YES;
            if([annotation.title  isEqual: @"Nearest McDonald's"]) {
                pinView.pinColor = MKPinAnnotationColorRed;
            } else {
                pinView.pinColor = MKPinAnnotationColorGreen;
            }
        } else {
            pinView.annotation = annotation;
        }
    }
    
    return pinView;
}

@end
