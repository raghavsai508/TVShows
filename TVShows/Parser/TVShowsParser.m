//
//  TVShowsParser.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "TVShowsParser.h"
#import "TVShowContainer.h"
#import "TVShow.h"

@implementation TVShowsParser

- (id)parseTVShowData:(NSArray *)dataArray
{
    TVShowContainer *tvShowContainer = [[TVShowContainer alloc] init];
    tvShowContainer.tvShowContainerArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *data in dataArray)
    {
        TVShow *tvShow = [[TVShow alloc] init];
        tvShow.title = [data valueForKey:@"name"];
        tvShow.type = [data valueForKey:@"type"];
        tvShow.year = [[data valueForKey:@"year"] integerValue];
        tvShow.availabilityOnMobile = [[data valueForKey:@"available_on_device"] integerValue];
        tvShow.showID = [[data valueForKey:@"id"] integerValue];
        [tvShowContainer.tvShowContainerArray addObject:tvShow];
    }
    return tvShowContainer;
}

@end
