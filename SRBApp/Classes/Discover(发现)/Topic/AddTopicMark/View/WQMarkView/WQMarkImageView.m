//
//  WQImageView.m
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "WQMarkImageView.h"

@implementation WQMarkImageView
{
    CGPoint _beginLocation;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _beginLocation = [touch locationInView:self];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tapBlock) {
        float space = 5.0;
        UITouch *touch = [touches anyObject];
        CGPoint endLocation = [touch locationInView:self];
        if (fabs(endLocation.x - _beginLocation.x) < space && fabs(endLocation.y - _beginLocation.y) < space) {
            self.tapBlock([touch locationInView:self]);
        }
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
