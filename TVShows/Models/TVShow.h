//
//  TVShow.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVShow : NSObject

/* Title for the show or movie. */
@property (nonatomic, strong) NSString      *title;

/* Type like show or movie or episode. */
@property (nonatomic, strong) NSString      *type;

/* Year of show released or started. */
@property (nonatomic) NSInteger             year;

/* This property the availability on device .*/
@property (nonatomic) NSInteger             availabilityOnMobile;

/* This property stores the ID. */
@property (nonatomic) NSInteger             showID;

@end
