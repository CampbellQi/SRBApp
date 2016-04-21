//
//  NewsCenterModel.m
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewsCenterModel.h"

@implementation NewsCenterModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
