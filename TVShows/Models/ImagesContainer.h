//
//  ImagesContainer.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagesContainer : NSObject

/* This method returns a singleton ImageContainer object
 * for storing the images. */
+(instancetype)sharedContainer;

/* This method returns an image from NSCache if exists. */
-(UIImage *)getImageForIndexPath:(NSIndexPath *)indexPath withID:(NSInteger)showID;

/* This method stores an image in NSCache. */
- (void)setImageAtIndexpath:(NSIndexPath *)indexPath withImage:(UIImage *)image withID:(NSInteger)showID;

@end
