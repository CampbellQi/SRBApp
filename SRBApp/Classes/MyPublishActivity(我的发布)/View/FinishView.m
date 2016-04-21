//
//  FinishView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FinishView.h"

@implementation FinishView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1];
        
        _buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        [_buttonBack setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//        _buttonBack.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _buttonBack.titleLabel.font = [UIFont systemFontOfSize:25];
        [_buttonBack setTitle:@"<" forState:UIControlStateNormal];
        [self addSubview:_buttonBack];
        
        _buttonNext = [[UIButton alloc]initWithFrame:CGRectMake(_buttonBack.frame.origin.x + _buttonBack.frame.size.width + 10, 5, 20, 20)];
        [_buttonNext setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        _buttonNext.titleLabel.font = [UIFont systemFontOfSize:25];
        [_buttonNext setTitle:@">" forState:UIControlStateNormal];
        [self addSubview:_buttonNext];
        
        _buttonFinish = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 5, 40, 20)];
        [_buttonFinish setTitle:@"完 成" forState:UIControlStateNormal];
//        _buttonFinish.backgroundColor = [UIColor blueColor];
        _buttonFinish.titleLabel.font = [UIFont systemFontOfSize:16];
        [_buttonFinish setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
        [self addSubview:_buttonFinish];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
