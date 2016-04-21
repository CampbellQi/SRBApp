//
//  YanZhengMaView.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "YanZhengMaView.h"

@implementation YanZhengMaView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        UILabel * labelOne = [[UILabel alloc]init];
        labelOne.textAlignment = NSTextAlignmentCenter;
        labelOne.backgroundColor = [UIColor clearColor];
        self.labelOne = labelOne;
        [self addSubview:labelOne];
        
        UILabel * labelTwo = [[UILabel alloc]init];
        self.labelTwo = labelTwo;
        labelTwo.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTwo];
        labelTwo.textAlignment = NSTextAlignmentCenter;
        
        UILabel * labelThree = [[UILabel alloc]init];
        self.labelThree = labelThree;
        labelThree.backgroundColor = [UIColor clearColor];
        [self addSubview:labelThree];
        labelThree.textAlignment = NSTextAlignmentCenter;
        
        UILabel * labelFour = [[UILabel alloc]init];
        self.labelFour = labelFour;
        labelFour.backgroundColor = [UIColor clearColor];
        [self addSubview:labelFour];
        labelFour.textAlignment = NSTextAlignmentCenter;
        
        [self makeYanzhengma];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 0.314, 0.486, 0.859, 1.0);
    CGContextBeginPath(context);
    float x = arc4random() % 71;
    float y = arc4random() % 31;
    
    float x1 = arc4random() % 71;
    float y1 = arc4random() % 31;
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x1, y1);
    CGContextStrokePath(context);
    
    
    float x2 = arc4random() % 71;
    float y2 = arc4random() % 31;
    
    float x3 = arc4random() % 71;
    float y3 = arc4random() % 31;
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context1, kCGLineCapSquare);
    CGContextSetLineWidth(context1, 2.0);
    CGContextSetRGBStrokeColor(context1, 0.314, 0.486, 0.859, 1.0);
    CGContextBeginPath(context1);
    CGContextMoveToPoint(context1, x2, y2);
    CGContextAddLineToPoint(context1, x3, y3);
    CGContextStrokePath(context1);
}

- (void)makeYanzhengma
{
    
    float one = arc4random() % 15;
    float two = arc4random() % (35 - 17 + 1) + 17;
    float three = arc4random() % (49 - 35 + 1) + 35;
    float four = arc4random() % (62 - 52 + 1) + 52;
    
    float oney = arc4random() % 15;
    float twoy = arc4random() % 15;
    float threey = arc4random() % 15;
    float foury = arc4random() % 15;
    
    float colorR = arc4random() % 256;
    float colorG = arc4random() % 256;
    float colorB = arc4random() % 256;
    
    self.labelOne.frame = CGRectMake(one, oney, 8.5, 16);
    self.labelTwo.frame = CGRectMake(two, twoy, 8.5, 16);
    self.labelThree.frame = CGRectMake(three, threey, 8.5, 16);
    self.labelFour.frame = CGRectMake(four, foury, 8.5, 16);
    self.labelOne.textColor = RGBCOLOR(colorR, colorG, colorB, 1);
    self.labelTwo.textColor = RGBCOLOR(colorG, colorB, colorR, 1);
    self.labelThree.textColor = RGBCOLOR(colorB, colorR, colorG, 1);
    self.labelFour.textColor = RGBCOLOR(colorR, colorB, colorG, 1);
    
    int num1 = arc4random() % 10;
    int num2 = arc4random() % 10;
    int num3 = arc4random() % 10;
    int num4 = arc4random() % 10;
    
    self.labelOne.text = [NSString stringWithFormat:@"%d",num1];
    self.labelTwo.text = [NSString stringWithFormat:@"%d",num2];
    self.labelThree.text = [NSString stringWithFormat:@"%d",num3];
    self.labelFour.text = [NSString stringWithFormat:@"%d",num4];
    
    self.numStr= [NSString stringWithFormat:@"%@%@%@%@",self.labelOne.text,self.labelTwo.text,self.labelThree.text,self.labelFour.text];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
