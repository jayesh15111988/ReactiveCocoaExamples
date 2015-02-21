//
//  JKReactivePauseSignalViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/20/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactivePauseSignalViewController.h"

@interface JKReactivePauseSignalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputSignalValue;
@property (weak, nonatomic) IBOutlet UITextField *signalFireThreshold;
@property (weak, nonatomic) IBOutlet UITextField *signalFireDelay;
@property (weak, nonatomic) IBOutlet UIButton *fireSignalButton;
@property (weak, nonatomic) IBOutlet UILabel *signalOutput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation JKReactivePauseSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pause Signal Demo";
    
    [[self.fireSignalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* fireSignalControl) {
        self.signalOutput.text = @"Processing Request...Please wait!";
        [self.activityIndicator startAnimating];
        fireSignalControl.userInteractionEnabled = NO;
        fireSignalControl.alpha = 0.3;
        
        NSString* signalInputValue = self.inputSignalValue.text;
        CGFloat signalDelay = [self.signalFireDelay.text floatValue];
        
        RACSignal* pauseSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:signalInputValue];
            return nil;
        }];
        
        //Add Delay before sending RACSignal back
        RACSignal* conditionalPauseSignal = [pauseSignal flattenMap:^id(NSString* returnedValue) {
            RACSignal *pauseSignal = [RACSignal return:@(returnedValue.length > [self.signalFireThreshold.text integerValue])];
            if (pause) {
                return [pauseSignal delay:signalDelay];
            } else {
                return pauseSignal;
            }
        }];
        
        [conditionalPauseSignal subscribeNext:^(id x) {
            [self.activityIndicator stopAnimating];
            fireSignalControl.userInteractionEnabled = YES;
            fireSignalControl.alpha = 1.0;
            self.signalOutput.text = [NSString stringWithFormat:@"Signal satisfying condition? %@ \n Returned after delay of %.2f Second(s)",[x boolValue]? @"Yes" : @"No", signalDelay];
        }];
    }];
}



@end
