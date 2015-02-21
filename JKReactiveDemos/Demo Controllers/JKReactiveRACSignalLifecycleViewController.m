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
@property (weak, nonatomic) IBOutlet UISwitch *operationSelectionSwitch;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;
@property (assign, nonatomic) BOOL toIncludeCompletionBlock;

@end

@implementation JKReactiveRACSignalLifecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC Signal lifecycle demo";
    self.toIncludeCompletionBlock = YES;
    [[self.startLifeCycleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        self.successLabel.text = @"Success Block Output";
        self.errorLabel.text = @"Error Block Output";
        self.completedLabel.text = @"Completion Block Output";
        
        RACSignal* complexSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if(self.toIncludeCompletionBlock) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendNext:@"We completed this block with success"];
                [subscriber sendError:[NSError errorWithDomain:@"ReactiveCocoa" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Failed with an unknown error. Please try again"}]];
            }
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
    
    [[self.operationSelectionSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch* x) {
        self.toIncludeCompletionBlock = x.isOn;
    }];
}

@end
