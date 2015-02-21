//
//  JKReactiveButtonActionsViewController.h
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/16/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonActionDemoType) {
    ButtonPress = 7,
    ButtonPressProgress = 8
};

@interface JKReactiveButtonActionsViewController : UIViewController
@property (nonatomic, assign) NSInteger optionSelected;
@end
