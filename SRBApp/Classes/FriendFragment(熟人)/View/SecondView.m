//
//  SecondView.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SecondView.h"

@implementation SecondView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 20;
        self.logoImg = logoImg;
        [self addSubview:logoImg];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 15, 22.5, 80, 15)];
        self.titleLabel = label;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self addSubview:label];
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 4.5, 25, 4, 10)];
        self.detaileImg = img;
        img.image = [UIImage imageNamed:@"hy_guan"];
        [self addSubview:img];
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
