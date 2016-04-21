//
//  LoginViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "ZZViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "APService.h"
#import "AppDelegate.h"


@interface LoginViewController : ZZViewController<CLLocationManagerDelegate>

{
    MBProgressHUD * HUD;
}


@property (nonatomic, strong)NSString * account;

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度

@property (nonatomic,strong)UITabBarController * tab;
//@property (nonatomic, strong) NSDictionary *dataDic;//第三方登录
//@property (nonatomic, strong) NSDictionary *dataDicWX;//第三方登录微信
@property (nonatomic, strong) NSString *weixinToken;
@property (nonatomic, strong) NSString *weiboToken;
@property (nonatomic, strong) NSString *weixinUid;
@property (weak, nonatomic) IBOutlet UIImageView *mobileIV;
@property (weak, nonatomic) IBOutlet UIImageView *pwdIV;

@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
- (IBAction)forgetBtnClicked:(id)sender;
- (IBAction)loginBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)weixinLoginClicked:(id)sender;
- (IBAction)weiboLoginClicked:(id)sender;
- (IBAction)guestBtnClicked:(id)sender;

- (void)userLogin;
@end
