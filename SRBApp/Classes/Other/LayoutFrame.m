//
//  LayoutFrame.m
//  tusstar
//
//  Created by fengwanqi on 15/7/8.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "LayoutFrame.h"

@implementation LayoutFrame
#pragma mark- 调整autolayout 下的frame
+(void)showViewConstraint:(UIView*)view AttributeHeight:(CGFloat)height{
    for (NSLayoutConstraint* constraint in view.constraints ) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            constraint.constant = height;
        }
    }
    [view.superview layoutIfNeeded];
}
+(void)showViewConstraint:(UIView*)view AttributeWidth:(CGFloat)width{
    for (NSLayoutConstraint* constraint in view.constraints ) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeWidth) {
            constraint.constant = width;
        }
    }
    [view.superview layoutIfNeeded];
}
+(void)showViewConstraint:(UIView*)view AttributeTop:(CGFloat)attributeTop{
    for (NSLayoutConstraint* constraint in view.superview.constraints ) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = attributeTop;
        }
    }
    [view.superview layoutIfNeeded];
}
+(void)showViewConstraint:(UIView*)view AttributeBottom:(CGFloat)attributeBotton{
    for (NSLayoutConstraint* constraint in view.superview.constraints ) {
        if (constraint.secondItem == view && constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = attributeBotton;
        }
    }
    [view.superview layoutIfNeeded];
}
+(void)showViewConstraint:(UIView*)view AttributeLeading:(CGFloat)attributeLeading{
    for (NSLayoutConstraint* constraint in view.superview.constraints ) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeLeading) {
            constraint.constant = attributeLeading;
        }
    }
    [view.superview layoutIfNeeded];
}
+(void)showViewConstraint:(UIView*)view AttributeTrailing:(CGFloat)attributeTrailing{
    for (NSLayoutConstraint* constraint in view.superview.constraints ) {
        if (constraint.secondItem == view && constraint.firstAttribute == NSLayoutAttributeTrailing) {
            constraint.constant = attributeTrailing;
        }
    }
    [view.superview layoutIfNeeded];
}
@end
