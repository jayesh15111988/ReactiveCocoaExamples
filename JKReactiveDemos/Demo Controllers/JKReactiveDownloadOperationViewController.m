//
//  JKReactiveDownloadOperationViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveDownloadOperationViewController.h"

@interface JKReactiveDownloadOperationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentOperationStatus;
@property (weak, nonatomic) IBOutlet UIButton *downloadButtonImage;
@property (weak, nonatomic) IBOutlet UIImageView *outputImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *inputURLField;
@property (strong, nonatomic) NSString* currentOperationStatusString;
@property (strong, nonatomic) NSString* oldURL;
@end

@implementation JKReactiveDownloadOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentOperationStatusString = @"";
    self.title = @"RACSchedular Downloader";
    
    [RACObserve(self, currentOperationStatusString) subscribeNext:^(NSString* messageToDisplay) {
        self.currentOperationStatus.text = messageToDisplay;
    }];
    
    self.downloadButtonImage.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if(![self.oldURL isEqualToString:self.inputURLField.text]) {
            if(self.inputURLField.text.length > 9) {
                self.oldURL = self.inputURLField.text;
                [self.activityIndicator startAnimating];
                self.currentOperationStatusString = [NSString stringWithFormat:@"Downaloding image from URL %@", self.inputURLField.text];
                //Downalod operation
                RACSignal* racsig = [[self imageURLRACSignal] deliverOn:[RACScheduler scheduler]];
                [[[racsig map:^id(NSURL* value) {
                    NSData* remoteImageData = [NSData dataWithContentsOfURL:value];
                    if(remoteImageData != nil) {
                        return [UIImage imageWithData:remoteImageData];
                    }
                    return [UIImage imageNamed:@""];
                }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *imageOutput) {
                    [self.activityIndicator stopAnimating];
                    if(imageOutput) {
                        self.currentOperationStatusString = @"Image Download Operation Successfully Completed";
                        self.outputImageView.image = imageOutput;
                    } else {
                        self.currentOperationStatusString = @"Failed to get image from input URL. Please check it and try again it later";
                    }
                }];
            } else {
                self.currentOperationStatusString = @"URL Link should be at least 10 characters in length";
        }
    } else {
            self.currentOperationStatusString = @"Image from this URL already downloaded";
    }
        return [RACSignal empty];
    }];
    
    [self.downloadButtonImage.rac_command.executing subscribeNext:^(NSNumber* executing) {
        if ([executing boolValue]) {
            NSLog(@"Executing");
        } else {
            NSLog(@"Finished Execution");
        }
    }];
}

-(RACSignal*)imageURLRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:[NSURL URLWithString:self.inputURLField.text]];
        return nil;
    }];
}

@end
