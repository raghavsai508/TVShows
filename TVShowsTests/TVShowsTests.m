//
//  TVShowsTests.m
//  TVShowsTests
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TVShowsViewController_TVShowTableViewPrivate.h"
#import "TVShowTableCell.h"
#import "NetworkManager.h"
#import "NetworkManagerDelegate.h"


@interface TVShowsTests : XCTestCase<NetworkManagerProtocol>

@property (nonatomic, strong) TVShowsViewController         *tvShowViewController;
@property BOOL                                              callBackInvoked;


@end

@implementation TVShowsTests

- (void)setUp {
    [super setUp];
    [self initialSetup];
}

/* This is the initial setup for test cases. */
- (void)initialSetup
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tvShowViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TVShowsViewController class])];
    [self.tvShowViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
}

- (void)tearDown
{
    self.tvShowViewController = nil;
    [super tearDown];
}

#pragma mark - View Loading Tests
/* This method tests whether TvShowViewController view is instantiated or not. */
-(void)testThatViewLoads
{
    XCTAssertNotNil(self.tvShowViewController.view, @"View not initiated properly");
}

/* This method tests whether TvShowViewController view has a tableview or not. */
- (void)testTvShowViewControllerHasTableViewSubview
{
    NSArray *subviews = self.tvShowViewController.view.subviews;
    XCTAssertTrue([subviews containsObject:self.tvShowViewController.tableView], @"View does not have a table subview");
}

/* This method tests whether TvShowViewController tableview is instantiated or not. */
-(void)testTableViewLoads
{
    XCTAssertNotNil(self.tvShowViewController.tableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
/* This method tests whether TvShowViewController tableview conforms to tableview data source
 or not. */
-(void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.tvShowViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

/* This method tests whether TvShowViewController tableview is connected  to
 a data source or not. */
- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.tvShowViewController.tableView.dataSource, @"Table datasource cannot be nil");
}

/* This method tests whether TvShowViewController tableview is connected to delegate or not. */
- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.tvShowViewController.tableView.delegate, @"Table delegate cannot be nil");
}


#pragma mark - NetworkManager helper methods
- (NetworkManager *)createUniqueInstance
{
    return [[NetworkManager alloc]init];
}

- (NetworkManager *)getSharedInstance
{
    return [NetworkManager defaultNetworkManager];
}

#pragma mark - NetworkManager Singleton check
/* This method tests whether the NetworkManager shared Object is returned or not. */
- (void)testNetworkManagerSingleton
{
    XCTAssertNotNil([self getSharedInstance]);
}

/* This method tests whether a new instance NetworkManager Object is created or not. */
- (void)testNetworkManagerUniqueInstance
{
    XCTAssertNotNil([self createUniqueInstance]);
}
/* This method tests whether the NetworkManager is a shared Object or not. */
- (void)testNetworkManagerReturnsSameSharedInstanceTwice
{
    NetworkManager *networkManager = [self getSharedInstance];
    XCTAssertEqual(networkManager, [self getSharedInstance]);
}

/* This method tests whether the NetworkManager new instances are same or not.. */
- (void)testNetworkManagerSharedInstanceSeparateFromUniqueInstance
{
    NetworkManager *networkManager = [self getSharedInstance];
    XCTAssertNotEqual(networkManager, [self createUniqueInstance]);
}

/* This method tests whether the shared instance and new instance are same or not. */
- (void)testNetworkManagerReturnsSeparateUniqueInstances
{
    NetworkManager *networkManager = [self createUniqueInstance];
    XCTAssertNotEqual(networkManager, [self createUniqueInstance]);
}

#pragma mark - NetworkManager Call checks
/*This method tests the data is being fetched from server or not. */
- (void)testServiceCallData
{
    NSDate *fiveSecondsFromNow = [NSDate dateWithTimeIntervalSinceNow:5.0];
    
    NetworkManager *manager = [self getSharedInstance];
    manager.networkDelegate = self;
    
    [manager downloadData:@"hallow"];
    [[NSRunLoop currentRunLoop] runUntilDate:fiveSecondsFromNow];
    
    XCTAssertTrue(self.callBackInvoked,@"response was not ok. error occured 404");
    
}

#pragma mark - NetworkManagerProtocol methods
- (void)dataHasBeenDownloaded:(id)data
{
    self.callBackInvoked = YES;
}

@end
