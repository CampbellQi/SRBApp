//
//  ZZLeftVCCustomView.m
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZLeftVCCustomView.h"

@implementation ZZLeftVCCustomView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - 12.5)/2, (frame.size.height - 25)/2, 12.5, 12.5)];
        imgview.backgroundColor = [UIColor orangeColor];
        self.imgview = imgview;
        [self addSubview:imgview];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 60)/2, (frame.size.height - 25)/2, 60, 12)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLabel];
        
        self.backgroundColor = [UIColor clearColor];
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
