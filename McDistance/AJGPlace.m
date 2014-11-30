//
//  AJGPlace.m
//  McDistance
//
//  Created by X Code User on 11/30/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import "AJGPlace.h"

@implementation AJGPlace

- (instancetype) initWithLatitude:(float) latitiude withLongitude:(float) longitude withAddress: (NSString *) address
{
    self = [super init];
    
    if(self) {
        self.latitude = latitiude;
        self.longitude = longitude;
        self.address = address;
    }
    
    return self;
}

@end
