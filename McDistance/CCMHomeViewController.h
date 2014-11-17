//
//  CCMHomeViewController.h
//  McDistance
//
//  Created by X Code User on 10/15/14.
//  Copyright (c) 2014 Cherry Capital Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCMHomeViewController : UIViewController

typedef enum {
    FEET, METERS, MILES, KILOMETERS
} Units;

@property (strong, nonatomic) NSNumber *distanceAway;
@property (strong, nonatomic) NSNumber *mcDistanceValue;
@property (strong, nonatomic) NSNumber *conversionValue;
@property (strong, nonatomic) NSNumber *minDistanceAway; // In meters.
@property (nonatomic) Units unit;

- (instancetype) init;
- (void) update;

@end
