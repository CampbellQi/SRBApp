//
//  CustomBtn.m
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(15.0/2, 0, 25, 25);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 38)/2, 35, 38, 12);
}

@end
