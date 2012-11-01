//
//  JSAppDelegate.h
//  UserDefaultsExample
//
//  Created by Johnny on 11/1/12.
//  Copyright (c) 2012 Johnny Slagle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSTableViewController;

@interface JSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSTableViewController *tableViewController;

@end
