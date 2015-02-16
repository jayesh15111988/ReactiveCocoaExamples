//
//  JKReactiveDemosLandingViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveDemosLandingViewController.h"
#import "JKReactiveTextFieldsDemoViewController.h"

@interface JKReactiveDemosLandingViewController ()
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* reactiveDemosList;
@property (strong, nonatomic) UIStoryboard* demoScreensStoryboard;
@end

@implementation JKReactiveDemosLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.demoScreensStoryboard = [UIStoryboard storyboardWithName:@"DemoScreens" bundle:nil];
    self.tableView.tableFooterView = self.footerView;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.67 green:0.78 blue:0.25 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];

    self.title = @"Reactive Cocoa Demo";
    self.reactiveDemosList = @[@"RACObserve with input textField mapped to Boolean Value", @"RACSignal with mapped input textField value", @"RACSignal with assigning input textField value to variable", @"Search Field with signal throttle and skip", @"Download operation with schedular", @"Combine Signals from multiple sources", @"Combine Signals with reduce", @"Dynamically Filter input textField value", @"Assigning action to button using RACCommand", @"rac_sequence Demo with Filter and Map functions", @"Executing command progress using indicator and rac_command along with completion block", @"RACSignal lifecycle using subscribeNext and subscribeCompleted command", @"Subscribe first, send data later!", @"Simulate timeout with dummy Network request and RACDisposable object", @"RACSignal zip, reduce. Interaction with RACTuple", @"Simulate Flatten map - Mapping value to signal", @"Replay Signals. Use older value", @"Multicast. Multiple observers for single observee", @"Pause Signal - Add pause before next subscribeNext event. Subscribe next based on condition", @"Action Sheet in operation using Reactive Signals", @"Enable button based on input fields' validity", @"Network Operation using Reactive Signals", @"Another way to handle button clicks using rac_signalForControlEvents method", @"Update UI based on the dynamic change in internal variable values. (e.g. UIImage updates UIImageView)", @"RACSignal executing update with Activity Indicator one more time", @"Execute RACCommand manually with execute method call", @"UISearchBar Demo with text update detection and SwitchToLatest"];
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"democell" forIndexPath:indexPath];
    UILabel* demoTitleLabel = (UILabel*)[cell viewWithTag:13];
    demoTitleLabel.text = self.reactiveDemosList[indexPath.row];
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
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reactiveDemosList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* currentDemoName = self.reactiveDemosList[indexPath.row];
    CGFloat heigh = [self heightForText:currentDemoName fontApplied:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]];
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
