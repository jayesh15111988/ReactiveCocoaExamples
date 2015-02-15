//
//  JKReactiveDemosLandingViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/15/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKReactiveDemosLandingViewController.h"

@interface JKReactiveDemosLandingViewController ()
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* reactiveDemosList;
@end

@implementation JKReactiveDemosLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = self.footerView;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.67 green:0.78 blue:0.25 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"Reactive Cocoa Demo";
    self.reactiveDemosList = @[@"Reactive 1", @"Reactive 2"];
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"democell" forIndexPath:indexPath];
    UILabel* demoTitleLabel = (UILabel*)[cell viewWithTag:13];
    demoTitleLabel.text = self.reactiveDemosList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            NSLog(@"First row selected");
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reactiveDemosList count];
}


@end
