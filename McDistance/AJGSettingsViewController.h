//
//  AJGSettingsViewController.h
//  McDistance
//
//  Created by X Code User on 12/1/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJGSettingsViewController : UIViewController

enum Level {HIGH, MEDIUM, LOW} typedef Level;

@property (nonatomic) float minimum_distance;
@property (nonatomic) Level accuracy;
@property (nonatomic) Level precision;

@end
