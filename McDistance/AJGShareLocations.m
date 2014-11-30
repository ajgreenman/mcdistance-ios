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
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        NSLog(@"Hiksdf");
        self.activeViews = [[NSMutableArray alloc] init];
        NSLog(@"Hiksdf");
        NSLog(@"Hiksdf");
    }
    
    return self;
}

+ (instancetype) sharedManager
{
    static AJGShareLocations *sharedSingleton;
    NSLog(@"what");
    
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
    NSLog(@"Yay!");
}

- (void) locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager  {
    NSLog(@"Yay!");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newLocationNotification" object:self userInfo:[NSDictionary dictionaryWithObject:location forKey:@"newLocationResult"]];
}

@end
