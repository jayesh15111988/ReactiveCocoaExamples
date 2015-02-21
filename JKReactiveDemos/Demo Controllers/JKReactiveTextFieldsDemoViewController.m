//
//  JKReactiveTextFieldsDemoViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveTextFieldsDemoViewController.h"


@interface JKReactiveTextFieldsDemoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentDemoName;
@property (weak, nonatomic) IBOutlet UILabel *extraInstructionsLabel;
@property (strong, nonatomic) NSString* inputTextValue;
@end

@implementation JKReactiveTextFieldsDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UITextField + RectiveCocoa";
    self.currentDemoName.text = self.selectedDemoName;
    [RACObserve(self, inputTextValue) subscribeNext:^(NSString *newName) {
        NSString* valueToShow = @"";
        if(self.textFieldDemoTypeSelected == InputTextToBool) {
            valueToShow = [NSString stringWithFormat:@"%@", (newName.length > 5)? @"TRUE : 1" : @"FALSE : 0"];
        } else if (self.textFieldDemoTypeSelected == InputTextToAnotherValue) {
            valueToShow = [newName stringByAppendingString:@" Rocks...."];
        } else if (self.textFieldDemoTypeSelected == InputTextAssignValue) {
            valueToShow = newName;
        }
        self.extraInstructionsLabel.text = valueToShow;
    }];
    
    [self.inputTextField.rac_textSignal subscribeNext:^(NSString* x) {
        if(self.textFieldDemoTypeSelected == InputTextAssignValue) {
            x = [NSString stringWithFormat:@"Dynamic assignment to internal variable is %@", x];
        }
        self.inputTextValue = x;
    }];
    
    NSString* instructionScreen = @"";
    
    if(self.textFieldDemoTypeSelected == InputTextToBool) {
        self.inputTextField.placeholder = @"Input value should be at least 6";
        instructionScreen = @"Please input the value in text field. We will update it. As soon as it's length is at least 6. We will output true value";
    } else if (self.textFieldDemoTypeSelected == InputTextToAnotherValue) {
        instructionScreen = @"Please input the value in text field. We will append an awesome word to the input value";
    } else if (self.textFieldDemoTypeSelected == InputTextAssignValue) {
        instructionScreen = @"Please input the value in text field. We will update it. We will assign value to another variable and update on the screen";
    } else {
        NSLog(@"How the hell did we come here?");
    }
    self.extraInstructionsLabel.text = instructionScreen;
}

@end
