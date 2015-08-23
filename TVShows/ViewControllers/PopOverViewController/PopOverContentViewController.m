//
//  PopOverViewController.m
//  TVShows
//
//  Created by Raghav Sai Cheedalla on 8/22/15.
//  Copyright (c) 2015 Raghav Sai Cheedalla. All rights reserved.
//

#import "PopOverContentViewController.h"

@interface PopOverContentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnDismissPopOver;


@end

@implementation PopOverContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)dismissController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
