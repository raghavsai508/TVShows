//
//  NetworkManager.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManagerDelegate.h"

@interface NetworkManager : NSObject

@property (nonatomic, weak) id<NetworkManagerProtocol> networkDelegate;

/* This method returns a singleton network instance. */
+ (instancetype)defaultNetworkManager;

/* This method is called for each and every character typed
   in textfield. */
- (void)downloadData:(NSString *)searchString;

@end
