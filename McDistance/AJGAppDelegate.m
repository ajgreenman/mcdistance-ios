//
//  AJGAppDelegate.m
//  McDistance
//
//  Created by X Code User on 11/21/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGAppDelegate.h"
#import "AJGHomeViewController.h"

@implementation AJGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.hvc = [[AJGHomeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.hvc];
    self.window.rootViewController = navController;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    CLLocation *location = self.hvc.currentLocation;
    
    NSLog(@"%lf", location.coordinate.latitude);
    
    [self cacheLocation:location];
}

- (void) cacheLocation: (CLLocation *) location
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSURL *cache = [fm URLForDirectory:NSCachesDirectory
                              inDomain:NSUserDomainMask
                     appropriateForURL:nil
                                create:YES
                                 error:&error];
    
    if(!error) {
        NSURL *locationFolder = [cache URLByAppendingPathComponent:@"location"];
        BOOL ok = [fm createDirectoryAtURL:locationFolder withIntermediateDirectories:YES attributes:nil error:&error];
        
        if(ok) {
            NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:location, nil];
            [data writeToURL:[locationFolder URLByAppendingPathComponent:@"last_location.txt"] atomically:NO];
        }
    }
}

@end
