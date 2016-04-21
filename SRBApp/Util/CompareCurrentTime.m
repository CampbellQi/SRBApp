//
//  CompareCurrentTime.m
//  SRBApp
//
//  Created by zxk on 15/1/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CompareCurrentTime.h"

@implementation CompareCurrentTime
+ (NSString *)compareCurrentTime:(double)compareDate
{
    if (compareDate == 0) {
        return @"";
    }
    NSString * intStr = [NSString stringWithFormat:@"%.0f",compareDate];
    //服务器返回结果需要截取后三位
    intStr = [intStr substringToIndex:intStr.length - 3];

    NSDate * createDate = [NSDate dateWithTimeIntervalSince1970:[intStr doubleValue]];
//    //设置时区
//    NSTimeZone * zones = [NSTimeZone systemTimeZone];
//    NSInteger intervals = [zones secondsFromGMTForDate:fromDates];
//    NSDate * createDate = [fromDates dateByAddingTimeInterval:intervals];
    
    //获取当前时间
    NSDate * nowDate = [NSDate date];
//    NSInteger interval = [zones secondsFromGMTForDate:nowDate];
//    NSDate * localeDate = [nowDate dateByAddingTimeInterval:interval];
    
    //日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期差值
    NSDateComponents * cmps = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    
    if ([createDate isThisYear]) {//今年
        if ([createDate isYesterday]) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){//今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",cmps.hour];
            }else if (cmps.minute >= 1){
                return [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
            }else{
                return @"刚刚";
            }
        }else{//今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//其他年份
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    return intStr;
}
+ (NSString *)compareCurrentDate:(double)compareDate
{
    if (compareDate == 0) {
        return @"";
    }
    NSString * intStr = [NSString stringWithFormat:@"%.0f",compareDate];
    //服务器返回结果需要截取后三位
    intStr = [intStr substringToIndex:intStr.length - 3];
    
    NSDate * createDate = [NSDate dateWithTimeIntervalSince1970:[intStr doubleValue]];
    //    //设置时区
    //    NSTimeZone * zones = [NSTimeZone systemTimeZone];
    //    NSInteger intervals = [zones secondsFromGMTForDate:fromDates];
    //    NSDate * createDate = [fromDates dateByAddingTimeInterval:intervals];
    
    //获取当前时间
    NSDate * nowDate = [NSDate date];
    //    NSInteger interval = [zones secondsFromGMTForDate:nowDate];
    //    NSDate * localeDate = [nowDate dateByAddingTimeInterval:interval];
    
    //日历对象
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期差值
    NSDateComponents * cmps = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    
    if ([createDate isThisYear]) {//今年
        if ([createDate isYesterday]) {//昨天
            fmt.dateFormat = @"昨天";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){//今天
            return @"今天";
        }else{//今年的其他日子
            fmt.dateFormat = @"MM-dd";
            return [fmt stringFromDate:createDate];
        }
    }else{//其他年份
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }
    return intStr;
}


@end
