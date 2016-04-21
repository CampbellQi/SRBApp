//
//  ZZRegActivityViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZRegActivityViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic,copy)NSString * phoneNum;  //手机号
@property (nonatomic,copy)NSString * userName;  //用户名
@property (nonatomic,copy)NSString * password;  //密码
@property (nonatomic,copy)NSString * nickName;
@property (nonatomic,copy)NSString * yaoqingToken;
@property (nonatomic, strong) NSString * type;  //第三方登录类型
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;

- (void)submitBtn:(UIButton *)sender;
@end
