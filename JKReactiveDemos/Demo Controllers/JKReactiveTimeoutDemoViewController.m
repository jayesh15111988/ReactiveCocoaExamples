//
//  JKReactiveTimeoutDemoViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/20/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveTimeoutDemoViewController.h"

@interface JKReactiveTimeoutDemoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *timeoutInterval;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UITextField *delayIntervalSimulate;
@property (weak, nonatomic) IBOutlet UILabel *requestOutput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation JKReactiveTimeoutDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Network Timeout Demo";
    
    [[self.sendRequestButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sendRequestButton) {
        
        [sendRequestButton setUserInteractionEnabled:NO];
        [sendRequestButton setAlpha:0.4];
        [self.activityIndicator startAnimating];
        self.requestOutput.text = @"Output";
        
        RACSignal* networkOperationSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            RACDisposable* disposableObject = [RACDisposable new];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSInteger totalNumberOfObjects = [self.delayIntervalSimulate.text integerValue];
                
                //This loop will automatically stop if any error such as timeout occurred while processing signal and subsequent block
                
                for(NSInteger i = 0; (i < 10) && !disposableObject.isDisposed; i++) {
                    self.requestOutput.text = [NSString stringWithFormat:@"Executing Sequence number %ld", i];
                    [subscriber sendNext:@(i + 1)];
                    NSLog(@"Delay %f", [self.delayIntervalSimulate.text floatValue]);
                    [NSThread sleepForTimeInterval:[self.delayIntervalSimulate.text floatValue]];
                }
                
                //It will be disposed once timeout is detected. In that case completed block won't be executed
                //Either error or completed block will be executed, but not both of them. This condition is to make sure we do not actually execute completed block even after timeout error has occurred
                if(!disposableObject.isDisposed) {
                    [subscriber sendCompleted];
                }
            });
            return disposableObject;
        }];
        
        [[[networkOperationSignal deliverOn:[RACScheduler mainThreadScheduler]] timeout:[self.timeoutInterval.text floatValue] onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* x) {
            self.requestOutput.text = [NSString stringWithFormat:@"Getting value %ld", [x integerValue]];
        } error:^(NSError *error) {
            
            [sendRequestButton setUserInteractionEnabled:YES];
            [sendRequestButton setAlpha:1.0];
            [self.activityIndicator stopAnimating];
            self.requestOutput.text = [NSString stringWithFormat:@"Failed With %@ Error",([error code] == RACSignalErrorTimedOut)? @"a Timeout" : @"an Unknown"];
            
        } completed:^{
            
            [sendRequestButton setUserInteractionEnabled:YES];
            [sendRequestButton setAlpha:1.0];
            [self.activityIndicator stopAnimating];
            self.requestOutput.text = @"Operation Successfully completed before Timeout";
            
        }];
    }];
}


@end
