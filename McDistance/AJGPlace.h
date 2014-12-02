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
@property (nonatomic) Boolean open;
@property (nonatomic) double rating;

- (instancetype) initWithLocation:(CLLocation *) location
                       andAddress:(NSString *) address
                        andRating:(double) rating
                           isOpen:(Boolean) open;

@end
