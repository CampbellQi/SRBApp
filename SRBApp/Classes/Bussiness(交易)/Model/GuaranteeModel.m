//
//  GuaranteeModel.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeModel.h"

@implementation GuaranteeModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
}
@end
