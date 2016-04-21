//
//  SubMyChatListViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubMyChatListViewController.h"

@interface SubMyChatListViewController ()

@end

@implementation SubMyChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义导航标题颜色
    [self setNavigationTitle:@"最近联系人" textColor:[UIColor whiteColor]];
    
    //自定义导航左右按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt2"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    //自定义导航右按钮
    UIButton *customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customRightBtn.frame = CGRectMake(0, 0, 31, 31);
    [customRightBtn setImage:[UIImage imageNamed:@"rc_add_people"] forState:UIControlStateNormal];
    [customRightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}
- (void)leftBarButtonItemPressed:(UIBarButtonItem *)sender
{
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
