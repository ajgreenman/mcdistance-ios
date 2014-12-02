//
//  AJGTweetViewController.m
//  McDistance
//
//  Created by X Code User on 12/2/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGTweetViewController.h"

@interface AJGTweetViewController ()

@end

@implementation AJGTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.accounts = [[NSMutableArray alloc] init];
    [self retrieveAccounts:ACAccountTypeIdentifierTwitter options:nil];
}

- (void) retrieveAccounts:(NSString *) identifier options:(NSDictionary *) options
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:identifier];
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if(granted) {
            [self.accounts addObjectsFromArray:[accountStore accountsWithAccountType:accountType]];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Tableview Delegate / DataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    ACAccount *account = self.accounts[indexPath.row];
    cell.textLabel.text = account.accountDescription;
    return cell;
}

@end
