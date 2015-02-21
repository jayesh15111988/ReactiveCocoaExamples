//
//  JKReactiveTextFieldsDemoViewController.h
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextFieldDemoType) {
    InputTextToBool,
    InputTextToAnotherValue,
    InputTextAssignValue,
};

@interface JKReactiveTextFieldsDemoViewController : UIViewController
@property (assign, nonatomic) TextFieldDemoType textFieldDemoTypeSelected;
@property (strong, nonatomic) NSString* selectedDemoName;
@end
