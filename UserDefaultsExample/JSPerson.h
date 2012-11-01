//
//  JSPerson.h
//  UserDefaultsExample
//
//  Created by Johnny on 11/1/12.
//  Copyright (c) 2012 Johnny Slagle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  JSPerson
 *
 *  This is a simple object to demonstrate how to implement initWithCoder and encodeWithCoder.
 */
@interface JSPerson : NSObject

#pragma mark - Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;

#pragma mark - Custom Init Methods
- (id)initWithName:(NSString *)iName andNumber:(NSString *)iNumber;

@end

