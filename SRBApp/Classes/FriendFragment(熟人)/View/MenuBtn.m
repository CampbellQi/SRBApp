//
//  MenuBtn.m
//  SRBApp
//
//  Created by zxk on 15/1/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MenuBtn.h"

@implementation MenuBtn

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(12, 5, 20, 20);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(41, 8, 70, 14);
}

@end
