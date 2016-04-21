//
//  CreateGetMoneyViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CreateGetMoneyViewController.h"
#import "FirstCreatViewController.h"

@interface CreateGetMoneyViewController ()

@end

@implementation CreateGetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付密码";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 90, 75, 60 , 100 )];
    image1.image = [UIImage imageNamed:@"xiaoren"];
    [self.view addSubview:image1];
    
    UIImageView * image2 = [[UIImageView alloc]init];
//    image2.image = [UIImage imageNamed:@""];
    image2.frame = CGRectMake(image1.frame.size.width + image1.frame.origin.x + 10, image1.frame.origin.y + 10,130 ,50);
    UIEdgeInsets insets = UIEdgeInsetsMake(2.0f, 2.0f, 33, 33);
    UIImage * image = [[UIImage imageNamed:@"empty_notice_talk.png"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [image2 setImage:image];
    [self.view addSubview:image2];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"支付密码可以在您提现或者用虚拟币进行交易时使用,安全方便!";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
    label.frame = CGRectMake(image1.frame.size.width + image1.frame.origin.x + 25, image1.frame.origin.y + 10,110 ,50);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    UIButton * button  = [[UIButton alloc]initWithFrame:CGRectMake(image1.center.x, image1.frame.origin.y + image1.frame.size.height + 45, 130 ,65 /2)];
    [button setBackgroundImage:[UIImage imageNamed:@"publish_btn_pink_nor"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"publish_btn_pink_pre"] forState:UIControlStateHighlighted];
    [button setTitle:@"创建支付密码" forState:UIControlStateNormal];
    button.titleLabel.font = SIZE_FOR_IPHONE;
    [button addTarget:self action:@selector(create:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)create:(id)sender
{
    FirstCreatViewController * vc = [[FirstCreatViewController alloc]init];
    vc.point = _point;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
