//
//  AJGPlace.h
//  McDistance
//
//  Created by X Code User on 11/30/14.
//  Copyright (c) 2014 com.andrewjgreenman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJGPlace : NSObject

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, strong) NSString *address;

- (instancetype) initWithLatitude:(float) latitiude withLongitude:(float) longitude withAddress: (NSString *) address;

@end
