//
//  JKReactiveCombineSignalsViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/16/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveCombineSignalsViewController.h"

@interface JKReactiveCombineSignalsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstSignalInputField;
@property (weak, nonatomic) IBOutlet UITextField *secondSignalInputField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *combineSignalsButton;
@end

@implementation JKReactiveCombineSignalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal* combinedSignal;
    RACSignal* combineLatestWithReduce;
    
    if(self.demoTypeSelected == CombineSignals) {
        [self.combineSignalsButton setTitle:@"Combine Signals" forState:UIControlStateNormal];
        combinedSignal = [RACSignal combineLatest:@[[self firstRACSignal], [self secondRACSignal]]];
    } else if (self.demoTypeSelected == CombineSignalsAndReduce) {
        [self.combineSignalsButton setTitle:@"Combine and Reduce" forState:UIControlStateNormal];
        combineLatestWithReduce = [RACSignal combineLatest:@[[self firstRACSignal], [self secondRACSignal]] reduce:^id(NSString* firstStringOutput, NSString* secondStringOutput){
            return [[firstStringOutput stringByAppendingString:@" Appended to "] stringByAppendingString:secondStringOutput];
        }];
    }
    self.title = self.combineSignalsButton.titleLabel.text;
    
    [[self.combineSignalsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* clickedButton) {
        if(self.demoTypeSelected == CombineSignals) {
            [combinedSignal subscribeNext:^(RACTuple* tuple) {
              
                NSString* originalString = [NSString stringWithFormat:@"Combining two signals. Tuple of size %ld received from signals which contain respective values returned by them. Response from first signal '%@' and from second signal is '%@'", [tuple count], [tuple first], [tuple second]];
                self.resultLabel.text = originalString;
            }];
        } else if (self.demoTypeSelected == CombineSignalsAndReduce) {
            [combineLatestWithReduce subscribeNext:^(NSString* concatString) {
                NSString* originalString = [NSString stringWithFormat:@"Received Different strings from two different sources. Reduced output from both string to produce third string with an extra content. Final output is '%@'", concatString];
                NSMutableAttributedString* stringWithAttributesAdded = [[NSMutableAttributedString alloc] initWithString:originalString];
                NSRange rangeToAddAttributeTo = NSMakeRange(originalString.length - concatString.length - 2, concatString.length + 2);
                [stringWithAttributesAdded addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangeToAddAttributeTo];
                [stringWithAttributesAdded addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:rangeToAddAttributeTo];
                self.resultLabel.attributedText = stringWithAttributesAdded;
            }];
            
        }
    }];
}

-(RACSignal*)firstRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:self.firstSignalInputField.text];
        [subscriber sendCompleted];
        return nil;
    }];
}

-(RACSignal*)secondRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:self.secondSignalInputField.text];
        return nil;
    }];
}

@end
