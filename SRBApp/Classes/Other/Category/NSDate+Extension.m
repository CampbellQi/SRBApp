//
//  NSDate+Extension.m
//  SRBApp
//
//  Created by zxk on 15/5/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear
{
    //日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //获得某个时间的年月日时分秒
    NSDateComponents * dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents * nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate * now = [NSDate date];
    
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [fmt stringFromDate:self];
    NSString * nowStr = [fmt stringFromDate:now];
    
    //去掉时分秒
    NSDate * date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    //日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents * cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday
{
    NSDate * now = [NSDate date];
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [fmt stringFromDate:self];
    NSString * nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}
@end
