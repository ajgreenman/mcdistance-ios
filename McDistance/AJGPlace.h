//
//  AJGPlace.h
//  McDistance
//
//  Created by X Code User on 11/30/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AJGPlace : NSObject

@property (nonatomic) CLLocation *location;
@property (nonatomic, strong) NSString *address;

- (instancetype) initWithLocation:(CLLocation *) location andAddress:(NSString *) address;

@end
