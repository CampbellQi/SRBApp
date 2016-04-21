//
//  ZZMyAttentionInfoModel.m
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZMyAttentionInfoModel.h"

@implementation ZZMyAttentionInfoModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
}
@end
