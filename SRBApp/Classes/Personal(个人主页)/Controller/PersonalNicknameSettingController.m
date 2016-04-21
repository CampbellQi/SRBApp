//
//  PersonalNicknameSettingController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PersonalNicknameSettingController.h"
#import "CommonView.h"
#import "StringHelper.h"
#import "AppDelegate.h"

@interface PersonalNicknameSettingController ()

@end

@implementation PersonalNicknameSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改昵称";
    
    self.nicknameTF.text = self.soureUserInfoDict[@"nickname"];
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"修 改" Target:self Action:@selector(changeBtnClicked)];
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changeBtnClicked {
    [self changeNicknameRequest];
}
#pragma mark- 网络请求
- (void)changeNicknameRequest
{
    NSString *newNickname = [[_nicknameTF text] trim];
    if (newNickname.length > 12) {
        [AutoDismissAlert autoDismissAlert:@"昵称过长,请控制字数"];
        return;
    }
    
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":_soureUserInfoDict[@"sex"], @"nickname":newNickname, @"sign": _soureUserInfoDict[@"sign"], @"birthday": _soureUserInfoDict[@"birthday"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [hud removeFromSuperview];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
            [[NSUserDefaults standardUserDefaults] setObject:newNickname forKey:@"nickname"];
        }else{
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }andFailureBlock:^{
        [hud removeFromSuperview];
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
