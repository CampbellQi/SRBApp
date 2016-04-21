//
//  CircleView.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 50)/2, (frame.size.height - 32)/2, 50, 16)];
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 50)/2, _titleLabel.frame.size.height + _titleLabel.frame.origin.y, 50, 16)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.font = SIZE_FOR_IPHONE;
        _numLabel.font = SIZE_FOR_IPHONE;
        _numLabel.text = @"0";
        
        _numLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        _titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        
        [self addSubview:_titleLabel];
        [self addSubview:_numLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.titleLabel.text isEqualToString:@"待付款"]) {
        [self setBackgroundColor:RGBCOLOR(78, 116, 24, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待发货"] || [self.titleLabel.text isEqualToString:@"去发货"]) {
        [self setBackgroundColor:RGBCOLOR(21, 100, 131, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待收货"] || [self.titleLabel.text isEqualToString:@"去收货"]) {
        [self setBackgroundColor:RGBCOLOR(114, 37, 156, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待退款"]) {
        [self setBackgroundColor:RGBCOLOR(166, 90, 8, 1)];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self.titleLabel.text isEqualToString:@"待付款"]) {
        [self setBackgroundColor:RGBCOLOR(135, 194, 27, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待发货"] || [self.titleLabel.text isEqualToString:@"去发货"]) {
        [self setBackgroundColor:RGBCOLOR(44, 159, 221, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待收货"] || [self.titleLabel.text isEqualToString:@"去收货"]) {
        [self setBackgroundColor:RGBCOLOR(193, 75, 243, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待退款"]) {
        [self setBackgroundColor:RGBCOLOR(239, 144, 7, 1)];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if ([self.titleLabel.text isEqualToString:@"待付款"]) {
        [self setBackgroundColor:RGBCOLOR(135, 194, 27, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待发货"] || [self.titleLabel.text isEqualToString:@"去发货"]) {
        [self setBackgroundColor:RGBCOLOR(44, 159, 221, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待收货"] || [self.titleLabel.text isEqualToString:@"去收货"]) {
        [self setBackgroundColor:RGBCOLOR(193, 75, 243, 1)];
    }
    if ([self.titleLabel.text isEqualToString:@"待退款"]) {
        [self setBackgroundColor:RGBCOLOR(239, 144, 7, 1)];
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
