//
//  AJGHomeViewController.h
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AJGHomeViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) double distanceInMeters;
@property (nonatomic) int mcDistance;

@end
