//
//  GroupModel.m
//  SRBApp
//
//  Created by zxk on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
}

@end
