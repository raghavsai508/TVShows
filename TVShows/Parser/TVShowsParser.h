//
//  TVShowsParser.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVShowsParser : NSObject

/* This method is responsible for the data received from the server.
   It stores all the shows in a container. */
-(id)parseTVShowData:(NSArray *)dataArray;

@end
