//
//  JKReactiveMiscelleneousExamples.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/20/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveMiscelleneousExamples.h"
#import "Airline.h"

@interface JKReactiveMiscelleneousExamples ()

@property (nonatomic, assign) NSNumber* secondsNumber;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) NSInteger currentSeconds;

@end

@implementation JKReactiveMiscelleneousExamples

-(void)subscribeFirstSendSignalLaterDemo {
    
    RACSubject* letters = [RACSubject subject];
    RACSignal* lettersSignal = letters;
    
    //Already create an action to take when signal is subscribed to this action
    [lettersSignal subscribeNext:^(NSString* inputString) {
        NSLog(@"\n This is Microsoft Arena %@",inputString);
    }];
    
    
    [letters sendNext:@"C Sharp"];
    [letters sendNext:@"Windows"];
    
    [lettersSignal subscribeNext:^(NSString* inputString) {
        NSLog(@"This is Apple Arena %@",inputString);
    }];
    
    [letters sendNext:@"iOS"];
    [letters sendNext:@"Objective-C"];
}

-(void)zipAndReduceSignalsDemo {
    
    RACSignal* firstSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"1",@"2",@"3"]];
        return nil;
    }];
    
    RACSignal* secondSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"4",@"5",@"6"]];
        return nil;
    }];
    
    RACSignal* combinedSignal = [RACSignal zip:@[firstSig, secondSig]];
    
    [combinedSignal subscribeNext:^(RACTuple* tupleWithCombinedValuesFromBothSignals) {
        //First object in RACTuple - 1, 2, 3
        //Second object - 4, 5, 6
        NSLog(@"Signal Received with returned values %@",tupleWithCombinedValuesFromBothSignals);
    }];
    
    RACSignal* reducedRACSignal = [RACSignal zip:@[firstSig, secondSig] reduce:^(NSArray* firstArray, NSArray* secondArray){
        return [firstArray arrayByAddingObjectsFromArray:secondArray];
    }];
    
    [reducedRACSignal subscribeNext:^(NSArray* combinedArray) {
        //We combined both signals in reduce block
        //Output is [1, 2, 3, 4, 5, 6]
        NSLog(@"Combined Array is %@",combinedArray);
    }];
}

-(void)flattenMapDemo {
    
    //Flatten map is used to convert a value to signal to which any subscribers can be joined in the future
    RACSignal* firstSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"1",@"2",@"3"]];
        return nil;
    }];
    
    RACSignal* mappedSignal = [firstSig flattenMap:^RACStream *(id value) {
        //This is very simple. But really complex signal could be created from input value
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:[value arrayByAddingObject:@" Tail Part"]];
            return nil;
        }];
    }];
    
    [mappedSignal subscribeNext:^(id x) {
        NSLog(@"Transformed Value is %@",x);
    }];
}

-(void)signalReplayDemo {
    
    //We will have one signal and multiple subscribers in simple way. Replay is important as eliminating this parameter will give different signals for each subscribers subsequently

    RACSignal* signalWithMultipleSubscribers = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //We will send same data to each and every future subscriber
        [subscriber sendNext:@"Sending Data to Subscriber"];
        return nil;
    }];
    
    //One signal multiple subscribers in a simple way
    RACSignal* replaySignal = [signalWithMultipleSubscribers replay];
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"Data Received By First Subscriber %@",x);
    }];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"Data Received By Second Subscriber %@",x);
    }];
    
    [replaySignal subscribeNext:^(id x) {
        NSLog(@"Data Received By Third Subscriber %@",x);
    }];
}

-(void)reactiveMulticastingDemo {
    //Reactive cocoa - Single signal multiple subscribers using multicasting.
    
    RACSignal* signalWithMultipleSubscribers = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"Sending Data to Subscriber"];
        return nil;
    }];
    
    //We will use RACReplay method just to make sure multiple subscribers are using the same signal
    RACMulticastConnection* connection = [signalWithMultipleSubscribers multicast:[RACReplaySubject subject]];
    [connection connect];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"More Complex, first block executed with data %@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"More Complex, second block executed with data %@",x);
    }];
}

-(void)deferSignalWithActionSheet {
    //Defer means the block inside won't get executed unless it has at least one
    RACSignal* deferSignal = [RACSignal defer:^RACSignal *{
        UIActionSheet* sheet = [UIActionSheet new];
        [sheet addButtonWithTitle:@"Steve Jobs"];
        [sheet addButtonWithTitle:@"Larry Page"];
        [sheet addButtonWithTitle:@"Larry Ellison"];
        [sheet addButtonWithTitle:@"Bill Gates"];
        sheet.destructiveButtonIndex = 3;
        
        //Just uncomment this line to show it in your current UIViewController
        //[sheet showInView:self.view];
        //Only return non-empty signal is button clicked has index other than destructive button
        return [sheet.rac_buttonClickedSignal filter:^BOOL(NSNumber* value) {
            return ([value integerValue] != sheet.destructiveButtonIndex);
        }];
    }];

    //This signal will not get fired only if button pressed by user is other than destructive button
    //This will be a value of button index pressed
    [deferSignal subscribeNext:^(id x) {
        NSLog(@"Options Selected from Action sheet is %@",x);
    }];
}

-(void)handleButtonClickEvents {
    //Say you have a button named myTestButton, you have to detect the click. Instead of adding redundant IBAction on it, you can easily simulate clikc using RACSignal events like below
    UIButton* myTestButton = [UIButton new];
    [[myTestButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* testButton) {
        NSLog(@"Test button %@ pressed", testButton);
    }];
    
    //There is another way to handle button click as follows
    myTestButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* testButton) {
        NSLog(@"Test button %@ pressed", testButton);
        return [RACSignal empty];
    }];
}

-(void)reactiveCocoaNetworkRequest {
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]
                    initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL, API_EXTENSION]]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    RACSignal* networkOperationSignal = [self getNetworkDataWithManager:manager];
    
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
}

-(RACSignal*)getNetworkDataWithManager:(AFHTTPRequestOperationManager*)manager {
    //Please put the URL and parameters of your choice - This is just a dummy request with dummy parameters
    RACSignal* networkOperationSignal = [manager rac_GET:@"airlines/rest/v1/json/all" parameters:@{@"appId" : APP_ID,
                                                                                                        @"appKey" : APP_KEY}];
    return networkOperationSignal;
}


//This is just a dummy object model - Not necessarily will it suit to your needs. Please change it accordingly
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

-(void)RACCommandExecutionStatusDemo {
    //RACCommand execution
    //Say you have a button to perform heavy network / background operation called beginHeavyOperationButton
    UIButton* beginHeavyOperationButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    beginHeavyOperationButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"Operation Continuing"];
            [subscriber sendCompleted];
            return nil;
        }] replayLazily]; //Using replay lazily to make sure this block does not get executed unless there is any subscrober to this signal
    }];
    
    //Order of execution is denoted as follows
    
    [beginHeavyOperationButton.rac_command.executing subscribeNext:^(id x) {
        if([x boolValue]) {
            //First
            NSLog(@"Signal is executing.");
        } else {
            //Fourth
            NSLog(@"Signal execution completed!");
        }
    }];
    
    [beginHeavyOperationButton.rac_command.executionSignals subscribeNext:^(RACSignal* signal) {
        [signal subscribeNext:^(NSString* outputString) {
            //outputString = @"Operation Continuing"
            //Second
            NSLog(@"Signal executing next block to which it is subscribed to");
        }];
        [signal subscribeCompleted:^{
            //Third
            NSLog(@"Finally Completed Execution of this Block");
        }];
    }];
    
    //You can also manually trigger the RACCommand execution once you have variable in which RACCommand is stored
    //Say you want to manually execute above raccommand, which will essentially simulate the button click
    [beginHeavyOperationButton.rac_command execute:nil];
    //It will have a same effect as the button click
}

-(void)switchToLatestDemo {
    self.currentSeconds = 0;
    [self setupTimer];
    
    //Each time secondsNumber value is changed, this block will be executed
    //Add delay to simulate switch to latest result on this operation
    
    [[[RACObserve(self, secondsNumber) map:^id(NSNumber* secs) {
        [NSThread sleepForTimeInterval:1.0];
        NSInteger originalNumberOfSeconds = [secs integerValue];
        NSNumber* updatedNumber = @(originalNumberOfSeconds*10);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:updatedNumber];
            return  nil;
        }];
    }] switchToLatest] subscribeNext:^(NSNumber* secondsSecondBlock) {
        NSLog(@"Current seconds *10 are %ld",(long)[secondsSecondBlock integerValue]);
    }];
}

-(void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

-(void)resetTimer {
    [self.timer invalidate];
}

-(void)timerCallback {
    self.currentSeconds++;
    self.secondsNumber = @(self.currentSeconds);
}

@end
