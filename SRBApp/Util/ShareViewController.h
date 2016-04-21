//
//  ShareViewController.h
//  SRBApp
//
//  Created by lizhen on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//#import "WeiboApi.h"
#import "ShareDetailViewController.h"
//@class ChangeBuyViewController;

@interface ShareViewController : UIViewController
+ (void)shareToThirdPlatformWithUIViewController:(UIViewController *)viewController Account:(NSString *)account Nickname:(NSString *)nickname Avatar:(NSString *)avatar Cover:(NSString *)cover IdNumber:(NSString *)idNumber Title:(NSString *)title Content:(NSString *)content Photo:(NSString *)photo Btn:(UIButton *)sender ShareUrl:(NSString *)shareUrl;

+ (void)shareToThirdPlatformWithUIViewController:(UIViewController *)viewController Title:(NSString *)title SecondTitle:(NSString *)secondTitle Content:(NSString *)content ImageUrl:(NSString *)imageurl SencondImgUrl:(NSString *)secondImgUrl Btn:(UIButton *)sender ShareUrl:(NSString *)shareUrl;
@end
