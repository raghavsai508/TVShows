//
//  TVShowsViewController.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "TVShowsViewController.h"
#import "NetworkManager.h"
#import "TVShowContainer.h"
#import "TVShow.h"
#import "TVShowTableCell.h"
#import "PopOverContentViewController.h"

#define POP_OVER_HEIGHT_PADDING 16
#define POP_OVER_WIDTH_MULTIPLIER 1.5
#define POP_OVER_CONTENT_HEIGHT 150

@interface TVShowsViewController ()<UITextFieldDelegate,UIPopoverPresentationControllerDelegate,NetworkManagerProtocol>

@property (nonatomic, strong) UITextField                       *txtSearch;
@property (nonatomic, strong) NetworkManager                    *networkManager;
@property (nonatomic, strong) NSArray                           *tvShowsArray;
@property (nonatomic, strong) UIActivityIndicatorView           *activityIndicator;
@property (nonatomic, strong) PopOverContentViewController      *popOverContentController;
@property (nonatomic, strong) UIPopoverPresentationController   *popOverPresentationController;

@property (weak, nonatomic) IBOutlet UITableView                *tableView;

@end

@implementation TVShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self showPopOver];
}


#pragma mark - UISetup methods
/* This method is used for setting up the navigation bar. */
- (void)setupNavigationBar
{
    [self setupNavTitleView];
    [self setupTextSearch];
    [self addTextFieldConstraints];
}

/* This method setups the textfield for the navigation bar where
   the textfield is added as subview for navigation bar. */
- (void)setupNavTitleView
{
    self.txtSearch = [[UITextField alloc] initWithFrame:CGRectZero];
    self.txtSearch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navigationController.navigationBar addSubview:self.txtSearch];
}

/* This method setups the UI for textfield in the navigation bar. */
- (void)setupTextSearch
{
    [self setupTextSearchUtility];
    [self setupTextSearchUI];
    self.txtSearch.delegate = self;
    [self setupTextSearchLeftView];
}

/* This method is utility for search text field. */
- (void)setupTextSearchUtility
{
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What do you want to watch?" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.txtSearch.textAlignment = NSTextAlignmentLeft;
    self.txtSearch.keyboardType = UIKeyboardTypeDefault;
}

/* This method setups the basic UI for search text field. */
- (void)setupTextSearchUI
{
    [self.txtSearch setFont:[UIFont systemFontOfSize:14]];
    [self.txtSearch setTextColor:[UIColor whiteColor]];
    self.txtSearch.borderStyle = UITextBorderStyleRoundedRect;
    self.txtSearch.backgroundColor = [UIColor blackColor];
}

/* This method setups the leftview of the textfield. */
- (void)setupTextSearchLeftView
{
    [self.txtSearch setLeftViewMode:UITextFieldViewModeAlways];
    self.txtSearch.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico-search.png"]];
}

/* This method adds the constraints for the search text field. */
- (void)addTextFieldConstraints
{
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.txtSearch
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.navigationController.navigationBar
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:8];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.txtSearch
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.navigationController.navigationBar
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-8];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.txtSearch
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.navigationController.navigationBar
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1
                                                                           constant:-8];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.txtSearch
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.navigationController.navigationBar
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:8];
    NSArray *constraintsArray = [[NSArray alloc] initWithObjects:leadingConstraint,bottomConstraint,trailingConstraint,topConstraint, nil];
    [self.navigationController.navigationBar addConstraints:constraintsArray];
    
    [self.navigationController.view layoutIfNeeded];
    
}

/* This method configures the PopoverView. */
- (void)showPopOver
{
     self.popOverContentController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopOverViewController"];
    self.popOverContentController.modalPresentationStyle = UIModalPresentationPopover;
    [self setupPopOverPresentation];
}

/* This method sets the presentation style for the popover view. */
- (void)setupPopOverPresentation
{
    UINavigationController *navController = [self getNavigationControllerForPopOverPresentationStyle];
    [self setPopOverDelegate];
    [self setPopOverSourceRectFrame:[self getPopOverFrame]];
    [self setPopOverView];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (UINavigationController *)getNavigationControllerForPopOverPresentationStyle
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.popOverContentController];
    navController.navigationBarHidden= YES;
    navController.modalPresentationStyle = UIModalPresentationPopover;
    self.popOverPresentationController = navController.popoverPresentationController;
    return navController;
}

/* This method sets the delegate for the PopoverPresentationController. */
- (void)setPopOverDelegate
{
    self.popOverPresentationController.delegate = self;
}

/* This method gets frame for the popover. */
- (CGRect)getPopOverFrame
{
    return self.txtSearch.frame;
}

/* This method sets the popover source rect frame. */
- (void)setPopOverSourceRectFrame:(CGRect)txtFrame
{
    CGFloat x = txtFrame.origin.x;
    CGFloat y = txtFrame.origin.y;
    CGFloat height = txtFrame.size.height+x+POP_OVER_HEIGHT_PADDING;
    CGFloat width = txtFrame.size.width;
    CGRect rect = CGRectMake(x,y,width/POP_OVER_WIDTH_MULTIPLIER,height);
    self.popOverPresentationController.sourceRect = rect;
}

/* This method sets content size of the popover view and its background color. */
- (void)setPopOverView
{
    self.popOverPresentationController.sourceView = self.navigationController.view;
    self.popOverContentController.preferredContentSize = CGSizeMake([self getPopOverFrame].size.width/POP_OVER_WIDTH_MULTIPLIER, POP_OVER_CONTENT_HEIGHT);
    self.popOverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    self.popOverPresentationController.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:64.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
}

#pragma mark - UIPopoverPresentationControllerDelegate methods
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tvShowsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TVShowTableCell *tvShowTableCell = (TVShowTableCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TVShowTableCell class]) forIndexPath:indexPath];
    [tvShowTableCell configureTVShowCell:self.tvShowsArray[indexPath.row] atIndexPath:indexPath];
    return tvShowTableCell;
}



#pragma mark - UITextFieldDelegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(searchString.length > 0)
    {
        self.networkManager = [NetworkManager defaultNetworkManager];
        self.networkManager.networkDelegate = self;
        [self setTxtSearchActivityIndicator];
        [self.networkManager downloadData:searchString];
    }
    else
    {
        [self clearSearchText];
    }
    
    return YES;
}

#pragma mark - NetworkManagerProtocol methods
- (void)dataHasBeenDownloaded:(id)data
{
    TVShowContainer *tvShowContainer = (TVShowContainer *)data;
    self.tvShowsArray = nil;
    self.tvShowsArray = [tvShowContainer.tvShowContainerArray copy];
    [self.tableView reloadData];
    [self stopActivityIndicator];
}

#pragma mark - Utility methods
/* This method sets the right view of search text field with an activity indicator. */
- (void)setTxtSearchActivityIndicator
{
    [self.txtSearch setRightViewMode:UITextFieldViewModeAlways];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.txtSearch.rightView = self.activityIndicator;
    [self.activityIndicator startAnimating];
}

/* This method stops the activity indicator when the data is fetched from server. */
- (void)stopActivityIndicator
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    [self setupTextSearchRightViewCancel];
}

/* This method sets the cancel button for right view of search text field. */
- (void)setupTextSearchRightViewCancel
{
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.frame = CGRectMake(0, 0, 25, 25);
    UIImage *btnImage = [UIImage imageNamed:@"ico-cancel.png"];
    [buttonCancel setImage:btnImage forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(clearSearchText) forControlEvents:UIControlEventTouchUpInside];
    self.txtSearch.rightView = buttonCancel;
}

/* This method clears the text field and removes the data from tableview. */
- (void)clearSearchText
{
    self.txtSearch.text = @"";
    self.tvShowsArray = nil;
    self.txtSearch.rightView = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
