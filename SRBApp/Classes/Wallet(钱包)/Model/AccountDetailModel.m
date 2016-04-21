//
//  AccountDetailModel.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "AccountDetailModel.h"

@implementation AccountDetailModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
    if ([key isEqualToString:@"type"]) {
        self.model_type = value;
    }
}
@end
