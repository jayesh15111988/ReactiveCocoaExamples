//
//  JKReactiveRACSignalLifecycleViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/19/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveRACSignalLifecycleViewController.h"

@interface JKReactiveRACSignalLifecycleViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startLifeCycleButton;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@end

@implementation JKReactiveRACSignalLifecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC Signal lifecycle demo";
    [[self.startLifeCycleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RACSignal* complexSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"We completed this block with success"];
            [subscriber sendError:[NSError errorWithDomain:@"ReactiveCocoa" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Failed with an unknown error. Please try again"}]];
            [subscriber sendCompleted];
            return nil;
        }];
        
        [complexSignal subscribeNext:^(NSString* successMessage) {
            self.successLabel.text = [NSString stringWithFormat:@"Block successfully executed with success message %@",successMessage];
        }];
        
        [complexSignal subscribeCompleted:^{
            self.completedLabel.text = @"Block successfully Completed";
        }];
        
        [complexSignal subscribeError:^(NSError *error) {
            self.errorLabel.text = [NSString stringWithFormat:@"Block failed with an error - %@", [error localizedDescription]];
        }];
    }];
}

@end
