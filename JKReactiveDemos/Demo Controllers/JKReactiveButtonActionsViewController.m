//
//  JKReactiveButtonActionsViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/16/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveButtonActionsViewController.h"

@interface JKReactiveButtonActionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *defaultTopButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation JKReactiveButtonActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    if(self.optionSelected == ButtonPress) {
        self.title = @"Button Click RACCommand";
        RACCommand* command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:@"Congrats, You just pressed a button whose action was connected through RACCommand API"];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
        
        [command.executionSignals subscribeNext:^(RACSignal* signalWithName) {
            
            [signalWithName subscribeNext:^(NSString* valueReturned) {
                self.resultLabel.text = valueReturned;
            }];
            
            [signalWithName subscribeCompleted:^{
                self.resultLabel.text = [NSString stringWithFormat:@"%@. Button Click operation successfully completed", self.resultLabel.text];
            }];
        }];

        self.defaultTopButton.rac_command = command;
    } else if (self.optionSelected == ButtonPressProgress) {
        self.title = @"Button Click Show Progress";
        
        self.defaultTopButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://7-themes.com/data_images/out/38/6898469-beautiful-sunny-leone-wallpaper.jpg"]];                   [subscriber sendNext:[UIImage imageWithData:data]];
                    [subscriber sendCompleted];
                return nil;
            }];
        }];
        
        @weakify(self);
        
        [self.defaultTopButton.rac_command.executing subscribeNext:^(id executing) {
            @strongify(self);
            
            if([executing boolValue]) {
                [self.activityIndicator startAnimating];
                self.resultLabel.text = @"Executing Signal. Please wait...";
                self.defaultTopButton.enabled = NO;
                self.defaultTopButton.alpha = 0.4;
                self.defaultTopButton.userInteractionEnabled = self.defaultTopButton.enabled;
            }
            else {
                [self.activityIndicator stopAnimating];
                self.resultLabel.text = @"Execution Signal Finished";
                self.defaultTopButton.enabled = YES;
                self.defaultTopButton.alpha = 1.0;
                self.defaultTopButton.userInteractionEnabled = self.defaultTopButton.enabled;
            }
        }];
        [self.defaultTopButton.rac_command.executionSignals subscribeNext:^(RACSignal* buttonPressOperationSignal) {
            [buttonPressOperationSignal subscribeNext:^(id x) {
                NSLog(@"Operation Completed");
            }];
        }];

    }
}

@end
