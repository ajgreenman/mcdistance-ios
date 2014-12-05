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
    
    [self updateUI];
}

-(IBAction)tapMap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.mcMapView];
    CLLocationCoordinate2D coordinate = [self.mcMapView convertPoint:point toCoordinateFromView:self.view];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    self.otherLocation = location;
    
    [self fetchPlace:location];
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
        
        [self updateUI];
    }];
}

- (void) updateUI
{
    NSLog(@"My Location: %lf, %lf", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    NSLog(@"Nearest McDonald's: %lf, %lf", self.currentMcLocation.location.coordinate.latitude, self.currentMcLocation.location.coordinate.longitude);
    NSLog(@"Point Location: %lf, %lf", self.otherLocation.coordinate.latitude, self.otherLocation.coordinate.longitude);
    NSLog(@"Point's Nearest McDonald's: %lf, %lf", self.otherMcLocation.location.coordinate.latitude, self.otherMcLocation.location.coordinate.longitude);
    
    double span = [self findFarthestDistance] * 2 + 20.0;
    
    if(!span || span < 0) {
        span = 2000.0;
    }
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, span, span);
    [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = self.currentMcLocation.location.coordinate;
    
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = self.currentLocation.coordinate;
    
    [points addObject:point1];
    [points addObject:point2];
    
    if(self.otherMcLocation) {
        MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
        point3.coordinate = self.otherMcLocation.location.coordinate;
        
        MKPointAnnotation *point4 = [[MKPointAnnotation alloc] init];
        point4.coordinate = self.otherLocation.coordinate;
        
        [points addObject:point3];
        [points addObject:point4];
    }
    
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    [self.mcMapView addAnnotations:points];
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
