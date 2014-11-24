//
//  AJGHttpCommunicator.m
//  McDistance
//
//  Created by X Code User on 11/24/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGHttpCommunicator.h"
#import "AJGAppDelegate.h"

@interface AJGHttpCommunicator()

@property (nonatomic, copy) void (^successBlock) (NSData *);

@end

@implementation AJGHttpCommunicator

- (void) retrieveUrl:(NSURL *) url successBlock:(void (^) (NSData *)) successBlock
{
    self.successBlock = successBlock;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

- (void) URLSession:(NSURLSession *) session downloadTask:(NSURLSessionDownloadTask *) downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });
}

@end
