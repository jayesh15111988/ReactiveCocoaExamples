//
//  ImageUpdateDemoViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/2/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//


#define STEP_LOAD_FIRST_IMAGE_URL @"http://static.sportskeeda.com/wp-content/uploads/2014/03/roger-federer2-2142450.jpg"
#define STEP_LOAD_SECOND_IMAGE_URL @"http://i.telegraph.co.uk/multimedia/archive/02796/Rafael_Nadal_2796036b.jpg"
#define CHAIN_LOAD_FIRST_IMAGE_URL @"http://www.befoto.com/data/photos/60_1maria_sharapova.jpg"
#define CHAIN_LOAD_SECOND_IMAGE_URL @"http://a2.files.biography.com/image/upload/c_fill,dpr_1.0,g_face,h_300,q_80,w_300/MTE4MDAzNDEwNzU3MDYwMTEw.jpg"

#import "ImageUpdateDemoViewController.h"

@interface ImageUpdateDemoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *imageLoadButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (strong, nonatomic) UIImage* firstImage;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *chainLoadButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorFirstImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorSecondImage;
@property (weak, nonatomic) IBOutlet UIButton *beginHeavyOperationButton;
@property (strong, nonatomic) UIImage* secondImage;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;

@end

@implementation ImageUpdateDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dynamic Data Download";
    
    //You can always call subscribe** methods on Reactive Cocoa for right hand side, as it returns the RACSignal back
    RAC(self, firstImageView.image) = RACObserve(self, firstImage);
    RAC(self, secondImageView.image) = RACObserve(self, secondImage);
    
    self.imageLoadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* stepLoadFirstButton) {
        NSLog(@"Image Load Button Pressed");
        [self.activityIndicatorFirstImage startAnimating];
        [[self getRACSignalForImageWithURL:STEP_LOAD_FIRST_IMAGE_URL] subscribeNext:^(UIImage* image) {
            [self.activityIndicatorFirstImage stopAnimating];
            self.firstImage = image;
        }];
        
        return [RACSignal empty];
    }];
    
    [[self.secondButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* secondImageLoadButton) {
        [self.activityIndicatorSecondImage startAnimating];
        [[self getRACSignalForImageWithURL:STEP_LOAD_SECOND_IMAGE_URL] subscribeNext:^(UIImage* image) {
            [self.activityIndicatorSecondImage stopAnimating];
            self.secondImage = image;
        }];
    }];
    
    self.chainLoadButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.activityIndicatorFirstImage startAnimating];
        return [self getRACSignalForImageWithURL:CHAIN_LOAD_FIRST_IMAGE_URL];
    }];
    
    [self.chainLoadButton.rac_command.executing subscribeNext:^(id x) {
        NSLog(@"Code Is curretly being executed");
    }];
    
    [self.chainLoadButton.rac_command.executionSignals subscribeNext:^(RACSignal* firstImageLoadSignal) {
       
        [firstImageLoadSignal subscribeNext:^(UIImage* image) {
            self.firstImage = image;
        }];
        
        [firstImageLoadSignal subscribeCompleted:^{
            [self.activityIndicatorFirstImage stopAnimating];
            NSLog(@"First Image loaded successfully");
        }];
        
        [self.activityIndicatorSecondImage startAnimating];
        RACSignal* secondSignal = [self getRACSignalForImageWithURL:CHAIN_LOAD_SECOND_IMAGE_URL];
        
        [secondSignal subscribeNext:^(UIImage* image) {
            self.secondImage = image;
        }];
        
        [secondSignal subscribeCompleted:^{
            [self.activityIndicatorSecondImage stopAnimating];
            NSLog(@"Second Image loaded successfully");
        }];
    }];
    
    [[self.clearAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* cleatAllButton) {
        self.firstImageView.image = nil;
        self.secondImageView.image = nil;
        self.firstImageView.backgroundColor = [UIColor lightGrayColor];
        self.secondImageView.backgroundColor = [UIColor lightGrayColor];
    }];
}

-(RACSignal*)getRACSignalForImageWithURL:(NSString*)stringURL {
    RACSignal* urlSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:[NSURL URLWithString:stringURL]];
        [subscriber sendCompleted];
        return nil;
    }] deliverOn:[RACScheduler scheduler]];
    
    return [[urlSignal map:^id(NSURL* value) {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:value]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}


@end
