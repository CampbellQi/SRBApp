//
//  CustomTabBarBtn.m
//  SRBApp
//
//  Created by lizhen on 15/1/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CustomTabBarBtn.h"

@implementation CustomTabBarBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
        [self setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 30)/2, 6, 25, 25);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 24)/2, 34, 30, 12);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
