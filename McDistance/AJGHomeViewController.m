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

@interface AJGHomeViewController () {
    AJGHttpCommunicator *http;
}

@property (weak, nonatomic) IBOutlet UILabel *mcDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mcConversionLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcCalculateButton;
@property (weak, nonatomic) IBOutlet UIButton *mcDirectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *mcMeetupButton;
@property (weak, nonatomic) IBOutlet UIButton *mcSettingsButton;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *nearestMcDonalds;
@end

@implementation AJGHomeViewController

static double minimum_distance = 100.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.locManager = [AJGShareLocations sharedManager].locationManager;
        
        [self addObserver:self.locManager.location forKeyPath:@"location" options:NSKeyValueObservingOptionNew context:NULL];
        
        [self.locManager startUpdatingLocation];
        
        self.distanceInMeters = -1;
        self.mcDistance = 1;
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

- (IBAction)getDirections:(id)sender {
    AJGDirectionsViewController *dvc = [[AJGDirectionsViewController alloc] init];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if([keyPath isEqualToString:@"location"]) {
        [self newLocation:object];
    }
}

- (void) newLocation:(CLLocation *) location
{
    self.currentLocation = location;
    
    NSLog(@"what!!");
    
    [self updateUI];
}
- (IBAction)getLocation:(id)sender {
    NSLog(@"%@", self.locManager.location);
}

- (void) updateUI
{
    if(self.currentLocation) {
        http = [[AJGHttpCommunicator alloc] init];
        NSString *apiCall = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&types=food|restaurant&name=McDonald's&rankby=distance&key=AIzaSyBS5rTDOXDQ6sXYBDTyGYUjQpLTe1i90is",
                             self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
        NSURL *url = [NSURL URLWithString:apiCall];
        [http retrieveUrl:url successBlock:^(NSData *response) {
            NSError *error = nil;
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
            
            if(!error) {
                NSLog(@"%@", data);
            }
        }];
    }
}

@end
