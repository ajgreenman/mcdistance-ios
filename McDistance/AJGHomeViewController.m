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
#import "AJGHttpCommunicator.h"
#import "AJGShareLocations.h"

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
@property (strong, nonatomic) NSString *tweetMessage;
@property (nonatomic) double minimum_distance;

@end

@implementation AJGHomeViewController

- (void) setNearestMcDonalds:(AJGPlace *)nearestMcDonalds
{
    _nearestMcDonalds = nearestMcDonalds;
    
    [self updateUI];
}

- (void) setCurrentLocation:(CLLocation *)currentLocation
{
    _currentLocation = currentLocation;
    
    [self fetchPlace:currentLocation];
}

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
    
    self.mcMapView.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.minimum_distance = [[defaults objectForKey:@"radius_preference"] doubleValue];
    
    [self getLastLocation];
}

- (void) getLastLocation
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSURL *cache = [fm URLForDirectory:NSCachesDirectory
                              inDomain:NSUserDomainMask
                     appropriateForURL:nil
                                create:YES
                                 error:&error];
    
    if(!error) {
        NSURL *locationFolder = [cache URLByAppendingPathComponent:@"location"];
        BOOL ok = [fm createDirectoryAtURL:locationFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if(ok) {
            NSURL *last = [locationFolder URLByAppendingPathComponent:@"last_location.txt"];
            NSString *contents = [NSString stringWithContentsOfURL:last encoding:NSUTF8StringEncoding error:&error];
            NSArray *latLong = [contents componentsSeparatedByString:@", "];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[(NSString *)[latLong firstObject] doubleValue]
                                                              longitude:[(NSString *) [latLong lastObject] doubleValue]];
            
            if(location) {
                self.currentLocation = location;
            }
        }
    }
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
    dvc.currentLocation = self.currentLocation;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (IBAction)tweetMcDistance:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *view = [SLComposeViewController
                                         composeViewControllerForServiceType:SLServiceTypeTwitter];
        [view setInitialText:self.tweetMessage];
        [self presentViewController:view animated:YES completion:^{}];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Available Accounts" message:@"You must have at least one registered Twitter account to access this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) updateLocation: (NSNotification *) notification
{
    CLLocation *location = [[notification userInfo] valueForKey:@"newLocationResult"];

    self.currentLocation = location;
}

- (void) updateUI
{
    if(self.currentLocation) {
        
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
            
            double span = self.distanceInMeters * 2 + 20.0;
            
            if(!span || span < 0) {
                span = 1000.0;
            }
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, span, span);
            [self.mcMapView setRegion:[self.mcMapView regionThatFits:region] animated:YES];
            
            MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
            point1.coordinate = self.nearestMcDonalds.location.coordinate;
            point1.title = @"Nearest McDonald's";
            
            MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
            point2.coordinate = self.currentLocation.coordinate;
            point2.title = @"Current Location";
            
            [self.mcMapView removeAnnotations:self.mcMapView.annotations];
            [self.mcMapView addAnnotation:point1];
            [self.mcMapView addAnnotation:point2];
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
    [self updateUI];
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
