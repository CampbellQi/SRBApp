//
//  RegForEmailViewController.h
//  SRBApp
//
//  Created by zxk on 15/3/18.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface RegForEmailViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic,copy)NSString * email;  //手机号
@property (nonatomic,copy)NSString * userName;  //用户名
@property (nonatomic,copy)NSString * password;  //密码
@property (nonatomic,copy)NSString * nickName;
@property (nonatomic, strong) NSString * type;  //第三方登录类型
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;
@end
