//
//  FoursquareWebLoginDelegate.h
//  FSTest2
//
//  Created by Christopher Moghbel on 3/31/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foursquare2.h"

@protocol FoursquareWebLoginDelegate <NSObject>

- (void)setAccessToken:(NSString*)accessToken;

@end
