//
//  SubLoginViewController.m
//  SRBApp
//
//  Created by lizhen on 15/3/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubLoginViewController.h"

@interface SubLoginViewController ()

@end

@implementation SubLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
}

- (void)backBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 登录
- (void)userLogin
{
    AppDelegate * appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //判断输入是否合法
    if (nameText.text.length == 0 || self.passText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"账号或密码不能为空"];
        return;
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post请求所需参数
    NSDictionary * loginParam = @{@"method":@"accountLogin",@"parameters":@{@"account":[NSString stringWithFormat:@"%@",nameText.text],@"password":[NSString stringWithFormat:@"%@",self.passText.text],@"deviceID":@"123456",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME]}};
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        [HUD hide:YES];
        [HUD removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
            if (dataDic == nil) {
                dataDic = [NSMutableDictionary dictionary];
            }
            [dataDic setObject:@"1" forKey:@"isLogin"];
            [dataDic setObject:@"1" forKey:@"welcome"];
            
            NSDate *  senddate=[NSDate date];
            NSCalendar  * cal=[NSCalendar  currentCalendar];
            NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
            NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
            NSString * year = [NSString stringWithFormat:@"%ld",(long)[conponent year]];
            NSString * month = [NSString stringWithFormat:@"%ld",(long)[conponent month]];
            NSString * day = [NSString stringWithFormat:@"%ld",(long)[conponent day]];
            
            [dataDic setObject:year forKey:@"year"];
            [dataDic setObject:month forKey:@"month"];
            [dataDic setObject:day forKey:@"day"];
            
            //将登录状态写入配置文件
            [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:nameText.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:self.passText.text forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
            //设置别名
            [APService setAlias:nameText.text callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
            
            NSDictionary * tempDic = [dic objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"rongCloud"] forKey:@"rongCloud"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
            
            //获取本人token
            NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
            NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
            // 连接融云服务器。
            [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
                // 此处处理连接成功。
                
            } error:^(RCConnectErrorCode status) {
                // 此处处理连接错误。
                
            }];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
            appDele.mainTab.tabBar.hidden = YES;
            appDele.customTab.hidden = NO;
            //            [appDele creatBtns];
            [appDele.mainTab setSelectedIndex:0];
            appDele.tabBarBtn1.selected = YES;
            appDele.tabBarBtn5.selected = NO;
            [self dismissViewControllerAnimated:YES completion:nil];
            appDele.window.rootViewController = appDele.mainTab;
            [appDele getFriendArr];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        [HUD hide:YES];
        [HUD removeFromSuperview];
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
