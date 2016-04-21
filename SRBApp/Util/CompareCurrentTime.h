//
//  CompareCurrentTime.h
//  SRBApp
//
//  Created by zxk on 15/1/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
/*! @brief 计算时间差,时区为系统默认时区
 
 *
 */
@interface CompareCurrentTime : ZZBaseObject
/**
 *  时间戳转成字符
 *  @param compareDate 时间戳
 */
+(NSString *) compareCurrentTime:(double) compareDate;
+ (NSString *)compareCurrentDate:(double)compareDate;
@end
