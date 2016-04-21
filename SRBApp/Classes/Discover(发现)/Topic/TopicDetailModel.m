//
//  TopicDetailModel.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/30.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailModel.h"
#import "TPMarkModel.h"

@implementation TopicDetailModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"model_id":@"id", @"model_description": @"description"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.model_description = value;
    }
}

-(NSDictionary *)objectClassInArray {
    return @{@"labels": [TPMarkModel class]};
    //return @{@"subTypes": [MeetingAndStationType class]};
}
@end
