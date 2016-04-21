//
//  QinMiZhiShuImg.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "QinMiZhiShuImg.h"

@implementation QinMiZhiShuImg
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 12, 12)];
        _imgTwo = [[UIImageView alloc]initWithFrame:CGRectMake(19, 0, 12, 12)];
        _imgThree = [[UIImageView alloc]initWithFrame:CGRectMake(38, 0, 12, 12)];
        _imgFour = [[UIImageView alloc]initWithFrame:CGRectMake(57, 0, 12, 12)];
        _imgFive = [[UIImageView alloc]initWithFrame:CGRectMake(76, 0, 12, 12)];
        [self addSubview:_imgOne];
        [self addSubview:_imgTwo];
        [self addSubview:_imgThree];
        [self addSubview:_imgFour];
        [self addSubview:_imgFive];
        
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
