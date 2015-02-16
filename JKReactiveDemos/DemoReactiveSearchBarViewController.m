//
//  DemoReactiveSearchBarViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/7/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "DemoReactiveSearchBarViewController.h"
#import "UISearchBar+RAC.h"

@interface DemoReactiveSearchBarViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString* searchString;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSInteger currentSeconds;
@property (strong, nonatomic) NSNumber* secondsNumber;

@end

@implementation DemoReactiveSearchBarViewController

-(instancetype)init {

    if(self = [super init]) {
        //Different way to observe value of string based on the input of search string in searchbar
        RAC(self, searchString) =  [[self.searchBar rac_textSignal] map:^id(NSString* value) {
            return value;
        }];
        
        self.searchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSLog(@"Value of search string is %@",self.searchString);
            return [RACSignal empty];
        }];
        
        [self.searchBar.rac_textSignal subscribeNext:^(NSString* searchText) {
            NSLog(@"Text to search is %@",self.searchString);
        }];
        //Demo on working of cancelling previous rac signal when in search bar when user is typing very fast and we want to cancel
        //Previous request which is no longer necessary to apply due to reception of recent signal
        


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentSeconds = 0;
    [self setupTimer];
    //Twenty Seventh demo
    [self setupLatestSignalWithSearchbar];
}

-(void)setupLatestSignalWithSearchbar {
    [[[RACObserve(self, secondsNumber) map:^id(NSNumber* secs) {
        [NSThread sleepForTimeInterval:1.0];
        NSInteger originalNumberOfSeconds = [secs integerValue];
        NSNumber* updatedNumber = @(originalNumberOfSeconds*10);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:updatedNumber];
            return  nil;
        }];
    }] switchToLatest] subscribeNext:^(NSNumber* secondsSecondBlock) {
        NSLog(@"Current seconds *10 are %ld",(long)[secondsSecondBlock integerValue]);
    }];
}

-(void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)resetTimer {
    [self.timer invalidate];
}

-(void)timerCallback {
    self.currentSeconds++;
    self.secondsNumber = @(self.currentSeconds);
    NSLog(@"Current seconds %ld",(long)self.currentSeconds);
}
@end
