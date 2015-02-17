//
//  JKReactiveCombineSignalsViewController.h
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/16/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CombineSignalsDemoType) {
    CombineSignals = 5,
    CombineSignalsAndReduce = 6
};

@interface JKReactiveCombineSignalsViewController : UIViewController
@property (assign, nonatomic) NSInteger demoTypeSelected;
@end
