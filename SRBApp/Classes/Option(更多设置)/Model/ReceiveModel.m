//
//  ReceiveModel.m
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ReceiveModel.h"

@implementation ReceiveModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.iD = value;
    }
}
@end
