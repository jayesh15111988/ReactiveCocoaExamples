//
//  PullToRefreshTableViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/7/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "PullToRefreshTableViewController.h"

@interface PullToRefreshTableViewController ()
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) UIView* refreshLoadingView;
@property (strong, nonatomic) UIView* refreshColorView;
@property (strong, nonatomic) UIImageView* imageView;
@end

@implementation PullToRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self setupRefreshControl];
}

-(void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor redColor];
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.3f;
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor greenColor];
    self.refreshControl.alpha = 0.5f;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 20, 40, 40)];
    self.imageView.image = [UIImage imageNamed:@"map.png"];
    self.imageView.alpha = 0.3;
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    [self.refreshControl addSubview:self.imageView];
    
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender{
    
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"DONE");
        
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self.refreshControl endRefreshing];
    });
    // -- FINISHED SOMETHING AWESOME, WOO! --
}

@end
