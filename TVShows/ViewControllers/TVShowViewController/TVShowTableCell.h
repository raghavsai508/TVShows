//
//  TVShowTableCell.h
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShow.h"

@interface TVShowTableCell : UITableViewCell

/* This method is responsible for configuring the cell at each index path. */
- (void)configureTVShowCell:(TVShow *)tvShow atIndexPath:(NSIndexPath *)indexPath;

@end
