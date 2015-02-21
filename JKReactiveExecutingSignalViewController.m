//
//  JKReactiveExecutingSignalViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/21/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveExecutingSignalViewController.h"

@interface JKReactiveExecutingSignalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *operationDelayTextField;
@property (weak, nonatomic) IBOutlet UIButton *beginHeavyOperationButton;

@end

@implementation JKReactiveExecutingSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RACCommand execution
    self.beginHeavyOperationButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        CGFloat delayInSeconds = [self.operationDelayTextField.text doubleValue];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
        });
        return [RACSignal empty];
    }];
    
    /*[executingCommand.executing subscribeNext:^(id x) {
        [self.activityIndicator startAnimating];
        [self.beginHeavyOperationButton setEnabled:NO];
        self.statusLabel.text = @"Beginning an Operation";
        
        NSLog(@"Executing %@",x);
    }];
    
    [executingCommand.executing subscribeCompleted:^{
        [self.activityIndicator stopAnimating];
        [self.beginHeavyOperationButton setEnabled:YES];
        self.statusLabel.text = @"Operation Completed";
        
        NSLog(@"Execution completed sucessfully");
    }];*/
    [self.beginHeavyOperationButton.rac_command.executing subscribeNext:^(id x) {
        NSLog(@"IS executing %d",[x boolValue]);
    }];
    
    [self.beginHeavyOperationButton.rac_command.executionSignals subscribeNext:^(RACSignal* signal) {
        
    }];
}
@end
