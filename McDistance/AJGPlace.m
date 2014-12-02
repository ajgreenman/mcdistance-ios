//
//  AJGPlace.m
//  McDistance
//
//  Created by X Code User on 11/30/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGPlace.h"

@implementation AJGPlace

- (instancetype) initWithLocation:(CLLocation *) location
                       andAddress:(NSString *) address
                        andRating:(double) rating
                           isOpen:(Boolean) open
{
    self = [super init];
    
    if(self) {
        self.location = location;
        self.address = address;
        self.rating = rating;
        self.open = open;
    }
    
    return self;
}

@end
