//
//  Airline.h
//  JKReactiveDemos
//
//  Created by Jayesh Kawli Backup on 2/1/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Airline : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* iata;
@property (nonatomic, assign) BOOL isActive;
@end
