//
//  BussinessModel.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessModel.h"
#import "NSString+CalculateSize.h"

@implementation BussinessModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.model_id = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.model_description = value;
    }
    if ([key isEqualToString:@"position"]) {
        self.model_position = value;
    }
}
//- (NSDictionary *)replacedKeyFromPropertyName
//{
//    return @{@"goods":@"id",@"descriptions":@"description",@"photosA":@"photos"};
//}
//-(NSDictionary *)objectClassInArray {
//    return @{@"goods": [BussinessModel class]};
//    //return @{@"subTypes": [MeetingAndStationType class]};
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
