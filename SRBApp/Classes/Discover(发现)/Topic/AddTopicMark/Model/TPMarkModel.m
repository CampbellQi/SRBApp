//
//  TPMarkModel.m
//  testImageEdit
//
//  Created by fengwanqi on 15/11/2.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "TPMarkModel.h"

@implementation TPMarkModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

-(NSDictionary *)transToDict {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.name ? self.name : @"" forKey:@"name"];
    [dict setObject:self.brand ? self.brand : @"" forKey:@"brand"];
    
    [dict setObject:self.origin ? self.origin : @"" forKey:@"origin"];
    [dict setObject:self.shopland ? self.shopland : @"" forKey:@"shopland"];
    
    [dict setObject:self.unit ? self.unit : @"" forKey:@"unit"];
    [dict setObject:self.shopprice ? self.shopprice : @"" forKey:@"shopprice"];
    [dict setObject:self.xyz forKey:@"xyz"];
    [dict setObject:self.shape forKey:@"shape"];
    
    return dict;
}
@end
