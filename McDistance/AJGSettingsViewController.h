//
//  AJGSettingsViewController.h
//  McDistance
//
//  Created by X Code User on 12/1/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJGSettingsViewController : UIViewController

enum {HIGH, MEDIUM, LOW} typedef Level;
enum {FEET, METERS, KILOMETERS, MILES} typedef Units;

@property (nonatomic) float minimum_distance;
@property (nonatomic) Level accuracy;
@property (nonatomic) Level precision;
@property (nonatomic) Units units;

@end
