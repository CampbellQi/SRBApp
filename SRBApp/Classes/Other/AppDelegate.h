//
//  AppDelegate.h
//  SRBApp
//
//  Created by zxk on 14/12/15.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCIM.h"
#import "ZZNavigationController.h"
#import "CustomTabBarBtn.h"
#import "UncaughtExceptionHandler.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,RCIMReceiveMessageDelegate, WXApiDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic,strong)  ZZNavigationController  * loginNC;
@property (nonatomic,strong)UIApplication * application;
@property (nonatomic, strong) UIImageView *signView;   //新消息提示
@property (nonatomic, strong) UILabel *signLabel; //新消息提示数
@property (nonatomic, strong) UIImageView *versionSignView;   //新消息提示（订单）
@property (nonatomic, strong) UIImageView *newwFriendView;//新的熟人提示
@property (nonatomic, strong) UIImageView *footerPrintView;//足迹变化提示

// 手势解锁相关
//@property (strong, nonatomic) LLLockViewController* lockVc; // 添加解锁界面
//- (void)showLLLockViewController:(LLLockViewType)type;
- (void)getFriendArr;

//显示自定tabbar
@property (retain, nonatomic) UITabBarController *mainTab;  //主tabbarcontroller
@property (nonatomic, strong) UIImageView *tabBarImageV;
@property (nonatomic, strong) UIImageView *blurIamgeV;      //点击发布时的图片
@property (nonatomic,strong)UIButton * blurBtn;             //发布按钮
@property (retain, nonatomic) UIView *customTab;            //自定义tabbar

@property (nonatomic, strong) CustomTabBarBtn *tabBarBtn1;  //自定义tabbar的button
@property (nonatomic, strong) CustomTabBarBtn *tabBarBtn2;
@property (nonatomic, strong) CustomTabBarBtn *tabBarBtn4;
@property (nonatomic, strong) CustomTabBarBtn *tabBarBtn5;
@property (nonatomic,strong)UIView * zhedangView;           //手势滑动返回时用来遮挡自定义tabbar

- (void)connectRongCloud;
- (void)rongCloudRun;
- (void)creatBtns;
- (void)getNewNewsCount;
- (void)setUserPortraitClick;
- (void)JPush;

-(void)showLoginAlertView;
-(void)tabbarSelectedIndex:(NSInteger)index;
@end

