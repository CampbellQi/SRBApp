//
//  HadAliPayViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "HadAliPayViewController.h"
#import "MyAliPayViewController.h"

@interface HadAliPayViewController ()

@end

@implementation HadAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的支付宝";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 32, 25, 25)];
    image.image = [UIImage imageNamed:@"qb_zfb.png"];
    [self.view addSubview:image];
    
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 5, image.frame.origin.y + 6, 200, 14)];
    label.text = @"当前绑定的支付宝账号是";
    label.font = SIZE_FOR_14;
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:label];
    
    UILabel * bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x, label.frame.origin.y + label.frame.size.height + 32, 250, 20)];
    bigLabel.font = [UIFont systemFontOfSize:18];
    bigLabel.text = self.aliPayAccount;
    bigLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:bigLabel];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(bigLabel.frame.origin.x, bigLabel.frame.origin.y + bigLabel.frame.size.height + 60, SCREEN_WIDTH - 50, 40)];
    [button setTitle:@"修 改" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)action:(id)sender
{
    MyAliPayViewController * vc = [[MyAliPayViewController alloc]init];
    vc.aliPayAccount = self.aliPayAccount;
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
