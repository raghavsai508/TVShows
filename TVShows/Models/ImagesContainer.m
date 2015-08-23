//
//  ImagesContainer.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "ImagesContainer.h"

@interface ImagesContainer()

@property (nonatomic, strong) NSCache *imagesCache;

@end

@implementation ImagesContainer

+ (instancetype)sharedContainer
{
    static dispatch_once_t once_token;
    static ImagesContainer *imageInstance;
    dispatch_once(&once_token,^{
        imageInstance = [[ImagesContainer alloc]init];
        imageInstance.imagesCache = [[NSCache alloc] init];
    });
    return imageInstance;
}

- (UIImage *)getImageForIndexPath:(NSIndexPath *)indexPath withID:(NSInteger)showID
{
    UIImage *returnImage;
    NSString *key = [NSString stringWithFormat:@"Section-%ld-row-%ld-id-%ld",(long)indexPath.section,(long)indexPath.row,(long)showID];
    returnImage = [self.imagesCache objectForKey:key];
    return returnImage;
}

- (void)setImageAtIndexpath:(NSIndexPath *)indexPath withImage:(UIImage *)image withID:(NSInteger)showID
{
    NSString *key = [NSString stringWithFormat:@"Section-%ld-row-%ld-id-%ld",(long)indexPath.section,(long)indexPath.row,(long)showID];
    if(image)
        [self.imagesCache setObject:image forKey:key];
    else
        [self.imagesCache setObject:[UIImage imageNamed:@"no_image.jpg"] forKey:key];
}

@end
