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
    
    self.manager = [[AFHTTPRequestOperationManager alloc]
                    initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, API_EXTENSION]]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    RACSignal* networkOperationSignal = [self getNetworkData];
    
    [networkOperationSignal subscribeNext:^(RACTuple* tuple) {
        NSArray* collectionOfAirlines = tuple[1][@"airlines"];
        RACSignal* signalWithAirlinesCollection = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:collectionOfAirlines];
            [subscriber sendCompleted];
            return nil;
        }];
        
        RACSignal* signalWithModelsConversion = [self convertdictionaryToModels:signalWithAirlinesCollection];
        
        [signalWithModelsConversion subscribeNext:^(NSArray* airlinesCollection) {
            NSLog(@"Total objects %lu",(unsigned long)[airlinesCollection count]);
        }];
        
        [signalWithModelsConversion subscribeError:^(NSError *error) {
            NSLog(@"Error %@ Occurred",[error localizedDescription]);
        } completed:^{
            NSLog(@"Network data import and models creation operation finished");
        }];
    }];
    

    NSString* temp = @"Reactive Cocoa is so confusing";
    
    self.networkOpearationButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(temp);
        
        return [RACSignal empty];
    }];
    
    
    temp = @"Ractive cocoa is straightforward";
    
    [[self.networkOpearationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    }];
    
}

-(RACSignal*)convertdictionaryToModels:(RACSignal*)dictSignal {
    return [dictSignal map:^id(NSArray* dictCollection) {
      
        NSMutableArray* modelsCollection = [NSMutableArray new];
        
        for(NSDictionary* individualDict in dictCollection) {
            Airline* airlineModel = [Airline new];
            airlineModel.name = individualDict[@"name"];
            airlineModel.iata = individualDict[@"iata"];
            airlineModel.isActive = [individualDict[@"active"] boolValue];
            [modelsCollection addObject:airlineModel];
        }
        
        return [modelsCollection copy];
    }];
}

-(RACSignal*)getNetworkData {
    
    
    
    RACSignal* networkOperationSignal = [self.manager rac_GET:@"airlines/rest/v1/json/all" parameters:@{@"appId" : APP_ID,
                                                                                                        @"appKey" : APP_KEY}];
    
    return networkOperationSignal;
}



@end
