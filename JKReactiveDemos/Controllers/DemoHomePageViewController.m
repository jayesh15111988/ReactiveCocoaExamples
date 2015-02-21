//
//  DemoHomePageViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/1/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "DemoHomePageViewController.h"

#define THROTTLE_TIMEOUT 0.6

@interface DemoHomePageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UIButton *enableButton;
@property (assign, nonatomic) BOOL isEnabled;
@property (strong, nonatomic) NSString* testString;
@property (weak, nonatomic) IBOutlet UITextField *searchInputBox;
@property (weak, nonatomic) IBOutlet UIButton *triggerButton;
@property (weak, nonatomic) IBOutlet UIImageView *startImage;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *timeoutButton;
@property (weak, nonatomic) IBOutlet UIButton *combineButton;
@property (weak, nonatomic) IBOutlet UIButton *flattenMapButton;
@property (weak, nonatomic) IBOutlet UIButton *relationships;
@property (weak, nonatomic) IBOutlet UIButton *defActionsheetButton;


@end

@implementation DemoHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //First Demo
    RAC(self, isEnabled) = [RACObserve(self, inputText) map:^(UITextField* value) {
        return @([value.text length] > 1);
    }];
    
    //Second Demo
    RACSignal *validSalarySignal = [[self.inputText rac_textSignal] map:^id(NSString* value) {
        return value;
    }];
    
    [validSalarySignal subscribeNext:^(NSString* inputValue) {
        NSLog(@"Value entered %@",inputValue);
    }];

    //Third Demo
    //Dynamically bind textfield value to the RAC Signal
    RAC(self, testString) = [[self.inputText rac_textSignal] map:^id(NSString* value) {
        return value;
    }];
    
    //Fourth Demo
    RACSignal* signalForSearchField = [[[self.searchInputBox rac_textSignal] throttle:THROTTLE_TIMEOUT] skip:1];

    [signalForSearchField subscribeNext:^(NSString* searchString) {
        NSLog(@"Value entered is %@",searchString);
    }];
    
    
    //Backgorund operation for heavy outputs such as an image data
    //Fifth Demo
    self.enableButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        //Get the image and draw it on imageView
        RACSignal* racsig = [[self imageURLRACSignal] deliverOn:[RACScheduler scheduler]];
        [[[racsig map:^id(NSURL* value) {
            return [UIImage imageWithData:[NSData dataWithContentsOfURL:value]];
        }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage *imageOutput) {
            self.startImage.image = imageOutput;
        }];
        
        return [RACSignal empty];
    }];
    
    
    //Combine Latest Signals
    //Sixth Demo
    RACSignal* combinedSignal = [RACSignal combineLatest:@[[self firstRACSignal], [self secondRACSignal]]];
    [combinedSignal subscribeNext:^(RACTuple* tuple) {
        NSLog(@"Subscription successful with tuple %@ and tuple length %ld",tuple, tuple.count);
    }];
    
    
    //Combine With map
    //Seventh Demo
    RACSignal* combineLatestWithReduce = [RACSignal combineLatest:@[[self firstRACSignal], [self secondRACSignal]] reduce:^id(NSString* firstStringOutput, NSString* secondStringOutput){
        return [firstStringOutput stringByAppendingString:secondStringOutput];
    }];
    
    
    [combineLatestWithReduce subscribeNext:^(NSString* concatString) {
        NSLog(@"Concatenated String is %@",concatString);
    }];
    
    
    //Just another way to observe the value entered in UITextField
    //Eigth Demo - Deprecated redundant and not using in demo screen
    [[RACObserve(self, inputText.text) filter:^BOOL(NSString* value) {
        return value.length > 0;
    }] subscribeNext:^(NSString *currentValue) {
        NSLog(@"Value entered in the Text box IS : %@", currentValue);
    }];
    
    //Connecting button to RAC Signals
    //Ninth Demo
    RACCommand* command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self firstRACSignal];
    }];
    
    [command.executionSignals subscribeNext:^(RACSignal* signalWithName) {
        
        [[signalWithName map:^id(NSString* value) {
            return [value stringByAppendingString:@"This is tail of this string"];
        }] subscribeNext:^(NSString* valueReturned) {
            NSLog(@"Value returned from button triggered block is %@",valueReturned);
        }];
    }];
    
    self.triggerButton.rac_command = command;

    //Tenth Demo
    self.progressButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton* input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    __weak typeof(self) weakSelf = self;
    
    [self.progressButton.rac_command.executing subscribeNext:^(NSNumber* executing) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.progressButton.enabled = ![executing boolValue];
        strongSelf.progressButton.userInteractionEnabled = strongSelf.progressButton.enabled;
        
        if([executing boolValue]) {
            [strongSelf.activityIndicator startAnimating];
            NSLog(@"Executing Signal");
        }
        else {
            [strongSelf.activityIndicator stopAnimating];
            NSLog(@"Execution Signal Finished");
        }
    }];
    
    [self.progressButton.rac_command.executionSignals subscribeNext:^(RACSignal* progressButtonSignal) {
        [progressButtonSignal subscribeNext:^(UIButton* x) {
            NSLog(@"Button sent by the first Signal %@",x);
        }];
    }];
    

    //Eleventh Demo
    NSArray* stringArray = @[@"jayesh",@"kawli",@"mira",@"anagha"];
    NSArray* filteredArray = [[stringArray.rac_sequence filter:^BOOL(NSString* value) {
        return (value.length > 4);
    }] map:^id(NSString* value) {
        return [value stringByAppendingString:@" Tail Part"];
    }].array;
    NSLog(@"Filetred Array %@",filteredArray);
    
    
    //More Complex Example
    //Twelvth Demo
    RACSignal* complexSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"Jayesh"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    [complexSignal subscribeNext:^(NSString* firstName) {
        NSLog(@"%@",firstName);
    }];
    
    [complexSignal subscribeCompleted:^{
        NSLog(@"First Name Block Completed");
    }];
    
    [complexSignal subscribeError:^(NSError *error) {
        NSLog(@"Error Occurred with description %@",[error localizedDescription]);
    }];
    
    //Thirteenth Demo
    RACSubject* letters = [RACSubject subject];
    RACSignal* lettersSignal = letters;
    
    [lettersSignal subscribeNext:^(NSString* inputString) {
        NSLog(@"\n This is Microsoft Arena %@",inputString);
    }];

    
    [letters sendNext:@"C Sharp"];
    [letters sendNext:@"Windows"];
    
    [lettersSignal subscribeNext:^(NSString* inputString) {
        NSLog(@"This is Apple Arean %@",inputString);
    }];
    
    [letters sendNext:@"iOS"];
    [letters sendNext:@"Objective-C"];
    
    //Fourteenth demo
    @weakify(self);
    self.timeoutButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self simulateTimeout];
        return [RACSignal empty];
    }];
    
    
    //More and More complex example
    //How to use combineLatest in Reactive Way
    //Fiftinth Demo
    self.combineButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self simulateCombineAndReduce];
        return [RACSignal empty];
    }];
    
    //Sixteenth Demo
    self.flattenMapButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self simulateFlattenMap];
        return [RACSignal empty];
    }];
    
    //Seventeenth and Eigtheenth and Nineteenth Demo
    self.relationships.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self simulateRelationships];
        return [RACSignal empty];
    }];
    
    //Twentieth Demo
    self.defActionsheetButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        //This is to show action sheet with defer in it
        //We won't need subscriber in this case to put when creating a new signal
        [self showActionSheet];
        return [RACSignal empty];
    }];
}

//Twentieth Demo
-(void)showActionSheet {
    RACSignal* deferSignal = [RACSignal defer:^RACSignal *{
        UIActionSheet* sheet = [UIActionSheet new];
        [sheet addButtonWithTitle:@"asdas"];
        [sheet addButtonWithTitle:@"asda"];
        [sheet addButtonWithTitle:@"adasd"];
        sheet.destructiveButtonIndex = 2;
        [sheet showInView:self.view];
        return [sheet.rac_buttonClickedSignal filter:^BOOL(id value) {
            return ([value integerValue] == sheet.destructiveButtonIndex);
        }];
    }];
    
    //Only deferSignal is non-empty this block gets executed. This happens only if 
    [deferSignal subscribeNext:^(id x) {
        NSLog(@"Value received is %@",x);
    }];
}

-(void)simulateRelationships {
    
    RACSignal* signalWithMultipleSubscribers = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
    
    //In more complex way, multicast way
    //With multicast, we will have one signal and multiple subscriners. Signal will not be reexecuted for
    //Multiple subscribers
    //This is very similar to example given above
    
    RACMulticastConnection* connection = [signalWithMultipleSubscribers multicast:[RACReplaySubject subject]];
    [connection connect];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"More Complex, first block executed with data %@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"More Complex, second block executed with data %@",x);
    }];
    
    RACSignal* samplePauseSignl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"jayesh"];
        return nil;
    }];
    
    //Add Delay before sending RACSignal back    
    RACSignal* pauseSig = [samplePauseSignl flattenMap:^id(NSString* returnedValue) {
        RACSignal *pauseSignal = [RACSignal return:@(returnedValue.length > 0)];
        if (pause) {
            return [pauseSignal delay:2.5];
        } else {
            return pauseSignal;
        }
    }];
    
    [pauseSig subscribeNext:^(id x) {
        NSLog(@"Value received from pause signal %@",x);
    }];
}

-(void)simulateFlattenMap {
    RACSignal* firstSig = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"1",@"2",@"3"]];
        return nil;
    }];
    
    RACSignal* mappedSignal = [firstSig flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:[value arrayByAddingObject:@" Tail Part"]];
            return nil;
        }];
    }];
    
    [mappedSignal subscribeNext:^(id x) {
        NSLog(@"Transformed Value is %@",x);
    }];
    
}

-(void)simulateCombineAndReduce {
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
        NSLog(@"Signal Received with returned values %@",tupleWithCombinedValuesFromBothSignals);
    }];
    
    RACSignal* reducedRACSignal = [RACSignal zip:@[firstSig, secondSig] reduce:^(NSArray* firstArray, NSArray* secondArray){
        return [firstArray arrayByAddingObjectsFromArray:secondArray];
    }];
    
    [reducedRACSignal subscribeNext:^(NSArray* combinedArray) {
        NSLog(@"Combined Array is %@",combinedArray);
    }];
}

-(void)simulateTimeout {
    RACSignal* networkOperationSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACDisposable* disposableObject = [RACDisposable new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSInteger totalNumberOfObjects = 5;
            for(NSInteger i = 0; (i< totalNumberOfObjects) && !disposableObject.isDisposed; i++) {
                NSLog(@"Executing...");
                [subscriber sendNext:@(i)];
                [NSThread sleepForTimeInterval:1.0];
            }
            
            if(!disposableObject.isDisposed) {
                NSLog(@"Send Completed Executed Successfully");
                [subscriber sendCompleted];
            }
        });
        return disposableObject;
    }];
    
    [[[networkOperationSignal deliverOn:[RACScheduler mainThreadScheduler]] timeout:2.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSNumber* x) {
        NSLog(@"Getting value %ld", (long)[x integerValue]);
    } error:^(NSError *error) {
        NSLog(@"Failed With Error %@",[error localizedDescription]);
    } completed:^{
        NSLog(@"Completed System");
    }];
}

-(RACSignal*)firstRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"First Signal Block"];
        [subscriber sendCompleted];
        return nil;
    }];
}

-(RACSignal*)secondRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"Second Signal Block"];
        return nil;
    }];
}

-(RACSignal*)imageURLRACSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:[NSURL URLWithString:@"http://static.sportskeeda.com/wp-content/uploads/2014/03/roger-federer2-2142450.jpg"]];
        return nil;
    }];
}


- (IBAction)enableButtonPressed:(id)sender {
     NSLog(@"Value of test string is %@",self.testString);
}

@end
