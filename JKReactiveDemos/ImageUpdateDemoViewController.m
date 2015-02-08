//
//  ImageUpdateDemoViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/2/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ImageUpdateDemoViewController.h"

@interface ImageUpdateDemoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageLoadButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) UIImage* firstImage;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *chainLoadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *beginHeavyOperationButton;
@property (strong, nonatomic) UIImage* secondImage;
@end

@implementation ImageUpdateDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //You can always call subscribe** methods on Reactive Cocoa for right hand side, as it returns the RACSignal back
    RAC(self, firstImageView.image) = RACObserve(self, firstImage);
    RAC(self, secondImageView.image) = RACObserve(self, secondImage);
    
    self.imageLoadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"Image Load Button Pressed");
        self.firstImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.bellartefutsal.com/site/images/video/roger-federer-img10267_668.jpg"]]];
        return [RACSignal empty];
    }];
    
    [[self.secondButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    self.secondImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://blogs.thenews.com.pk/blogs/wp-content/uploads/2013/11/roger.jpg"]]];
        NSLog(@"This button is pressed");
    }];
    
    self.chainLoadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self getRACSignalForImageWithURL:@"http://www.bellartefutsal.com/site/images/video/roger-federer-img10267_668.jpg"] deliverOn:[RACScheduler scheduler]];
    }];
    
    [self.chainLoadButton.rac_command.executing subscribeNext:^(id x) {
        NSLog(@"Code Is curretly being executed");
    
    }];
    
    [self.chainLoadButton.rac_command.executionSignals subscribeNext:^(RACSignal* firstImageLoadSignal) {
       
        [[[firstImageLoadSignal map:^id(NSURL* value) {
            return [UIImage imageWithData:[NSData dataWithContentsOfURL:value]];
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage* x) {
            self.firstImageView.image = x;
        }];
        
        [firstImageLoadSignal subscribeCompleted:^{
            NSLog(@"First Image loaded successfully");
        }];
        
        RACSignal* secondSignal = [[self getRACSignalForImageWithURL:@"http://blogs.thenews.com.pk/blogs/wp-content/uploads/2013/11/roger.jpg"] deliverOn:[RACScheduler scheduler]];
        
        [[[secondSignal map:^id(NSURL* value) {
            return [UIImage imageWithData:[NSData dataWithContentsOfURL:value]];
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage* secondImage) {
            self.secondImageView.image = secondImage;
        }];
        

        
        [secondSignal subscribeCompleted:^{
            NSLog(@"Second Image loaded successfully");
        }];
    }];
    
    
    //RACCommand execution
    RACCommand* executingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"This is cold signal and kept on hold until user clicks the button");
        double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    return [RACSignal empty];
    }];
    
    [executingCommand.executing subscribeNext:^(id x) {
        [self.activityIndicator startAnimating];
        NSLog(@"Executing");
    }];
    
    [executingCommand.executing subscribeCompleted:^{
        [self.activityIndicator stopAnimating];
        NSLog(@"Execution completed sucessfully");
    }];
    
    //Execute this command with execute method
    [[self.beginHeavyOperationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [executingCommand execute:nil];
    }];
    
}

-(RACSignal*)getRACSignalForImageWithURL:(NSString*)stringURL {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:[NSURL URLWithString:stringURL]];
        [subscriber sendCompleted];
        return nil;
    }] deliverOn:[RACScheduler scheduler]];
}


@end
