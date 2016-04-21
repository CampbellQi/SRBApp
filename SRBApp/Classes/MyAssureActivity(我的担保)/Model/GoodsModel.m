//
//  GoodsModel.m
//  SRBApp
//
//  Created by lizhen on 15/1/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.cover = value;
    }
}
@end
