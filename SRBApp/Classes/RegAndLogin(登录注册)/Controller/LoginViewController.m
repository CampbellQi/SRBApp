//
//  LoginViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "ZZNavigationController.h"
#import "ForgetPassViewController.h"
#import "KeychainItemWrapper.h"
#import <ShareSDK/ShareSDK.h>
#import "BussinessViewController.h"
#import "AMBlurView.h"
#import "BuyViewController.h"
#import "SaleViewController.h"
#import "RunViewController.h"
#import "ShoppingViewController.h"
#import "WantAssureViewController.h"
#import "ShoppingViewController.h"
#import "CommonView.h"
#import "RegMarksCollectionController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{

}


@property (nonatomic, strong) AMBlurView * blurView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //开始定位
    [self.locMgr startUpdatingLocation];
    self.mobileTF.delegate = self;
    self.pwdTF.delegate = self;
    //手机号填充
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    NSString * tempName = [dataDic objectForKey:@"account"];
    if (tempName != nil) {
        self.mobileTF.text = [dataDic objectForKey:@"account"];
    }
    if (self.mobileTF.text.length) {
        self.mobileIV.image = [UIImage imageNamed:@"login_mobile_pre"];
    }
    self.title = @"登 录";
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"注 册" Target:self Action:@selector(regController:)];
    self.loginBtn.layer.cornerRadius = 4.0f;
    
    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];
}
//- (void)viewWillAppear:(BOOL)animated {
//    
//    self.tabBarController.tabBar.hidden=YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    self.tabBarController.tabBar.hidden=NO;
//}
- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}


- (CLLocationManager *)locMgr
{
    // 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            [self.locMgr requestAlwaysAuthorization];
        }
    }
    return _locMgr;
    
    
}
#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"didUpdateLocations------%f %f", coordinate.latitude, coordinate.longitude);
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                         
                         NSString *latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         NSString *longitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         NSString *city = [dict objectForKey:@"State"];
                         NSString *SubLocality = [dict objectForKey:@"SubLocality"];
                         NSString *Street = [dict objectForKey:@"Street"];
                         if (Street == nil) {
                             Street = @"";
                         }
                         NSString *address = [city stringByAppendingString:SubLocality];
                         NSString *detailAddress = [address stringByAppendingString:Street];
                         
                         NSDictionary *localDic = [NSDictionary dictionaryWithObjectsAndKeys:latitude,@"latitude",longitude,@"longitude",city,@"city",detailAddress,@"detailAddress",nil];
                         [[NSUserDefaults standardUserDefaults] setObject:localDic forKey:@"localDic"];
                         NSLog(@"street address: %@",detailAddress);
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}

#pragma mark - 跳转到注册页面
- (void)regController:(UIButton *)sender
{
    RegViewController * regVC = [[RegViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}
#pragma mark - 登录
- (IBAction)forgetBtnClicked:(id)sender {
    [self forgetPass];
}

- (IBAction)loginBtnClicked:(id)sender {
    [self userLogin];
}

- (IBAction)weixinLoginClicked:(id)sender {
    [self weiChatTapLogin:sender];
}

- (IBAction)weiboLoginClicked:(id)sender {
    [self weiboTapLogin:sender];
}

- (IBAction)guestBtnClicked:(id)sender {
    [self guestBtnClicked];
}

#pragma mark - 监听用户名、密码输入框键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.mobileTF]) {
        self.mobileIV.image = [UIImage imageNamed:@"login_mobile_pre"];
    }else if ([textField isEqual:self.pwdTF]) {
        self.pwdIV.image = [UIImage imageNamed:@"login_pwd_pre"];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if ([textField isEqual:self.mobileTF]) {
            self.mobileIV.image = [UIImage imageNamed:@"login_mobile"];
        }else if ([textField isEqual:self.pwdTF]) {
            self.pwdIV.image = [UIImage imageNamed:@"login_pwd"];
        }
    }
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)userLogin {
//    RegMarksCollectionController *vc = [[RegMarksCollectionController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    //判断输入是否合法
    NSString * passStr = [self.pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSDictionary * guarantorDic = self.toSellerModel.guarantor;
    //    if ([passStr isEqualToString:@""] || passStr.length == 0 || passStr == nil) {
    //        [AutoDismissAlert autoDismissAlert:@"请填写手机号"];
    //        return;
    //    }
    
    
    if (self.mobileTF.text.length == 0 || passStr.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"账号或密码不能为空"];
        return;
    }
    
    [self.view endEditing:YES];
    
    [self userLoginRequestWithAccount:self.mobileTF.text Pwd:passStr];
}
- (void)userLoginRequestWithAccount:(NSString *)account Pwd:(NSString *)pwd
{
    AppDelegate * appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post请求所需参数
    NSDictionary * loginParam = @{@"method":@"accountLogin",@"parameters":@{@"account":account,@"password":pwd,@"deviceID":@"123456",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME]}};
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
            [dataDic setObject:self.mobileTF.text forKey:@"account"];
            
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
            
            [[NSUserDefaults standardUserDefaults]setObject:self.mobileTF.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:self.pwdTF.text forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
            //设置别名
            [APService setAlias:self.mobileTF.text callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
            
            NSDictionary * tempDic = [dic objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
            NSString * rongCloudTokens = [tempDic objectForKey:@"rongCloud"];
            if ([rongCloudTokens isEqualToString:@""] || rongCloudTokens == nil || rongCloudTokens.length == 0) {
                rongCloudTokens = @"0";
            }
            [[NSUserDefaults standardUserDefaults] setObject:rongCloudTokens forKey:@"rongCloud"];
            [[NSUserDefaults standardUserDefaults] setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
            
            //获取本人token
            NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
            NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
//            if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
//                // 连接融云服务器。
//                [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
//                    // 此处处理连接成功。
//                    [appDele getFriendArr];
//                    [appDele rongCloudRun];
//                    [appDele setUserPortraitClick];
//                    [appDele getNewNewsCount];
//                } error:^(RCConnectErrorCode status) {
//                    // 此处处理连接错误。
//                }];
//                //[appDele connectRongCloud];
//            }
            [appDele getFriendArr];
            [appDele rongCloudRun];
            [appDele setUserPortraitClick];
            [appDele getNewNewsCount];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
            appDele.mainTab.tabBar.hidden = YES;
            appDele.customTab.hidden = NO;
            appDele.zhedangView.hidden = YES;
            //            [appDele creatBtns];
            [appDele.mainTab setSelectedIndex:0];
            appDele.tabBarBtn1.selected = YES;
            appDele.tabBarBtn5.selected = NO;
            //appDele.window.rootViewController = appDele.mainTab;
            [appDele JPush];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            //if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //}
        }
    } andFailureBlock:^{
        [HUD hide:YES];
        [HUD removeFromSuperview];
    }];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    
    if (textField == self.pwdTF) {
        if (textField.text.length > 19) {
            return NO;
        }
    }
//    if (textField == nameText) {
//        if (textField.text.length > 10) {
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark - 第三方登录
- (void)weiboTapLogin:(UITapGestureRecognizer *)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"登录中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            id <ISSPlatformCredential> creden = [userInfo credential];
            //                                   NSString* uid = [creden uid];
            NSString* token = [creden token];
            
            self.weiboToken = token;
            //拼接post请求所需参数
            NSDictionary * loginParam = @{@"method":@"accountLoginToken",@"parameters":@{@"type":@"weibo",@"token":[NSString stringWithFormat:@"%@",token],@"deviceID":@"0",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME]}};
            [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
                    if (dataDic == nil) {
                        dataDic = [NSMutableDictionary dictionary];
                    }
                    [dataDic setObject:@"1" forKey:@"isLogin"];
                    
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
                    NSDictionary * tempDic = [dic objectForKey:@"data"];
                    NSString * rongCloudTokens = [tempDic objectForKey:@"rongCloud"];
                    if ([rongCloudTokens isEqualToString:@""] || rongCloudTokens == nil || rongCloudTokens.length == 0) {
                        rongCloudTokens = @"0";
                        [AutoDismissAlert autoDismissAlertSecond:@"聊天模块初始化失败"];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:rongCloudTokens forKey:@"rongCloud"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"account"] forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"password"] forKey:@"pwd"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
                    //设置别名
                    [APService setAlias:[tempDic objectForKey:@"account"] callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
                    
                    //获取本人token
                    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
                    NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
                    AppDelegate * app =APPDELEGATE;
//                    if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
                        // 连接融云服务器。
//                        [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
//                            // 此处处理连接成功。
//                            [app getFriendArr];
//                            [app rongCloudRun];
//                            [app setUserPortraitClick];
//                            [app getNewNewsCount];
//                        } error:^(RCConnectErrorCode status) {
//                            // 此处处理连接错误。
//                        }];
//                    }
                    [app getFriendArr];
                    [app rongCloudRun];
                    [app setUserPortraitClick];
                    [app getNewNewsCount];
                    app.mainTab.tabBar.hidden = YES;
                    app.customTab.hidden = NO;
                    [app.mainTab setSelectedIndex:0];
                    app.tabBarBtn1.selected = YES;
                    app.tabBarBtn5.selected = NO;
                    app.zhedangView.hidden = YES;
//                    app.window.rootViewController = app.mainTab;
                    [app JPush];
                    
                    if ([tempDic[@"isNew"] isEqualToString:@"0"]) {
                        //已经注册过
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        RegMarksCollectionController *vc = [[RegMarksCollectionController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                   
                    
                }else if ([result isEqualToString:@"100"]){
                    //                                           [HUD removeFromSuperview];
                    //                                           UIAlertView *signAlert = [[UIAlertView alloc] initWithTitle:@"验证通过,请绑定手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //                                           signAlert.tag = 1314;
                    //                                           [signAlert show];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD hide:YES];
                [HUD removeFromSuperview];
            } andFailureBlock:^{
                [HUD hide:YES];
                [HUD removeFromSuperview];
            }];
        }else{
            
        }
    }];
}

- (void)weiChatTapLogin:(UITapGestureRecognizer *)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if (result)
        {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"登录中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            id <ISSPlatformCredential> creden = [userInfo credential];
            NSString* uid = [creden uid];
            NSString* token = [creden token];
            
            self.weixinToken = token;
            self.weixinUid = uid;
            //拼接post请求所需参数
            NSDictionary * loginParam = @{@"method":@"accountLoginToken",@"parameters":@{@"type":@"weixin",@"token":[NSString stringWithFormat:@"%@",token],@"deviceID":@"0",@"deviceName":[NSString stringWithFormat:@"%@",PHONE_NAME],@"unionid":[NSString stringWithFormat:@"%@",uid]}};
            [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
                    if (dataDic == nil) {
                        dataDic = [NSMutableDictionary dictionary];
                    }
                    [dataDic setObject:@"1" forKey:@"isLogin"];
                    //将登录状态写入配置文件
                    [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
                    NSDictionary * tempDic = [dic objectForKey:@"data"];
                    NSString * rongCloudTokens = [tempDic objectForKey:@"rongCloud"];
                    if ([rongCloudTokens isEqualToString:@""] || rongCloudTokens == nil || rongCloudTokens.length == 0) {
                        rongCloudTokens = @"0";
                        [AutoDismissAlert autoDismissAlertSecond:@"聊天模块初始化失败"];
                    }
                    [[NSUserDefaults standardUserDefaults]setObject:rongCloudTokens forKey:@"rongCloud"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"account"] forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"password"] forKey:@"pwd"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
                    
                    //设置别名
                    [APService setAlias:[tempDic objectForKey:@"account"] callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
                    
                    //获取本人token
                    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
                    NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
                    // 连接融云服务器。
                    AppDelegate * app =APPDELEGATE;
//                    if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
//                        // 连接融云服务器。
//                        [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
//                            // 此处处理连接成功。
//                            [app getFriendArr];
//                            [app rongCloudRun];
//                            [app setUserPortraitClick];
//                            [app getNewNewsCount];
//                        } error:^(RCConnectErrorCode status) {
//                            // 此处处理连接错误。
//                        }];
//                    }
                    [app getFriendArr];
                    [app rongCloudRun];
                    [app setUserPortraitClick];
                    [app getNewNewsCount];
                    
                    app.mainTab.tabBar.hidden = YES;
                    app.customTab.hidden = NO;
                    [app.mainTab setSelectedIndex:0];
                    app.tabBarBtn1.selected = YES;
                    app.tabBarBtn5.selected = NO;
                    app.zhedangView.hidden = YES;
//                    app.window.rootViewController = app.mainTab;
                    
                    if ([tempDic[@"isNew"] isEqualToString:@"0"]) {
                        //已经注册过
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        RegMarksCollectionController *vc = [[RegMarksCollectionController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                    [app JPush];
                }else if ([result isEqualToString:@"100"]){
                    [HUD removeFromSuperview];
                    UIAlertView *signAlert = [[UIAlertView alloc] initWithTitle:@"验证通过,请绑定手机号" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    signAlert.tag = 1315;
                    [signAlert show];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD hide:YES];
                [HUD removeFromSuperview];
            } andFailureBlock:^{
                [HUD hide:YES];
                [HUD removeFromSuperview];
            }];
        }else{
            NSLog(@"error code == %ld",(long)[error errorCode]);
            //                                   [AutoDismissAlert autoDismissAlert:[error errorDescription]];
        }
        
    }];
}

#pragma mark --UIAlertViewDelegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1314) {
        if (buttonIndex == 0) {
            RegViewController *regVC = [[RegViewController alloc] init];
            regVC.resultTP = 100;
            regVC.type = @"weibo";
            regVC.token = self.weiboToken;
            [self.navigationController pushViewController:regVC animated:YES];
        }
    }else if (alertView.tag == 1315){
        if (buttonIndex == 0) {
            RegViewController *regVC = [[RegViewController alloc] init];
            regVC.resultTP = 100;
            regVC.type = @"weixin";
            regVC.token = self.weixinToken;
            regVC.uid = self.weixinUid;
            [self.navigationController pushViewController:regVC animated:YES];
        }
    }
}

- (void)delete1
{
    self.mobileTF.text = @"";
}

#pragma mark - 忘记密码button
- (void)forgetPass
{
    ForgetPassViewController * forgetVC = [[ForgetPassViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
#pragma mark -游客登录
- (void)guestBtnClicked{
    //获取游客信息
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post请求所需参数
    NSDictionary * loginParam = @{@"method":@"getGuestInfo",@"parameters":@{}};
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
            [dataDic setObject:dic[@"data"][@"account"] forKey:@"account"];
            
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
            
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"account"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"][@"password"] forKey:@"pwd"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
            //设置别名
            [APService setAlias:self.mobileTF.text callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
            
            NSDictionary * tempDic = [dic objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
            NSString * rongCloudTokens = [tempDic objectForKey:@"rongCloud"];
            if ([rongCloudTokens isEqualToString:@""] || rongCloudTokens == nil || rongCloudTokens.length == 0) {
                rongCloudTokens = @"0";
            }
            [[NSUserDefaults standardUserDefaults]setObject:rongCloudTokens forKey:@"rongCloud"];
            [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
            
            //获取本人token
            NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
            NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
            //            if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
            //                // 连接融云服务器。
            //                [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
            //                    // 此处处理连接成功。
            //                    [appDele getFriendArr];
            //                    [appDele rongCloudRun];
            //                    [appDele setUserPortraitClick];
            //                    [appDele getNewNewsCount];
            //                } error:^(RCConnectErrorCode status) {
            //                    // 此处处理连接错误。
            //                }];
            //                //[appDele connectRongCloud];
            //            }
            
             AppDelegate * appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDele getFriendArr];
            [appDele rongCloudRun];
            [appDele setUserPortraitClick];
            [appDele getNewNewsCount];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
            appDele.mainTab.tabBar.hidden = YES;
            appDele.customTab.hidden = NO;
            appDele.zhedangView.hidden = YES;
            //            [appDele creatBtns];
            [appDele.mainTab setSelectedIndex:0];
            appDele.tabBarBtn1.selected = YES;
            appDele.tabBarBtn5.selected = NO;
            //appDele.window.rootViewController = appDele.mainTab;
            [appDele JPush];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        [HUD hide:YES];
        [HUD removeFromSuperview];
    }];
}


- (void)nextj
{
    RegViewController * regVC = [[RegViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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
