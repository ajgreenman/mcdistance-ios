//
//  AJGHomeViewController.m
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGHomeViewController.h"
#import "AJGCalculateViewController.h"
#import "AJGDirectionsViewController.h"
#import "AJGSettingsViewController.h"
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
@property (strong, nonatomic) NSString *tweetMessage;
@property (nonatomic) double minimum_distance;

@end

@implementation AJGHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.locManager = [AJGShareLocations sharedManager].locationManager;
        
        [self.locManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:) name:@"newLocationNotification" object:nil];
        
        self.distanceInMeters = -1;
        self.mcDistance = 1;
        self.minimum_distance = 50.0;
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

- (IBAction)mcCalculate:(id)sender {
    AJGCalculateViewController *cvc = [[AJGCalculateViewController alloc] init];
    cvc.selfDistance = self.distanceInMeters;
    cvc.selfMcDistance = self.mcDistance;
    cvc.currentMcLocation = self.nearestMcDonalds;
    cvc.currentLocation = self.currentLocation;
    
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)getDirections:(id)sender {
    AJGDirectionsViewController *dvc = [[AJGDirectionsViewController alloc] init];
    dvc.destination = self.nearestMcDonalds;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)tweetMcDistance:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *view = [SLComposeViewController
                                         composeViewControllerForServiceType:SLServiceTypeTwitter];
        [view setInitialText:self.tweetMessage];
        [self presentViewController:view animated:YES completion:^{}];
    }
}

- (void) updateLocation: (NSNotification *) notification
{
    CLLocation *location = [[notification userInfo] valueForKey:@"newLocationResult"];

    self.currentLocation = location;
    
    [self updateUI];
}

- (void) updateUI
{
    NSLog(@"Woo");
    if(self.currentLocation) {
        
        [self fetchPlace:self.currentLocation];
        
        if(self.nearestMcDonalds) {
            self.distanceInMeters = [self.nearestMcDonalds.location distanceFromLocation:self.currentLocation];
            
            if(self.distanceInMeters <= self.minimum_distance) {
                self.mcDistance = 0;
            } else {
                self.mcDistance = 1;
            }
            
            self.mcDistanceLabel.text = [NSString stringWithFormat:@"McDistance: %d", self.mcDistance];
            self.mcConversionLabel.text = [NSString stringWithFormat:@"Meters: %lf", self.distanceInMeters];
            
            if(self.mcDistance == 0) {
                self.tweetMessage = [NSString stringWithFormat:@"My McDistance is 0!"];
            } else {
                self.tweetMessage = [NSString stringWithFormat:@"My McDistance is 1! I am %lf meters away from the nearest McDonald's.", self.distanceInMeters];
            }
        }
    }
}

- (void) fetchPlace:(CLLocation *) location
{
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
                
                double rating = [nearest[@"rating"] doubleValue];
                
                Boolean isOpen = (Boolean) nearest[@"opening_hours"][@"open_now"];
                
                AJGPlace *nearestPlace = [[AJGPlace alloc] initWithLocation:nearestLocation andAddress:nearestAddress andRating:rating isOpen:isOpen];
                self.nearestMcDonalds = nearestPlace;
            }
        }
        
        if(!self.nearestMcDonalds) {
            CLLocation *home = [[CLLocation alloc] initWithLatitude:44.763875 longitude:-85.606974];
            AJGPlace *homePlace = [[AJGPlace alloc] initWithLocation:home andAddress:@"710 East Front Street, Traverse City, MI 49686" andRating:3.2 isOpen:YES];
            self.nearestMcDonalds = homePlace;
        }
    }];
}

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    double span = self.distanceInMeters * 2 + 20.0;
    
    if(!span || span < 0) {
        span = 1000.0;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, span, span);
    [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = self.nearestMcDonalds.location.coordinate;
    
    [self.mcMapView removeAnnotations:self.mcMapView.annotations];
    [self.mcMapView addAnnotation:point];
    
    [self updateUI];
}

@end
