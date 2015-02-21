//
//  JKReactiveSearchThrottleViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveSearchThrottleViewController.h"
#import "UISearchBar+RAC.h"
#define THROTTLE_TIMEOUT 1.0

@interface JKReactiveSearchThrottleViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarController;
@property (weak, nonatomic) IBOutlet UILabel *outputMessage;
@end

@implementation JKReactiveSearchThrottleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search with Throttle";
    self.outputMessage.text = @"Please enter value in the search bar. It will be throttled and output after delay of 1 second";
    RACSignal* signalForSearchField = [[self.searchBarController rac_textSignal] throttle:THROTTLE_TIMEOUT];
    
    [signalForSearchField subscribeNext:^(NSString* searchString) {
        self.outputMessage.text = [NSString stringWithFormat:@"Value entered in the search bar is %@. Output after delay of 1 second", searchString];
    }];
}

@end
