//
//  UIViewController+Logging.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 8/9/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "UIViewController+Logging.h"
#import <objc/runtime.h>

@implementation UIViewController (Logging)

- (void)logged_viewDidAppear:(BOOL)animated {
    [self logged_viewDidAppear:animated];
    NSLog(@"logged view did appear for %@", [self class]);
}

+ (void)load {
    #ifdef DEBUG
        static dispatch_once_t once_token;
        dispatch_once(&once_token,  ^{
            SEL viewWillAppearSelector = @selector(viewDidAppear:);
            SEL viewWillAppearLoggerSelector = @selector(logged_viewDidAppear:);
            Method originalMethod = class_getInstanceMethod(self, viewWillAppearSelector);
            Method extendedMethod = class_getInstanceMethod(self, viewWillAppearLoggerSelector);
            method_exchangeImplementations(originalMethod, extendedMethod);
        });
    #endif
}

@end
