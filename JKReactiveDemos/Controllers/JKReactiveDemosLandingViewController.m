//
//  JKReactiveDemosLandingViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveDemosLandingViewController.h"
#import "JKReactiveTextFieldsDemoViewController.h"
#import "JKReactiveSearchThrottleViewController.h"
#import "JKReactiveDownloadOperationViewController.h"
#import "JKReactiveCombineSignalsViewController.h"
#import "JKReactiveButtonActionsViewController.h"
#import "JKReactiveRacSequenceViewController.h"
#import "JKReactiveRACSignalLifecycleViewController.h"
#import "JKReactivePauseSignalViewController.h"
#import "JKReactiveTimeoutDemoViewController.h"
#import "InputValidationViewController.h"
#import "ImageUpdateDemoViewController.h"
#import "DemoReactiveSearchBarViewController.h"
#import "NetworkOperationViewController.h"
#import "JKReactiveAllMiscelleneousExamplesViewController.h"

//General enum for various option selections
typedef NS_ENUM(NSInteger, GeneralOptionTypes) {
    SearchThrottleDemo = 3,
    ReactiveDownloadDemo = 4,
    ReactiveRACSequenceDemo = 9,
    RACSignalLifecycleDemo = 10,
    RACTimeoutDemo = 11,
    ReactivePauseDemo = 12,
    ReactiveInputValidationDemo = 13,
    ReactiveImageUpdateDemo = 14,
    ReactiveSearchBarDemo = 15,
    ReactiveAllMiscellenousExamples = 16
};

@interface JKReactiveDemosLandingViewController ()

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* reactiveDemosList;
@property (strong, nonatomic) UIStoryboard* demoScreensStoryboard;
@property (strong, nonatomic) UIFont* defaultFontType;

@end

@implementation JKReactiveDemosLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.demoScreensStoryboard = [UIStoryboard storyboardWithName:@"DemoScreens" bundle:nil];
    self.tableView.tableFooterView = self.footerView;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.67 green:0.78 blue:0.25 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.defaultFontType = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    
    self.title = @"Reactive Cocoa Demo";
    self.reactiveDemosList = @[@"RACObserve with input textField mapped to Boolean Value", @"RACSignal with mapped input textField value", @"RACSignal with assigning input textField value to variable", @"Search Field with signal throttle and skip", @"Download operation with schedular", @"Combine Signals from multiple sources", @"Combine Signals with reduce", @"Assigning action to button using RACCommand", @"Executing command progress using indicator and rac_command along with completion block", @"rac_sequence Demo with Filter and Map functions", @"RACSignal lifecycle using subscribeNext and subscribeCompleted command", @"Simulate timeout with dummy Network request and RACDisposable object", @"Pause Signal - Add pause before next subscribeNext event. Subscribe next based on condition", @"Enable button based on input fields' validity", @"Update UI based on the dynamic change in internal variable values. (e.g. UIImage updates UIImageView)", @"UISearchBar Demo with text update detection", @"All miscelleneous examples"];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    NetworkOperationViewController* networkOperationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"networkoperation"];
    //    [self presentViewController:networkOperationVC animated:YES completion:NULL];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"democell" forIndexPath:indexPath];
    UILabel* demoTitleLabel = (UILabel*)[cell viewWithTag:13];
    UILabel* demoSequenceLabel = (UILabel*)[cell viewWithTag:14];
    
    demoTitleLabel.text = self.reactiveDemosList[indexPath.row];
    demoSequenceLabel.text = [NSString stringWithFormat:@"%ld.", (indexPath.row+1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* selectedDemo = self.reactiveDemosList[indexPath.row];
    if(indexPath.row < 3) {
        //We are demoing UITextFields integrated with Reactive Libraries
        JKReactiveTextFieldsDemoViewController* reactiveTextFieldsViewController = (JKReactiveTextFieldsDemoViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"textfields"];
        reactiveTextFieldsViewController.textFieldDemoTypeSelected = indexPath.row;
        reactiveTextFieldsViewController.selectedDemoName = selectedDemo;
        [self.navigationController pushViewController:reactiveTextFieldsViewController animated:YES];
    } else if (indexPath.row == SearchThrottleDemo) {
        JKReactiveSearchThrottleViewController* searchBarController = (JKReactiveSearchThrottleViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"searchthrottle"];
        [self.navigationController pushViewController:searchBarController animated:YES];
    } else if (indexPath.row == ReactiveDownloadDemo) {
        JKReactiveDownloadOperationViewController* downloadOperationViewController = (JKReactiveDownloadOperationViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"downloadoperation"];
        [self.navigationController pushViewController:downloadOperationViewController animated:YES];
    } else if (indexPath.row > ReactiveDownloadDemo && indexPath.row <7) {
        JKReactiveCombineSignalsViewController* signalsCombineViewController = (JKReactiveCombineSignalsViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"combinesignals"];
        signalsCombineViewController.demoTypeSelected = indexPath.row;
        [self.navigationController pushViewController:signalsCombineViewController animated:YES];
    } else if (indexPath.row > 6 && indexPath.row < ReactiveRACSequenceDemo) {
        JKReactiveButtonActionsViewController* reactiveButtomDemoViewController = (JKReactiveButtonActionsViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"buttonactions"];
        reactiveButtomDemoViewController.optionSelected = indexPath.row;
        [self.navigationController pushViewController:reactiveButtomDemoViewController animated:YES];
    } else if (indexPath.row == ReactiveRACSequenceDemo) {
        JKReactiveRacSequenceViewController* racSequenceController = (JKReactiveRacSequenceViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"racsequence"];
        [self.navigationController pushViewController:racSequenceController animated:YES];
    } else if (indexPath.row == RACSignalLifecycleDemo) {
        JKReactiveRACSignalLifecycleViewController* lifeCycleViewController = (JKReactiveRACSignalLifecycleViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"lifecycle"];
        [self.navigationController pushViewController:lifeCycleViewController animated:YES];
    } else if (indexPath.row == RACTimeoutDemo) {
        JKReactiveTimeoutDemoViewController* timeoutDemoController = (JKReactiveTimeoutDemoViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"timeout"];
        [self.navigationController pushViewController:timeoutDemoController animated:YES];
    } else if (indexPath.row == ReactivePauseDemo) {
        JKReactivePauseSignalViewController* pauseSignalViewController = (JKReactivePauseSignalViewController*) [self.demoScreensStoryboard instantiateViewControllerWithIdentifier:@"pausesignal"];
        [self.navigationController pushViewController:pauseSignalViewController animated:YES];
    } else if (indexPath.row == ReactiveInputValidationDemo) {
        InputValidationViewController* inputValidatorViewController = (InputValidationViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"inputvalidation"];
        [self.navigationController pushViewController:inputValidatorViewController animated:YES];
    } else if (indexPath.row == ReactiveImageUpdateDemo) {
        ImageUpdateDemoViewController* imageUpdateDemo = (ImageUpdateDemoViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"imagedemo"];
        [self.navigationController pushViewController:imageUpdateDemo animated:YES];
    } else if(indexPath.row == ReactiveSearchBarDemo){
        DemoReactiveSearchBarViewController* reactiveSearchViewController = (DemoReactiveSearchBarViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"reactivesearch"];
        [self.navigationController pushViewController:reactiveSearchViewController animated:YES];
    } else if (indexPath.row == ReactiveAllMiscellenousExamples) {
        JKReactiveAllMiscelleneousExamplesViewController* allMiscelleneousExamples = [self.storyboard instantiateViewControllerWithIdentifier:@"allMiscelleneuous"];
        [self.navigationController pushViewController:allMiscelleneousExamples animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reactiveDemosList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* currentDemoName = self.reactiveDemosList[indexPath.row];
    CGFloat heigh = [self heightForText:currentDemoName fontApplied:self.defaultFontType];
    return heigh;
}

-(CGFloat)heightForText:(NSString*)text fontApplied:(UIFont*)fontApplied {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = fontApplied;
    label.text = text;
    [label sizeToFit];
    return (label.frame.size.height + 30);
}

@end
