//
//  AJGShareLocations.h
//  McDistance
//
//  Created by X Code User on 11/24/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AJGShareLocations : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *activeViews;

+ (instancetype) sharedManager;

@end
