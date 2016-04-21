//
//  SubOfClassSuggestionViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubOfClassSuggestionViewController.h"
#import "AppDelegate.h"
@interface SubOfClassSuggestionViewController ()

@end

@implementation SubOfClassSuggestionViewController
{
    BOOL isBack;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)regController:(id)sender
{
    if (_textView.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写反馈内容"];
        [_textView becomeFirstResponder];
        return;
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"addInfoBack" parameters:@{ACCOUNT_PASSWORD, @"title": @"llaal", @"msg": _textView.text, @"qqNo": @"", @"telNo":_textField.text, @"email":@""}];
    //发送post请求
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            isBack = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
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
