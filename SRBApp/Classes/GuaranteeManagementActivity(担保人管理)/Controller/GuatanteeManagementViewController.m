//
//  GuatanteeManagementViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuatanteeManagementViewController.h"
#import "AppDelegate.h"
#import "MyAssureViewController.h"
#import "GuaranteeCommentViewController.h"
#import "OrderAssureViewController.h"

@interface GuatanteeManagementViewController ()

@end

@implementation GuatanteeManagementViewController
{
    BOOL isBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我是担保人";
    isBack = NO;
    [self giveDataToControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

#pragma mark - 控件赋值
- (void)giveDataToControl{
    

    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH, 50);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    [publishBtn addTarget:self action:@selector(publishTap:) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    

    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(0, 71, SCREEN_WIDTH, 50);
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    orderBtn.tag = 1006;
    [orderBtn addTarget:self action:@selector(btnClickTap:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    
    UIButton * yaoqingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yaoqingBtn.frame = CGRectMake(0, 122, SCREEN_WIDTH, 50);
    [yaoqingBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    yaoqingBtn.tag = 1007;
    [yaoqingBtn addTarget:self action:@selector(yaoqingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [yaoqingBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    
    [self.view addSubview:publishBtn];
    [self.view addSubview:orderBtn];
    [self.view addSubview:yaoqingBtn];
    
    UIImageView * publishImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    publishImg.image = [UIImage imageNamed:@"wodedanbao"];
    [publishBtn addSubview:publishImg];
    UILabel * publishLabel = [[UILabel alloc]initWithFrame:CGRectMake(publishImg.frame.size.width + publishImg.frame.origin.x+25, 17, 100, 16)];
    publishLabel.text = @"我的担保";
    publishLabel.font = [UIFont systemFontOfSize:15];
    [publishBtn addSubview:publishLabel];
    UIImageView * detailPublishImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailPublishImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [publishBtn addSubview:detailPublishImg];
    
    
    UIImageView * orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    orderImg.image = [UIImage imageNamed:@"wodepingjia"];
    [orderBtn addSubview:orderImg];
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderImg.frame.size.width + orderImg.frame.origin.x+25, 17, 100, 16)];
    orderLabel.text = @"评价管理";
    orderLabel.font = [UIFont systemFontOfSize:15];
    [orderBtn addSubview:orderLabel];
    UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [orderBtn addSubview:detailImg];
    
    UIImageView * yaoqingImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    yaoqingImg.image = [UIImage imageNamed:@"yaoqing_shuren"];
    [yaoqingBtn addSubview:yaoqingImg];
    UILabel * yaoqingLabel = [[UILabel alloc]initWithFrame:CGRectMake(yaoqingImg.frame.size.width + yaoqingImg.frame.origin.x+25, 17, 130, 16)];
    yaoqingLabel.text = @"抢单挣钱";
    yaoqingLabel.font = [UIFont systemFontOfSize:15];
    [yaoqingBtn addSubview:yaoqingLabel];
    UIImageView * detailYaoqingImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailYaoqingImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [yaoqingBtn addSubview:detailYaoqingImg];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)yaoqingBtn:(UIButton *)btn
{
    OrderAssureViewController * myAssureOrdersTVC = [[OrderAssureViewController alloc]init];
    [self.navigationController pushViewController:myAssureOrdersTVC animated:YES];
}

- (void)publishTap:(UIButton *)clickTap
{
    MyAssureViewController * vc = [[MyAssureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClickTap:(UIButton *)clickTap
{
    GuaranteeCommentViewController * vc = [[GuaranteeCommentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
