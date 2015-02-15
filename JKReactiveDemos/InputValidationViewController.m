//
//  InputValidationViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/1/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "InputValidationViewController.h"

@interface InputValidationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *salary;
@property (weak, nonatomic) IBOutlet UITextField *platform;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIToolbar *inputToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end


@implementation InputValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Twenty first Demo
    [self setupSignals];
}

-(UIView*)inputAccessoryView {
    return self.inputToolbar;
}


-(void)setupSignals {
    
    RACSignal *validNameSignal =
    [self.name.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 2);
     }];
    
    RACSignal *validAgeSignal =
    [self.age.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 2);
     }];
    
    RACSignal *validSalarySignal =
    [self.salary.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 0);
     }];
    
    RACSignal *validPlatformSignal =
    [self.platform.rac_textSignal
     map:^id(NSString *text) {
         return @(text.length > 2);
     }];
    
    RACSignal *activeSignal =
    [RACSignal combineLatest:@[validNameSignal, validAgeSignal, validSalarySignal, validPlatformSignal]
                      reduce:^id(NSNumber *name, NSNumber *age, NSNumber* salary, NSNumber* platform) {
                          return @([name boolValue] && [age boolValue] && [salary boolValue] && [platform boolValue]);
                      }];
    
    [activeSignal subscribeNext:^(NSNumber *signalActive) {
        self.submitButton.enabled = [signalActive boolValue];
        self.submitButton.alpha = [signalActive boolValue] ? 1 : 0.3;
    }];
    
    self.submitButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        NSLog(@"Submit Button Pressed");
        return [RACSignal empty];
    }];
    
    self.doneButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Done Button Pressed");
        [self.view endEditing:YES];
        return [RACSignal empty];
    }];
    
}
@end
