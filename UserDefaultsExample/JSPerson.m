//
//  JSPerson.m
//  UserDefaultsExample
//
//  Created by Johnny on 11/1/12.
//  Copyright (c) 2012 Johnny Slagle. All rights reserved.
//

#import "JSPerson.h"

#pragma mark - Encoding Keys
static NSString *JSPersonNameKey = @"name";
static NSString *JSPersonNumberKey = @"number";

@implementation JSPerson

#pragma mark - Init Methods
- (id)initWithName:(NSString *)iName andNumber:(NSString *)iNumber {
    self = [super init];
    if (self) {
        self.name = iName;
        self.number = iNumber;
    }
    return self;
}

#pragma mark - Coder Methods
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.name = [decoder decodeObjectForKey:JSPersonNameKey];
        self.number = [decoder decodeObjectForKey:JSPersonNumberKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:JSPersonNameKey];
    [encoder encodeObject:self.number forKey:JSPersonNumberKey];
}

@end
