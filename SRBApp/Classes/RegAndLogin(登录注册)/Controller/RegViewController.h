//
//  RegViewController.h
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface RegViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic, strong) NSString * type;  //第三方登录类型/游客判断
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;

- (void)backBtn:(UIButton *)sender;
@end
