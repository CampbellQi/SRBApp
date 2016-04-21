//
//  TopicCommentModel.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TopicCommentModel.h"

@implementation TopicCommentModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"model_id":@"id"};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
}
//-(NSDictionary *)objectClassInArray {
//    return @{@"goods": [BussinessModel class]};
//    //return @{@"subTypes": [MeetingAndStationType class]};
//}
@end
