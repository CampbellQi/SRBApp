//
//  NameTextView.m
//  SRBApp
//
//  Created by zxk on 15/4/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NameTextView.h"
#define ZZTextViewCoverTag 999
@implementation NameTextView

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for (UIView * child in self.subviews) {
        if (child.tag == ZZTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
    
    CGPoint tempPoint = [[touches anyObject]locationInView:self];
    if (beginPoint.x - tempPoint.x <= 8.5 && beginPoint.x - tempPoint.x >= - 8.5 && beginPoint.y - tempPoint.y <= 8.5 && beginPoint.y - tempPoint.y >= - 8.5) {
        //触摸对象
        UITouch * touch = [touches anyObject];
        //触摸点
        CGPoint point = [touch locationInView:self];
        ZZSpecial * special = [self touchingSpecialWithPoint:point];
        self.clickHandler(self,special.text,special.nameNum);
    }
}

@end
