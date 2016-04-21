//
//  zanAndShareView.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "zanAndShareView.h"


@implementation zanAndShareView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        LeftImgAndRightTitleBtn * leftBtn = [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"赞" forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 0, 73.5, frame.size.height);
        self.leftBtn = leftBtn;
        [self addSubview:leftBtn];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(74.5, 0, 1, frame.size.height)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#94888"];
        [self addSubview:lineView];
        
        LeftImgAndRightTitleBtn * rightBtn = [LeftImgAndRightTitleBtn buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        rightBtn.frame = CGRectMake(76.5, 0, 74.5,frame.size.height);
        self.rightBtn = rightBtn;
        [self addSubview:rightBtn];
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
