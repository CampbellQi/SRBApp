//
//  MarkModel.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkModel.h"

@implementation MarkModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
}
@end
