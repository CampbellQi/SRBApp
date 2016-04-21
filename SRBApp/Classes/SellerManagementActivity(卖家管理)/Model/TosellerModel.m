//
//  TosellerModel.m
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//  给买家的评价

#import "TosellerModel.h"

@implementation TosellerModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
