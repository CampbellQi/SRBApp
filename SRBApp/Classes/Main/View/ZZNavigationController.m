//
//  ZZNavigationController.m
//  SRBApp
//
//  Created by zxk on 14/12/15.
//  Copyright (c) 2014年 zxk. All rights reserved.
//  自定义Navigation

#import "ZZNavigationController.h"

@interface ZZNavigationController ()

@end

@implementation ZZNavigationController

+ (void)initialize
{
    //1.设置主题的对象
    UINavigationBar * navBar = [UINavigationBar appearance];
    UIBarButtonItem * barItem = [UIBarButtonItem appearance];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [navBar setFrame:frame];
    //2.设置导航栏的背景图片
    //[navBar setBackgroundColor:[UIColor colorWithHexString:@"#e5005d"]];
//    [navBar setBackgroundColor:[UIColor redColor]];
    navBar.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    navBar.layer.shadowOpacity = 0.8;
    navBar.layer.shadowOffset = CGSizeMake(4, 3);
    //3.设置导航栏标题颜色为白色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    //4.设置导航栏按钮文字颜色为白色
    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}forState:UIControlStateNormal];
    
    //设置导航栏的返回箭头颜色
    navBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
