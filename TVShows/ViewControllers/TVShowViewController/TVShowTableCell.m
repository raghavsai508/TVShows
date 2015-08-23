//
//  TVShowTableCell.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "TVShowTableCell.h"
#import "ImagesContainer.h"
#import "URLConfiguration.h"
#import "SystemLevelConstants.h"

typedef NS_ENUM(NSUInteger, DeviceAvailability) {
    DeviceUnavailable = 0,
    DeviceAvailable = 1,
};

@interface TVShowTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView    *tvShowImageView;
@property (weak, nonatomic) IBOutlet UILabel        *lblTVShowTitle;
@property (weak, nonatomic) IBOutlet UILabel        *lblTVShowTypeYear;
@property (nonatomic, strong) NSIndexPath           *currentIndexPath;


@end


@implementation TVShowTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureTVShowCell:(TVShow *)tvShow atIndexPath:(NSIndexPath *)indexPath;
{
    self.lblTVShowTitle.text = tvShow.title;
    self.lblTVShowTypeYear.text = [NSString stringWithFormat:@"%@ (%ld)",[self configureTVShowType:tvShow.type],(long)tvShow.year];
    if(tvShow.availabilityOnMobile == DeviceAvailable)
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-play-on-device.png"]];
    else
        self.accessoryView = nil;
    NSString *url = [self getImageUrlFor:tvShow];
    [self setUpCellWithImageURL:url andIndexPath:indexPath withID:tvShow.showID];
}

/* This method returns the type of show. */
- (NSString *)configureTVShowType:(NSString *)type
{
    NSString *tvshowType;
    if([type isEqualToString:@"movie"])
        tvshowType = @"Movie";
    else if ([type isEqualToString:@"show"])
        tvshowType = @"TV Show";

    return tvshowType;
}

/* This method returns the url for each image that needs to be downloaded. */
- (NSString *)getImageUrlFor:(TVShow *)tvShow
{
    NSString *urlString;
    if([tvShow.type isEqualToString:@"movie"])
        urlString = [NSString stringWithFormat:@"%@%ld%@",[URLConfiguration getImageURL:KMovie_Image_url],(long)tvShow.showID,@"/poster-60x90.jpg"];
    else if ([tvShow.type isEqualToString:@"show"])
        urlString = [NSString stringWithFormat:@"%@%ld%@",[URLConfiguration getImageURL:KShow_Image_url],(long)tvShow.showID,@"/poster-60x90.jpg"];
    
    return urlString;
}

/* This method sets the image at each cell. */
- (void)setUpCellWithImageURL:(NSString *)url andIndexPath:(NSIndexPath *)indexpath withID:(NSInteger)showID
{
    self.currentIndexPath = indexpath;
    UIImage* image = [[ImagesContainer sharedContainer] getImageForIndexPath:indexpath withID:showID];
    
    if(image)
        self.tvShowImageView.image = image;
    else
        [self fetchImageFromURL:url atIndexPath:indexpath withID:showID];
    
}

/********************************************************************************
 Here the image is fetched from server if the image is not present in
 the NSCache. It also checks for the image that is downloaded when the
 cell is dequeued with simple check by storing the current indexpath.
 ********************************************************************************/
- (void)fetchImageFromURL:(NSString *)url atIndexPath:(NSIndexPath *)indexpath withID:(NSInteger)showID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ImagesContainer sharedContainer] setImageAtIndexpath:indexpath withImage:image withID:showID];
            if(self.currentIndexPath.row == indexpath.row)
                [self setUpCellWithImageURL:url andIndexPath:indexpath withID:showID];
            
        });
        
    });
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.tvShowImageView.image = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
