//
//  CommonView.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "CommonView.h"

@implementation CommonView

+(UIBarButtonItem *)backBarButtonItemTarget:(id)target Action:(SEL)action{
    //导航返回
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
+(UIBarButtonItem *)rightWithBgBarButtonItemTitle:(NSString *)title Target:(id)target Action:(SEL)action {
    //导航发送
    UIColor *pColor = [UIColor colorWithRed:227.0/255 green:95.0/255 blue:147.0/255 alpha:1];
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //publishBtn.layer.cornerRadius = 4.0f;
    [publishBtn setBackgroundColor:[UIColor whiteColor]];
    publishBtn.frame = CGRectMake(15, 0, 55, 25);
    publishBtn.layer.cornerRadius = CGRectGetHeight(publishBtn.frame) * 0.5;
    publishBtn.layer.masksToBounds = YES;
    [publishBtn setTitle:title forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [publishBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:pColor forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
}
+(UIBarButtonItem *)rightBarButtonItemTitle:(NSString *)title Target:(id)target Action:(SEL)action {
    //导航发送
    UIColor *pColor = [UIColor whiteColor];
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //publishBtn.layer.cornerRadius = 4.0f;
    publishBtn.layer.cornerRadius = CGRectGetHeight(publishBtn.frame) * 0.5;
    publishBtn.layer.masksToBounds = YES;
    publishBtn.frame = CGRectMake(15, 0, 60, 20);
    [publishBtn setTitle:title forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [publishBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:pColor forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
