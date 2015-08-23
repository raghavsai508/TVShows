//
//  URLConfiguration.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConfiguration : NSObject

/* This method returns an url for fetching data from server. */
+ (NSString *)getURL:(NSString *)appendURL;

/* This method returns an image base url for fetching image from server. */
+ (NSString *)getImageURL:(NSString *)appendURL;

@end
