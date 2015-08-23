//
//  URLConfiguration.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "URLConfiguration.h"

#define base_url @"http://api.yidio.com/"
#define base_image_url @"http://cf.yidio.com/images/"


@implementation URLConfiguration

+ (NSString *)getURL:(NSString *)appendURL
{
    NSString *url = [NSString stringWithFormat:@"%@%@",base_url,appendURL];
    return url;
}

+ (NSString *)getImageURL:(NSString *)appendURL
{
    NSString *url = [NSString stringWithFormat:@"%@%@",base_image_url,appendURL];
    return url;
}

@end
