//
//  AJGHomeViewController.h
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import "AJGPlace.h"

@interface AJGHomeViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) double distanceInMeters;
@property (nonatomic) int mcDistance;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) AJGPlace *nearestMcDonalds;

@end
