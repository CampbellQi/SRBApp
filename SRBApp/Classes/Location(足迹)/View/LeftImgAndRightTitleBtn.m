//
//  LeftImgAndRightTitleBtn.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "LeftImgAndRightTitleBtn.h"

@implementation LeftImgAndRightTitleBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(7.5 + 7, 7.5, 15, 15);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(32.5 + 3, 9, 25, 12);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
