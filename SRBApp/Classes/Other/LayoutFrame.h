//
//  LayoutFrame.h
//  tusstar
//
//  Created by fengwanqi on 15/7/8.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutFrame : NSObject
#pragma mark- 调整autolayout 下的frame
+(void)showViewConstraint:(UIView*)view AttributeHeight:(CGFloat)height;
+(void)showViewConstraint:(UIView*)view AttributeWidth:(CGFloat)width;
+(void)showViewConstraint:(UIView*)view AttributeTop:(CGFloat)attributeTop;
+(void)showViewConstraint:(UIView*)view AttributeBottom:(CGFloat)attributeBotton;
+(void)showViewConstraint:(UIView*)view AttributeLeading:(CGFloat)attributeLeading;
+(void)showViewConstraint:(UIView*)view AttributeTrailing:(CGFloat)attributeTrailing;
@end
