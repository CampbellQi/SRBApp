//
//  LoginViewController2.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "LoginViewController2.h"

@interface LoginViewController2 ()

@end

@implementation LoginViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginBtn.layer.cornerRadius = 4.0f;
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

- (IBAction)forgetBtnClicked:(id)sender {
}
- (IBAction)loginBtnClicked:(id)sender {
}

- (IBAction)weixinLoginClicked:(id)sender {
}

- (IBAction)weiboLoginClicked:(id)sender {
}
@end
