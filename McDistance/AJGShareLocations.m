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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100.0;
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
