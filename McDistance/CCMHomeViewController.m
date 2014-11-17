//
//  CCMHomeViewController.m
//  McDistance
//
//  Created by X Code User on 10/15/14.
//  Copyright (c) 2014 Cherry Capital Mobile. All rights reserved.
//

#import "CCMHomeViewController.h"

@interface CCMHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mcDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *conversionLabel;
@property (weak, nonatomic) IBOutlet UIButton *mcCalculateButton;
@property (weak, nonatomic) IBOutlet UIButton *mcDirectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *mcMeetupButton;
@property (weak, nonatomic) IBOutlet UIButton *mcSettingsButton;

@end

@implementation CCMHomeViewController

- (instancetype) init
{
    self = [super init];
    
    if(self) {
        self.mcDistanceValue = @(1.0);
        self.minDistanceAway = @(50);
        self.unit = MILES;
    }
    
    return self;
}

- (void) update
{
    if(self.distanceAway <= self.minDistanceAway) {
        self.mcDistanceValue = @(0.0);
    } else {
        self.mcDistanceValue = @(1.0);
    }
    
    [self updateLabels];
}

- (void) updateLabels
{
    self.mcDistanceLabel.text = [NSString stringWithFormat:@"McDistance: %@", self.mcDistanceValue];
    
    NSString *string = @"";
    
    switch(self.unit) {
        case FEET:
            [string stringByAppendingString:@"Feet: "];
            break;
        case METERS:
            [string stringByAppendingString:@"Meters: "];
            break;
        case MILES:
            [string stringByAppendingString:@"Miles: "];
            break;
        case KILOMETERS:
            [string stringByAppendingString:@"Kilometers: "];
            break;
    }
    
    NSString *value = [NSString stringWithFormat:@"%@", self.conversionValue];
    self.conversionLabel.text = [string stringByAppendingString:value];
}

@end
