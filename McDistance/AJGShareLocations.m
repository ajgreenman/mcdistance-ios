//
//  AJGShareLocations.m
//  McDistance
//
//  Created by X Code User on 11/24/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGShareLocations.h"

@implementation AJGShareLocations

- (instancetype) init
{
    self = [super init];
    
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100.0f;
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

@end
