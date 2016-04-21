//
//  UIColor+Dice.h
//  qiangbao
//
//  Created by fengwanqi on 14-5-6.
//  Copyright (c) 2014年 huashangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Dice)
+(UIColor *)diceColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)colorFromString:(NSString *)string;
+ (UIColor *)randomColor;

@end
