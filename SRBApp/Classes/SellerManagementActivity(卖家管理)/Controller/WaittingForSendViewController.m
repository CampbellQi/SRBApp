//
//  WaittingForSendViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WaittingForSendViewController.h"

@interface WaittingForSendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sendCompanyText;
@property (weak, nonatomic) IBOutlet UITextField *sendNumText;

@end

@implementation WaittingForSendViewController
    - (void)backBtn:(UIButton *)sender
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 2;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(0, 0, 60, 25);
    [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
}

- (void)submitBtn:(UIButton *)sender
{
    //获取用户名和密码
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderTake" parameters:@{@"account":name,@"password":pass,@"orderId":self.orderId,@"invoiceName":self.sendCompanyText.text,@"invoiceNo":self.sendNumText.text}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
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
