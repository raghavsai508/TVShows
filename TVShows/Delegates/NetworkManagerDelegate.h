//
//  NetworkManagerDelegate.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkManagerProtocol <NSObject>

/* This delegate method is fired when the data is downloaded from 
    server. */
- (void)dataHasBeenDownloaded:(id)data;

@end

@interface NetworkManagerDelegate : NSObject


@end
