//
//  AJGDirectionsViewController.h
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface AJGDirectionsViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocation *source;
@property (nonatomic, strong) CLLocation *destination;

@end
