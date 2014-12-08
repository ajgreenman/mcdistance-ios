//
//  AJGCalculateViewController.m
//  McDistance
//
//  Created by X Code User on 12/3/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGCalculateViewController.h"
#import "AJGHttpCommunicator.h"

@interface AJGCalculateViewController () {
    AJGHttpCommunicator *http;
}

@property (weak, nonatomic) IBOutlet MKMapView *mcMapView;
@property (weak, nonatomic) IBOutlet UILabel *mcDistancesAway;
@property (weak, nonatomic) IBOutlet UILabel *mcMetersAway;
@property (weak, nonatomic) IBOutlet UILabel *mcOtherMcDistance;
@property (weak, nonatomic) IBOutlet UILabel *mcOtherMetersAway;
@property (nonatomic) double minimum_distance;

@end

@implementation AJGCalculateViewController

- (void) setOtherMcLocation:(AJGPlace *)otherMcLocation
{
    _otherMcLocation = otherMcLocation;
    
    [self updateUI];
}

- (void) setOtherLocation:(CLLocation *)otherLocation
{
    _otherLocation = otherLocation;
    
    [self fetchPlace:otherLocation];
}

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
    
    self.mcDistancesAway.text = @"McDistances away from location: ";
    self.mcMetersAway.text = @"Meters away from location:";
    self.mcOtherMcDistance.text = @"Other location's McDistance:";
    self.mcOtherMetersAway.text = @"Other location's McDistance in meters:";
    self.minimum_distance = 50.0;
    
    [self updateUI];
}

-(IBAction)tapMap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.mcMapView];
    CLLocationCoordinate2D coordinate = [self.mcMapView convertPoint:point toCoordinateFromView:self.mcMapView];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    self.otherLocation = location;
}

- (void) fetchPlace:(CLLocation *) location 
{
    http = [[AJGHttpCommunicator alloc] init];
    
    NSString *apiCall = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&types=food|restaurant&name=McDonald's&rankby=distance&key=AIzaSyBS5rTDOXDQ6sXYBDTyGYUjQpLTe1i90is",
                         self.otherLocation.coordinate.latitude, self.otherLocation.coordinate.longitude];
    apiCall = [apiCall stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:apiCall];
    
    self.otherMcLocation = nil;
    
    [http retrieveUrl:url successBlock:^(NSData *response) {
        NSError *error = nil;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if(!error) {
            NSArray *results = data[@"results"];
            
            if(results.count > 0) {
                NSDictionary *nearest = results[0];
                NSDictionary *coordinates = nearest[@"geometry"][@"location"];
                
                double latitude = [coordinates[@"lat"] doubleValue];
                double longitude = [coordinates[@"lng"] doubleValue];
                
                CLLocation *nearestLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                NSString *nearestAddress = nearest[@"address"];
                
                double rating = [nearest[@"rating"] doubleValue];
                
                Boolean isOpen = (Boolean) nearest[@"opening_hours"][@"open_now"];
                
                AJGPlace *nearestPlace = [[AJGPlace alloc] initWithLocation:nearestLocation andAddress:nearestAddress andRating:rating isOpen:isOpen];
                self.otherMcLocation = nearestPlace;
            }
        }
        
        if(!self.otherMcLocation) {
            CLLocation *home = [[CLLocation alloc] initWithLatitude:44.763875 longitude:-85.606974];
            AJGPlace *homePlace = [[AJGPlace alloc] initWithLocation:home andAddress:@"710 East Front Street, Traverse City, MI 49686" andRating:3.2 isOpen:YES];
            self.otherMcLocation = homePlace;
        }
    }];
}

- (void) updateUI
{    
    double span = [self findFarthestDistance] * 2 + 20.0;
    
    if(!span || span < 0) {
        span = 2000.0;
    }
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, span, span);
    [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = self.currentMcLocation.location.coordinate;
    point1.title = @"Nearest McDonald's";
    
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = self.currentLocation.coordinate;
    point2.title = @"Your Location";
    
    [points addObject:point1];
    [points addObject:point2];
    
    if(self.otherMcLocation) {
        MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
        point3.coordinate = self.otherMcLocation.location.coordinate;
        point3.title = @"Other Location's Nearest McDonald's";
        
        MKPointAnnotation *point4 = [[MKPointAnnotation alloc] init];
        point4.coordinate = self.otherLocation.coordinate;
        point4.title = @"Other Location";
        
        [points addObject:point3];
        [points addObject:point4];
    }
    
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    [self.mcMapView addAnnotations:points];
    
    double myDistance = [self.currentLocation distanceFromLocation:self.currentMcLocation.location];
    double distanceBetween;
    if(self.otherLocation) {
        distanceBetween = [self.currentLocation distanceFromLocation:self.otherLocation];
    } else {
        distanceBetween = 0;
    }
    
    NSString *mcAway = [NSString stringWithFormat:@"McDistances away from location: %.02lf", distanceBetween / myDistance];
    NSString *mcBetween = [NSString stringWithFormat:@"Meters away from location: %.02lf", distanceBetween];
    double otherDistance = [self.otherLocation distanceFromLocation:self.otherMcLocation.location];
    NSString *mcOtherAway = [NSString stringWithFormat:@"Other location's McDistance in meters: %.02lf", otherDistance];
    int mcDistance;
    if(otherDistance <= self.minimum_distance) {
        mcDistance = 0;
    } else {
        mcDistance = 1;
    }
    NSString *mcOtherDistance = [NSString stringWithFormat:@"Other location's McDistance: %d", mcDistance];
    self.mcDistancesAway.text = mcAway;
    self.mcMetersAway.text = mcBetween;
    self.mcOtherMcDistance.text = mcOtherDistance;
    self.mcOtherMetersAway.text = mcOtherAway;
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
            if([annotation.title  isEqual: @"Nearest McDonald's"] || [annotation.title isEqual: @"Other Location's Nearest McDonald's"]) {
                pinView.pinColor = MKPinAnnotationColorRed;
            } else if([annotation.title  isEqual: @"Your Location"]) {
                pinView.pinColor = MKPinAnnotationColorGreen;
            } else {
                pinView.pinColor = MKPinAnnotationColorPurple;
            }
        } else {
            pinView.annotation = annotation;
        }
    }
    
    return pinView;
}



- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self updateUI];
}

- (double) findFarthestDistance
{
    double distance = 0;
    double tempDistance;
    
    NSArray *points = [NSArray arrayWithObjects:self.currentLocation, self.currentMcLocation.location, self.otherLocation, self.otherMcLocation.location, nil];
    
    for(CLLocation *location1 in points) {
        for(CLLocation *location2 in points) {
            tempDistance = [location1 distanceFromLocation:location2];
            
            if(tempDistance > distance) {
                distance = tempDistance;
            }
        }
    }
    
    return distance;
}

@end
