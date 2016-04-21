//
//  ZZOrderCustomBtn.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZOrderCustomBtn.h"
#import "KeychainItemWrapper.h"

@implementation ZZOrderCustomBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
        [self setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 20)/2, 6, 20, 20);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 38)/2, 31, 38, 12);
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
