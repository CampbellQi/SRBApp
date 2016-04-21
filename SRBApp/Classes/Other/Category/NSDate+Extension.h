//
//  NSDate+Extension.h
//  SRBApp
//
//  Created by zxk on 15/5/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;
@end
