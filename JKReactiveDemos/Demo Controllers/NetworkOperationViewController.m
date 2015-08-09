//
//  NetworkOperationViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/1/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "NetworkOperationViewController.h"
#import "Airline.h"

@interface NetworkOperationViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager* manager;
@property (weak, nonatomic) IBOutlet UIButton *networkOpearationButton;

@end

@implementation NetworkOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Twenty Second Demo
    self.manager = [[AFHTTPRequestOperationManager alloc]
                    initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, API_EXTENSION]]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    [[[[self getNetworkDataWithEndpoint:@"test1.php"] flattenMap:^RACStream *(RACTuple* value) {
        return [self getNetworkDataWithEndpoint:value[1][@"next"]];
    }] flattenMap:^RACStream *(RACTuple* value) {
        return [self getNetworkDataWithEndpoint:value[1][@"next"]];
    }] subscribeNext:^(RACTuple* value) {
        NSLog(@"Value received from server %@", value[1]);
    } error:^(NSError *error) {
        
    }];
    
    [self concatOperation];
}

- (void)concatOperation {
    RACSignal* first = [self getNetworkDataWithEndpoint:@"test1.php"];
    RACSignal* second = [self getNetworkDataWithEndpoint:@"test2.php"];
    RACSignal* third = [self getNetworkDataWithEndpoint:@"test3.php"];

    NSArray* signals = @[first, second, third];
    [[RACSignal concat:signals] subscribeNext:^(id x) {
        // This block will be executed for each and every signal associated here.
    } completed:^{
        // This block will be executed only once after all serial operations are complete.
    }];
   
}

-(RACSignal*)getNetworkDataWithEndpoint:(NSString*)endPoint {
    RACSignal* networkOperationSignal = [self.manager rac_GET:[NSString stringWithFormat:@"%@/%@",BASE_URL_SHORT, endPoint] parameters:nil];
    return networkOperationSignal;
}

@end
