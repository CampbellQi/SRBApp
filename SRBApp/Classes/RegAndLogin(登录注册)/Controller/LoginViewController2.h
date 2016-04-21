//
//  LoginViewController2.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController2  : ZZViewController<CLLocationManagerDelegate>

{
    MBProgressHUD * HUD;
    
    UITextField * nameText;
    
    UIImageView * nameImg;
    UIImageView * passImg;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
- (IBAction)forgetBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClicked:(id)sender;
- (IBAction)weixinLoginClicked:(id)sender;
- (IBAction)weiboLoginClicked:(id)sender;

@property (nonatomic, strong)NSString * account;

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度

@property (nonatomic,strong)UITabBarController * tab;
@property (nonatomic,strong)UITextField * passText;
//@property (nonatomic, strong) NSDictionary *dataDic;//第三方登录
//@property (nonatomic, strong) NSDictionary *dataDicWX;//第三方登录微信
@property (nonatomic, strong) NSString *weixinToken;
@property (nonatomic, strong) NSString *weiboToken;
@property (nonatomic, strong) NSString *weixinUid;
@property (nonatomic, weak) UIButton *thirdBtn;
@property (nonatomic, weak) UIButton *thirdImgBtn;

- (void)userLogin;
@end
