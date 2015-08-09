//
//  JKReactiveAllMiscelleneousExamplesViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 8/9/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveAllMiscelleneousExamplesViewController.h"

@interface JKReactiveAllMiscelleneousExamplesViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;

@end

@implementation JKReactiveAllMiscelleneousExamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[AFHTTPRequestOperationManager alloc]
                    initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL_SHORT, API_EXTENSION]]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    self.title = @"Miscelleneous Examples with Reactive";
    RACChannelTerminal* terminal1 = [self.textField1 rac_newTextChannel];
    RACChannelTerminal* terminal2 = [self.textField2 rac_newTextChannel];
    
    //[terminal1 subscribe:terminal2];
    //[terminal2 subscribe:terminal1];
    
    [[terminal1 map:^id(NSString* value1) {
        return value1;
    }] subscribe:terminal2];
    
    [[terminal2 map:^id(NSString* value2) {
        return value2;
    }] subscribe:terminal1];
    
    [[[self rac_signalForSelector:@selector(doItWithFirst:andSecond:andThird:)] reduceEach:^id(NSString* first, NSString* second, NSString* third){
        return [NSString stringWithFormat:@"%@ %@ %@", first, second, third];
    }] subscribeNext:^(id x) {
        
    }];
    [self doItWithFirst:@"first" andSecond:@"second" andThird:@"third"];
    
    RACSignal* firstSignal = [self getNetworkDataWithEndpoint:@"test1.php"];
    RACSignal* secondSignal = [self getNetworkDataWithEndpoint:@"test2.php"];
    RACSignal* mergedSignals = [RACSignal merge:@[firstSignal, secondSignal]];
    
    [mergedSignals subscribeNext:^(RACTuple* tuple) {
        
    } completed:^{
        
    }];
    
    // How to arrange signals with RACScheduler
    RACScheduler* serializedScheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault];
    [serializedScheduler schedule:^{
        BOOL success;
        NSError* error;
        id finalValue = [[[self getNetworkDataWithEndpoint:@"test1.php"] flattenMap:^RACStream *(id value) {
            return [self getNetworkDataWithEndpoint:@"test2.php"];
        }] firstOrDefault:@"val" success:&success error:&error];

        if (success) {
            NSLog(@"Success with final value %@", finalValue[1]);
        } else {
            NSLog(@"Error %@ and Default value is %@", [error localizedDescription], finalValue);
        }
    }];
}

- (void)doItWithFirst:(NSString*)first andSecond:(NSString*)second andThird:(NSString*)third {
    
}

-(RACSignal*)getNetworkDataWithEndpoint:(NSString*)endPoint {
    RACSignal* networkOperationSignal = [self.manager rac_GET:[NSString stringWithFormat:@"%@/%@",BASE_URL_SHORT, endPoint] parameters:nil];
    return networkOperationSignal;
}

@end
