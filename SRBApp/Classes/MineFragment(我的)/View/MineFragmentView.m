//
//  MineFragmentView.m
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MineFragmentView.h"

@implementation MineFragmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        self.leftView = leftView;
        leftView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [self addSubview:leftView];
        
        UIImageView * lLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 25, 25)];
        self.lLogoImg = lLogoImg;
        [leftView addSubview:lLogoImg];
        
        UILabel * lTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(lLogoImg.frame.size.width + lLogoImg.frame.origin.x + 25, 25, frame.size.width/2 - 50 - 25, 15)];
        lTitleLabel.font = [UIFont systemFontOfSize:15];
        lTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.lTitleLabel = lTitleLabel;
        [leftView addSubview:lTitleLabel];
        
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)];
        self.rightView = rightView;
        rightView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [self addSubview:rightView];
        
        UIImageView * rLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 25, 25)];
        self.rLogoImg = rLogoImg;
        [rightView addSubview:rLogoImg];
        
        UILabel * rTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(rLogoImg.frame.size.width + rLogoImg.frame.origin.x + 25,25,frame.size.width /2 - 50 -25,15)];
        rTitleLabel.font = [UIFont systemFontOfSize:15];
        rTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.rTitleLabel = rTitleLabel;
        [rightView addSubview:rTitleLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, 1, frame.size.height)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:lineView];
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
