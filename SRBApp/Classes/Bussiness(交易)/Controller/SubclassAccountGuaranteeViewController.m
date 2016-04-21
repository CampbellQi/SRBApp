//
//  SubclassAccountGuaranteeViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubclassAccountGuaranteeViewController.h"
#import "AppDelegate.h"

@interface SubclassAccountGuaranteeViewController ()

@end

@implementation SubclassAccountGuaranteeViewController
{
    BOOL isBack;
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)regController:(id)sender
{
    if (detailTV.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写担保理由"];
        return;
    }
    //拼接post参数
    NSLog(@"%@, %@!!!!!!!!!!!!!",self.idNumber, detailTV.text);
    NSDictionary * dic = [self parametersForDic:@"accountGuaranteePost" parameters:@{ ACCOUNT_PASSWORD,
                                                                                      @"id":self.idNumber,
                                                                                      @"title": @"我来担保",
                                                                                      @"content": detailTV.text}
                          ];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            isBack = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        
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
