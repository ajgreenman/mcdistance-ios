//
//  AJGHttpCommunicator.h
//  McDistance
//
//  Created by X Code User on 11/24/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJGHttpCommunicator : NSObject <NSURLSessionDataDelegate>

- (void) retrieveUrl:(NSURL* )url successBlock:(void (^) (NSData*))successBlock;

@end
