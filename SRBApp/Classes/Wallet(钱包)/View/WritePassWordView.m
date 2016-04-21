//
//  WritePassWordView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WritePassWordView.h"

@implementation WritePassWordView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        
        UIColor *lineColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
        float baseHeight = 40;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, baseHeight)];
        label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        label.text = @"请输入支付密码";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        
        _a = (SCREEN_WIDTH-40) / 6;
        _theView = [[UIView alloc]initWithFrame:CGRectMake(20, label.frame.size.height + label.frame.origin.y + 20, (SCREEN_WIDTH-40), _a)];
        _theView.backgroundColor = [UIColor clearColor];
        [self addSubview:_theView];
        _theView.layer.borderColor = lineColor.CGColor;
        _theView.layer.borderWidth = 1.0f;
        _theView.layer.cornerRadius = 4.0f;
        
//        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_theView.frame.origin.x, 0, _theView.frame.size.width, 1)];
//        line1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [_theView addSubview:line1];
//        
//        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_theView.frame.origin.x, _theView.frame.size.height - 1, _theView.frame.size.width, 1)];
//        line2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [_theView addSubview:line2];
//        
//        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(_theView.frame.origin.x, 0,1 , _a)];
//        line3.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [_theView addSubview:line3];
//        
//        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(_theView.frame.size.width, 0,1 , _a)];
//        line4.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [_theView addSubview:line4];
        
        for (int i = 0; i < 5; i++) {
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * _a, 0, 1, _a)];
            view1.backgroundColor = lineColor;
            [_theView addSubview:view1];
        }
    
        float width = 60;
        _noButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, baseHeight)];
        [_noButton setTitle:@"取 消" forState:UIControlStateNormal];
        _noButton.font = [UIFont systemFontOfSize:14];
        [_noButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [self addSubview:_noButton];
        
        _yesButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-width, 0, width, baseHeight)];
        [_yesButton setTitle:@"确 定" forState:UIControlStateNormal];
        _yesButton.font = [UIFont systemFontOfSize:14];
        [_yesButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [self addSubview:_yesButton];
        
//        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_yesButton.frame), self.width, 1)];
//        lineView.backgroundColor = lineColor;
//        [self addSubview:lineView];
        
        UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_yesButton.frame), self.width, 1)];
        lineIV.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
        [self addSubview:lineIV];
        
//        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(_noButton.frame.size.width, _noButton.frame.origin.y, 1, 40)];
//        lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        //[self addSubview:lineView2];
    }
    return self;
}

@end
