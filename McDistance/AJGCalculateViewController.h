//
//  AJGCalculateViewController.h
//  McDistance
//
//  Created by X Code User on 12/3/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AJGPlace.h"

@interface AJGCalculateViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) double selfDistance;
@property (nonatomic) int selfMcDistance;
@property (nonatomic) double otherDistance;
@property (nonatomic) int otherMcDistance;
@property (nonatomic) double mcDistanceAway;
@property (nonatomic) double distanceAway;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) AJGPlace *currentMcLocation;
@property (nonatomic, readonly) CLLocation *otherLocation;
@property (nonatomic, readonly) AJGPlace *otherMcLocation;

@end
