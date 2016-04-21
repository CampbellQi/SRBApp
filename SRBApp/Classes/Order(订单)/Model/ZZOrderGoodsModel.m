//
//  ZZOrderGoodsModel.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZOrderGoodsModel.h"

@implementation ZZOrderGoodsModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}
@end
