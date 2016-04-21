//
//  CropRectView.m
//  testImageEdit
//
//  Created by fengwanqi on 15/10/15.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "CropRectView.h"

@implementation CropRectView

-(void)drawRect:(CGRect)rect {
    float lineWidth = 1.0;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetAlpha(context, 0.4);
//    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    float height = self.frame.size.width * 3 / 4;
//    float y0 = self.center.y - height / 2;
//    float y1 = self.center.y + height / 2;
//    CGPoint points[5];
//    points[0] = CGPointMake(lineWidth, y0);
//    points[1] = CGPointMake(lineWidth, y1);
//    points[2] = CGPointMake(self.frame.size.width - lineWidth, points[1].y);
//    points[3] = CGPointMake(points[2].x, y0);
//    points[4] = points[0];
//    CGContextSetLineWidth(context, 2);
//    CGContextSetAllowsAntialiasing(context, NO);
//    CGContextAddLines(context, points, 5);
//    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
//    CGContextSetAlpha(context, 1);
//    CGContextDrawPath(context, kCGPathStroke);
    float height = self.frame.size.width * 3 / 4;
    float y = self.center.y - height / 2;
    
    self.cropRect =  CGRectMake(lineWidth/2, y, self.frame.size.width-lineWidth, height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充两边空白
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor);
    CGContextSetAlpha(context, 0.8);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - height)/2));
    CGContextFillRect(context, CGRectMake(0, self.frame.size.height - (self.frame.size.height - height)/2, self.frame.size.width, (self.frame.size.height - height)/2));
    CGContextSetLineWidth(context, lineWidth);
    
        //float height = self.frame.size.width * 3 / 4;
    
    //CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGContextSetRGBFillColor(<#CGContextRef  _Nullable c#>, <#CGFloat red#>, <#CGFloat green#>, <#CGFloat blue#>, <#CGFloat alpha#>)
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context,_cropRect);
    CGContextSetAlpha(context, 1);
    
    //绘制刻度
    //绘制X轴
    float x_space = (self.frame.size.width - 2 *lineWidth)/3;
    //float x_n = (self.frame.size.width - 2 *lineWidth) / x_space;
    for (int i=1; i<3; i++) {
        CGPoint points[2];
        points[0] = CGPointMake(i * x_space, y);
        points[1] = CGPointMake(points[0].x, points[0].y + height);
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetAllowsAntialiasing(context, NO);
        CGContextAddLines(context, points, 2);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
    //绘制y轴
    float y_space = (height - 2 *lineWidth)/3;
    //float x_n = (self.frame.size.width - 2 *lineWidth) / x_space;
    for (int i=1; i<3; i++) {
        CGPoint points[2];
        points[0] = CGPointMake(lineWidth, y + i * y_space);
        points[1] = CGPointMake(self.frame.size.width - lineWidth, points[0].y);
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetAllowsAntialiasing(context, NO);
        CGContextAddLines(context, points, 2);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
