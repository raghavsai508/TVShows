//
//  NetworkManager.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/21/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "NetworkManager.h"
#import "URLConfiguration.h"
#import "SystemLevelConstants.h"
#import "TVShowsParser.h"

@interface NetworkManager ()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession                  *session;

/* Data is downloaded using Session Download Task property. */
@property (nonatomic, strong) NSURLSessionDownloadTask      *downloadTask;

@end


@implementation NetworkManager

+ (instancetype)defaultNetworkManager
{
    static NetworkManager *networkManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        networkManager = [[self alloc] init];
    });
    return networkManager;
}

/* Getter for session property. The session property is configured
   using NSURLSessionConfiguration and only one connection per host 
   is allowed. */
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}


- (void)downloadData:(NSString *)searchString
{
    [self.downloadTask cancel];
     self.downloadTask = [self.session downloadTaskWithRequest:[self getContentsFor:searchString]];
    [self.downloadTask resume];
}


- (NSURLRequest *)getContentsFor:(NSString *)searchString
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[URLConfiguration getURL:KSearch_url],searchString,@"/0/10?device=iphone&api_key=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    return request;
}

#pragma mark - NSURLSessionDownloadDelegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSError *errorJson=nil;
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&errorJson];
    
    NSLog(@"%@",dataDictionary);
    NSInteger status = [[dataDictionary valueForKeyPath:@"meta.code"] integerValue];
    if(status == 200)
    {
        NSArray *tvShowArray = [dataDictionary valueForKey:@"response"];
        TVShowsParser *tvShowParser = [[TVShowsParser alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([tvShowArray isKindOfClass:[NSArray class]])
                [self.networkDelegate dataHasBeenDownloaded:[tvShowParser parseTVShowData:tvShowArray]];
            else
                [self.networkDelegate dataHasBeenDownloaded:nil];
        });
    }
}

#pragma mark - NSURLSessionDelegate methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"error %@",error);
}


@end
