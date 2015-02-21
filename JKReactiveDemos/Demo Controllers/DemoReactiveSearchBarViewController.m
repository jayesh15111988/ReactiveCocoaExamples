//
//  DemoReactiveSearchBarViewController.m
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/7/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "DemoReactiveSearchBarViewController.h"
#import "UISearchBar+RAC.h"

@interface DemoReactiveSearchBarViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString* searchString;

@end

@implementation DemoReactiveSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search Bar with RAC";
    //Different way to observe value of string based on the input of search string in searchbar
    RACSignal* searchBarSignal =  [[self.searchBar rac_textSignal] map:^id(NSString* value) {
        if(!value.length) {
            value = @"Search String Output";
        }
        return [self getAttributedStringFromRegularString:value];
    }];
    
    [searchBarSignal subscribeNext:^(NSAttributedString* decoratedSearchText) {
        self.resultLabel.attributedText = decoratedSearchText;
    }];
}

-(NSAttributedString*)getAttributedStringFromRegularString:(NSString*)inputString {
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:inputString attributes:
       @{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0],
       NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:100/255.0 blue:100/255.0 alpha:1.0],
       NSBackgroundColorAttributeName : [UIColor colorWithRed:140/255.0 green:180/255.0 blue:140/255.0 alpha:0.8]
       }];
       return attributedString;
}

@end
