//
//  GuaranteeListModel.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeListModel.h"

@implementation GuaranteeListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.model_description = value;
    }
}
@end
