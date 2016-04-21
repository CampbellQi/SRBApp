//
//  SquareModel.m
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "SquareModel.h"

@implementation SquareModel
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

