//
//  ShaiXuanBtn.m
//  SRBApp
//
//  Created by zxk on 15/1/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShaiXuanBtn.h"

@implementation ShaiXuanBtn

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 75)/2, 5, 20, 20);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(25, 7, 50, 16);
}

@end
