//
//  MyAssureThingModel.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyAssureThingModel.h"

@implementation MyAssureThingModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
    if ([key isEqualToString:@"decription"]) {
        self.model_description = value;
    }
}
@end
