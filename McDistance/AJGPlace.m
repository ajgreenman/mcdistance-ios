//
//  AJGPlace.m
//  McDistance
//
//  Created by X Code User on 11/30/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGPlace.h"

@implementation AJGPlace

- (instancetype) initWithLocation:(CLLocation *) location andAddress:(NSString *) address
{
    self = [super init];
    
    if(self) {
        self.location = location;
        self.address = address;
    }
    
    return self;
}

@end
