//
//  PublishTopicModel.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/3.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PublishTopicModel.h"
#import "TPMarkModel.h"

@implementation PublishTopicModel
-(NSArray *)getMarks {
    NSMutableArray *array = [NSMutableArray new];
    for (TPMarkModel *model in self.marksArray) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:model.name ? model.name : @"" forKey:@"name"];
        [dict setObject:model.brand ? model.brand : @"" forKey:@"brand"];
        
        [dict setObject:model.origin ? model.origin : @"" forKey:@"origin"];
        [dict setObject:model.shopland ? model.shopland : @"" forKey:@"shopland"];
        
        [dict setObject:model.unit ? model.unit : @"" forKey:@"unit"];
        [dict setObject:model.shopprice ? model.shopprice : @"" forKey:@"shopprice"];
        [dict setObject:model.xyz forKey:@"xyz"];
        [dict setObject:model.shape forKey:@"shape"];
        [array addObject:dict];
    }
    return array;
}
@end
