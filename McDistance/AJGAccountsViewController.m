//
//  AJGTweetViewController.m
//  McDistance
//
//  Created by X Code User on 12/2/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGAccountsViewController.h"
#import "AJGTweetViewController.h"

@interface AJGAccountsViewController ()

@end

@implementation AJGAccountsViewController

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
    
    self.title = @"Choose Account";
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedIndex = self.tableView.indexPathForSelectedRow;
    ACAccount *account = [self.accounts objectAtIndex:selectedIndex.row];
    
    AJGTweetViewController *tvc = [[AJGTweetViewController alloc] init];
    tvc.account = account;
    tvc.mcDistance = self.mcDistance;
    tvc.units = self.units;
    
    [self.navigationController pushViewController:tvc animated:YES];    
}

@end
