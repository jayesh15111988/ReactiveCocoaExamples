//
//  JKReactiveMiscelleneousExamples.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/20/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveMiscelleneousExamples.h"

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
    
    //We will have one signla and multiple subscribers in simple way. Replay is important as eliminating this parameter will give different signals for each subscribers subsequently

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

@end
