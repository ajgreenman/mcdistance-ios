//
//  AJGTweetViewController.m
//  McDistance
//
//  Created by X Code User on 12/3/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGTweetViewController.h"

@interface AJGTweetViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mcTweetField;
@property (weak, nonatomic) IBOutlet UIButton *mcTweet;
@property (strong, nonatomic) NSString *tweetMessage;

@end

@implementation AJGTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweet Your McDistance";
    
    if(self.mcDistance == 0) {
        self.tweetMessage = [NSString stringWithFormat:@"My McDistance is 0!"];
    } else {
        self.tweetMessage = [NSString stringWithFormat:@"My McDistance is 1! I am %lf meters away from the nearest McDonald's.", self.units];
    }
    
    NSLog(@"%@, %d", self.tweetMessage, self.mcDistance);
    
    self.mcTweetField.text = self.tweetMessage;
}

@end
