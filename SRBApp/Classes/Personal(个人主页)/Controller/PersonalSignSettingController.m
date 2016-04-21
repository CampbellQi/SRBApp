//
//  PersonalSignSettingController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//
#define MAXWORDSCOUNT 16
#import "PersonalSignSettingController.h"
#import "CommonView.h"
#import "StringHelper.h"
#import "AppDelegate.h"

@interface PersonalSignSettingController ()<UITextViewDelegate, UIAlertViewDelegate>

@end

@implementation PersonalSignSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"签名";

    self.signTV.text = self.soureUserInfoDict[@"sign"];
    if (self.signTV.text) {
        self.wordsCountLbl.text = [NSString stringWithFormat:@"%ld/%d", self.signTV.text.length,MAXWORDSCOUNT];
    }else{
        self.wordsCountLbl.text = [NSString stringWithFormat:@"%d/%d", 0,MAXWORDSCOUNT];
    }

    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"保 存" Target:self Action:@selector(changeBtnClicked)];
}
//-(void)backBtnClicked {
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark- 事件
-(void)backBtnClicked{
    NSString *content = [self.signTV.text trim];
    if (content.length != 0) {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1234;
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)changeBtnClicked {
    if ([self.signTV.text trim].length > MAXWORDSCOUNT) {
        [AutoDismissAlert autoDismissAlertSecond:@"字数超过限制了哦"];
        return;
    }
    [self changeNicknameRequest];
}
#pragma mark- textview delegate

-(void)textViewDidChange:(UITextView *)textView {
    
        NSString  * nsTextContent=textView.text;
        if (nsTextContent.length > MAXWORDSCOUNT) {
            if (textView.text.length >= MAXWORDSCOUNT) {
                //NSLog(@"%d", textView.text.length);
                //textView.text = [textView.text substringToIndex:_maxWordsCount];
            }
            
        }
        self.wordsCountLbl.text = [NSString stringWithFormat:@"%ld/%d", textView.text.length,MAXWORDSCOUNT];
    
}
#pragma mark- 网络请求
- (void)changeNicknameRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    NSString *newSign = [[_signTV text] trim];
//    if (newSign.length > 48) {
//        [AutoDismissAlert autoDismissAlert:@"签名过长,请控制在48字以内"];
//        return;
//    }

    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":_soureUserInfoDict[@"sex"], @"nickname":_soureUserInfoDict[@"nickname"], @"sign": newSign, @"birthday": _soureUserInfoDict[@"birthday"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [hud removeFromSuperview];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
            [[NSUserDefaults standardUserDefaults] setObject:newSign forKey:@"sign"];
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
