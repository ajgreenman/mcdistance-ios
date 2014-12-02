//
//  AJGTweetViewController.h
//  McDistance
//
//  Created by X Code User on 12/2/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@interface AJGTweetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ACAccount *account;
@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic) int mcDistance;
@property (nonatomic) double units;

@end
