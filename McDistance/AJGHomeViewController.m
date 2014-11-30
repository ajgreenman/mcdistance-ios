//
//  AJGHomeViewController.m
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGHomeViewController.h"
#import "AJGDirectionsViewController.h"
#import "AJGHttpCommunicator.h"
#import "AJGShareLocations.h"
#import "AJGPlace.h"

@interface AJGHomeViewController () {
    AJGHttpCommunicator *http;
}

@property (weak, nonatomic) IBOutlet UILabel *mcDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mcConversionLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcCalculateButton;
@property (weak, nonatomic) IBOutlet UIButton *mcDirectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *mcMeetupButton;
@property (weak, nonatomic) IBOutlet UIButton *mcSettingsButton;
@property (weak, nonatomic) IBOutlet MKMapView *mcMapView;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) AJGPlace *nearestMcDonalds;

@end

@implementation AJGHomeViewController

static double minimum_distance = 100.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.locManager = [AJGShareLocations sharedManager].locationManager;
        
        [self.locManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:@"newLocationNotification" object:nil];
        
        self.distanceInMeters = -1;
        self.mcDistance = 1;
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.mcMapView.showsUserLocation = YES;
    self.mcMapView.delegate = self;
    
    [self updateUI];
}

- (IBAction)getDirections:(id)sender {
    AJGDirectionsViewController *dvc = [[AJGDirectionsViewController alloc] init];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void) updateLocation: (NSNotification *) notification
{
    CLLocation *location = [[notification userInfo] valueForKey:@"newLocationResult"];

    self.currentLocation = location;
    
    [self updateUI];
}

- (void) updateUI
{
    if(self.currentLocation) {
        http = [[AJGHttpCommunicator alloc] init];
        
        NSString *apiCall = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&types=food|restaurant&name=McDonald's&rankby=distance&key=AIzaSyBS5rTDOXDQ6sXYBDTyGYUjQpLTe1i90is",
                             self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
        apiCall = [apiCall stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:apiCall];
        
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
                    
                    AJGPlace *nearestPlace = [[AJGPlace alloc] initWithLocation:nearestLocation andAddress:nearestAddress];
                    self.nearestMcDonalds = nearestPlace;
                }                
            }
        }];
        
        if(self.nearestMcDonalds) {
            self.distanceInMeters = [self.nearestMcDonalds.location distanceFromLocation:self.currentLocation];
            
            if(self.distanceInMeters <= minimum_distance) {
                self.mcDistance = 0;
            } else {
                self.mcDistance = 1;
            }
            
            self.mcDistanceLabel.text = [NSString stringWithFormat:@"McDistance: %d", self.mcDistance];
            self.mcConversionLabel.text = [NSString stringWithFormat:@"Meters: %lf", self.distanceInMeters];
        }
    }
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    double span = self.distanceInMeters * 2 + 20.0;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, span, span);
    [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.nearestMcDonalds.location.coordinate;
    
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    [self.mcMapView addAnnotation:point];
}

@end
