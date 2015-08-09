//
//  JKReactiveRacSequenceViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/18/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveRacSequenceViewController.h"

@interface JKReactiveRacSequenceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputFilterLength;
@property (weak, nonatomic) IBOutlet UITextField *textToAppend;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UILabel *operationOutput;
@property (nonatomic, strong) NSArray* inputArray;
@end

@implementation JKReactiveRacSequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RAC Sequence Demo";
    
    self.inputArray = @[@"apple", @"microsoft", @"sony", @"samsung", @"mcg", @"bk", @"google", @"walmart"];
    __block NSArray* filteredArray;
    
    [[self.applyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if([self.inputFilterLength.text length] == 0) {
            self.inputFilterLength.text = @"0";
        }
        
        filteredArray = [[[self.inputArray.rac_sequence filter:^BOOL(NSString* value) {
            return (value.length > [self.inputFilterLength.text integerValue]);
        }] map:^id(NSString* value) {
            return [value stringByAppendingString:self.textToAppend.text];
        }] array];
        self.operationOutput.text = [NSString stringWithFormat:@"Filtered Input array is : %@", [filteredArray componentsJoinedByString:@", "]];
    }];
}

@end
