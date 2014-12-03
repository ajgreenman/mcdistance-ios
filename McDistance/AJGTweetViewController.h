//
//  AJGTweetViewController.h
//  McDistance
//
//  Created by X Code User on 12/3/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface AJGTweetViewController : UIViewController

@property (nonatomic, strong) ACAccount *account;
@property (nonatomic) int mcDistance;
@property (nonatomic) double units;

@end
