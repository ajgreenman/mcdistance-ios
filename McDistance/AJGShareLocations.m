//
//  AJGShareLocations.m
//  McDistance
//
//  Created by X Code User on 11/24/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGShareLocations.h"
#import "AJGHomeViewController.h"

@implementation AJGShareLocations

- (instancetype) init
{
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int updates = [[defaults objectForKey:@"location_updates"] integerValue];
        switch(updates) {
            case 0:
                self.locationManager.distanceFilter = 1000.0f;
                break;
            case 1:
                self.locationManager.distanceFilter = 100.0f;
                break;
            case 2:
                self.locationManager.distanceFilter = 10.0f;
                break;
            default:
                self.locationManager.distanceFilter = 100.0f;
                break;
        }
        
        int accuracy = [[defaults objectForKey:@"location_accuracy"] integerValue];
        switch(accuracy) {
            case 0:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            case 1:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            case 2:
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                break;
        }
    }
    
    return self;
}

+ (instancetype) sharedManager
{
    static AJGShareLocations *sharedSingleton;
    
    if(!sharedSingleton) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            sharedSingleton = [[self alloc] init];
        });
    }
    
    return sharedSingleton;
}

#pragma mark CLLocationManagerDelegate

-(void) locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
}

- (void) locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager  {
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newLocationNotification" object:self userInfo:[NSDictionary dictionaryWithObject:location forKey:@"newLocationResult"]];
}

@end
