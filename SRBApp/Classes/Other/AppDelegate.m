//
//  AppDelegate.m
//  SRBApp
//
//  Created by zxk on 14/12/15.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"

#import "RCIM.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "TuSDK/TuSDK.h"

#import "APService.h"
#import "MobClick.h"

#import "AlipayWrapper.h"
#import "ZZMyOrderViewController.h"
#import "SubMyFriendsViewController.h"
//#import "FriendsViewController.h"
#import "BussinessViewController.h"
#import "AMBlurView.h"
#import "BuyViewController.h"
#import "SaleViewController.h"
#import "RunViewController2.h"
#import "NewLocationViewController.h"
//#import "NewShoppingViewController.h"
//#import "SPAndShoppingScrollController.h"

#import "MineFragmentViewController.h"

#import "GoodAssureViewController.h"

#import "FriendFragmentModel.h"
#import "MyChatListViewController.h"

#import "SubBuyerOrderDetailViewController.h"
#import "SubMyEvaluateViewController.h"
#import "SubMyAssureViewController.h"
#import "SubNewFriendsApplyViewController.h"
#import "SubSublPersonalViewController.h"
#import "SubSellerEvaluateAViewController.h"
#import "SubSellerOrderDetailViewController.h"
#import "SubSubdetailViewController.h"
#import "SubLocationDetailViewController.h"
#import "Reachability.h"
//#import "WelcomeFirstView.h"
#import "AddressBookListActivityViewController.h"

#import "SubRegViewController.h"
#import "LoginViewController.h"

//#import "ChangeBuyViewController.h"
#import "ChangeSaleViewController2.h"
#import "FreeSaleViewController.h"
#import <SDWebImageManager.h>
//#import "TopicToPurchasingController.h"
#import "HomeTopicListController.h"
#import "LinkManController.h"
#import "PublishTopicController.h"
//#import "PublishTopicController2.h"
//#import "RunViewController.h"
#import "InviteFriendsTableViewController.h"
#import "HandleNewsCenter.h"
#import "PublishSPController.h"

#import "WQGuideView.h"

#import "SPListController.h"
#import "WelcomeView.h"
#import "MineFragmentViewController2.h"
#import "HomeTopicMainController.h"

#define IS_IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] == 8.0
#define blur_y2 buyLabel.center.y - 80 * 2 - 20
#define blur_y1 buyLabel.center.y - 80 - 10

@interface AppDelegate ()<RCIMFriendsFetcherDelegate,RCIMUserInfoFetcherDelegagte, UIScrollViewDelegate>
{
    
    UIButton * buyButton;
    UIButton * saleButton;
    UIButton * runButton;
    UIButton * topicButton;
    UIButton * footerButton;
    UIButton * inviteButton;
    
    UILabel * buyLabel;
    UILabel * saleLabel;
    UILabel * runLabel;
    UIView * noView;
    
    WelcomeView * _welcomeView;
    UIImageView * flakeView;
    
    NSTimer * timer;
    ZZNavigationController *nav;
    
}

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) AMBlurView * blurView;
@property (nonatomic, strong) NSString *module;
@property (nonatomic, strong) NSString *value;

@end

@implementation AppDelegate

- (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //[self installUncaughtExceptionHandler];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //[NSThread sleepForTimeInterval:1];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"remoteNotification == %@",remoteNotification);
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    self.application = application;
    
//    LoginViewController * loginVC = [[LoginViewController alloc]init];
//    ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
//    self.loginNC = loginNC;
    
    //UMeng
    [self umengTrack];
    
    //熟人
    LinkManController * linkManVC = [[LinkManController alloc]init];
    //我的
    MineFragmentViewController2 * mineVC = [[MineFragmentViewController2 alloc]init];
    //逛街
    //SPAndShoppingScrollController * newShoppingVC = [[SPAndShoppingScrollController alloc]init];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    SPListController *newShoppingVC = [sb instantiateViewControllerWithIdentifier:@"SPListController"];
    //nsvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, sv.height);

    //NewShoppingViewController * shoppingVC = [[NewShoppingViewController alloc]init];
    //发现
    HomeTopicListController *discoverVC = [[HomeTopicListController alloc] init];
    //HomeTopicMainController *discoverVC = [[HomeTopicMainController alloc] init];
    //交易
    BussinessViewController * bussinessVC1 = [[BussinessViewController alloc]init];
    
    linkManVC.tabBarItem.title = @"熟人";
    mineVC.tabBarItem.title = @"我的";
    newShoppingVC.tabBarItem.title = @"求购";
    discoverVC.tabBarItem.title = @"发现";
    
    newShoppingVC.tabBarItem.image = [UIImage imageNamed:@"guangjie+"];
    newShoppingVC.tabBarItem.selectedImage = [UIImage imageNamed:@"guangjie"];
    
    mineVC.tabBarItem.image = [UIImage imageNamed:@"wode+"];
    mineVC.tabBarItem.selectedImage = [UIImage imageNamed:@"wode"];
    
    discoverVC.tabBarItem.image = [UIImage imageNamed:@"zuji+"];
    discoverVC.tabBarItem.selectedImage = [UIImage imageNamed:@"zuji"];
    
    linkManVC.tabBarItem.image = [UIImage imageNamed:@"shuren+"];
    linkManVC.tabBarItem.selectedImage = [UIImage imageNamed:@"shuren"];
    
    ZZNavigationController * vcNav = [[ZZNavigationController alloc]initWithRootViewController:discoverVC];
    ZZNavigationController * secNav = [[ZZNavigationController alloc]initWithRootViewController:newShoppingVC];
    ZZNavigationController * thirdNav = [[ZZNavigationController alloc]initWithRootViewController:linkManVC];
    ZZNavigationController * forthNav = [[ZZNavigationController alloc]initWithRootViewController:mineVC];
    
    //自定义tabBar
    self.customTab = [[UIView alloc] init];
    self.customTab.backgroundColor = [UIColor clearColor];
    self.customTab.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    self.customTab.layer.shadowOpacity = 0.6;
    self.customTab.layer.shadowOffset = CGSizeMake(0, -4);
    self.customTab.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.mainTab = [[UITabBarController alloc] init];
    
    UIImage *bgImg = [[UIImage alloc] init];
    [self.mainTab.tabBar setBackgroundImage:bgImg];
    [self.mainTab.tabBar setShadowImage:bgImg];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedAscending) {
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:127.0/255.0 green:186.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [[UITabBar appearance] setSelectionIndicatorImage:bgImg];
    }
    
    self.mainTab.viewControllers = @[vcNav,secNav,bussinessVC1,thirdNav,forthNav];
    
    [self.mainTab.tabBar setHidden:YES];
    [self.customTab setFrame:CGRectMake(0, _mainTab.view.bounds.size.height-49, SCREEN_WIDTH, 49)];
    UIView * zhedangView = [[UIView alloc]initWithFrame:self.customTab.frame];
    zhedangView.backgroundColor = [UIColor clearColor];
    self.zhedangView = zhedangView;
    zhedangView.hidden = YES;
    UITapGestureRecognizer * tempTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tempTap)];
    [zhedangView addGestureRecognizer:tempTap];
    
    [self.mainTab.view addSubview:self.customTab];
    [self.mainTab.view addSubview:zhedangView];
    
    [self creatBtns];
    
    _blurView = [[AMBlurView alloc]initWithFrame:CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
    self.blurIamgeV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 49/2, SCREEN_HEIGHT - 49, 49, 49)];
    self.blurBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blurBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 49/2, SCREEN_HEIGHT - 49, 49, 49);
    [self.blurBtn setImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    
    _blurView.userInteractionEnabled = YES;
    self.blurIamgeV.image = [UIImage imageNamed:@"fabu"];
    self.blurIamgeV.userInteractionEnabled = YES;
    //[_blurView addSubview:self.blurBtn];
    [_blurView addSubview:self.blurIamgeV];
    
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, _blurView.frame.size.height - 12, SCREEN_WIDTH, 2)];
    view.image = [UIImage imageNamed:@"fabuxian.png"];
    [_blurView addSubview:view];
    
    UIImageView * view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 420 / 1.5,  SCREEN_WIDTH / 540 * 330 / 1.5)];
    view1.image = [UIImage imageNamed:@"publish_slogan"];
    view1.center = CGPointMake(SCREEN_WIDTH / 2 + view1.frame.size.width * 0.05, view1.frame.size.height / 2 + SCREEN_WIDTH / 540 * 120 + 64);
    view1.contentMode = UIViewContentModeScaleAspectFit;
    [_blurView addSubview:view1];
    
    UITapGestureRecognizer *blurTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurTapMothed:)];
    [self.blurIamgeV addGestureRecognizer:blurTap];
    
    //    [self.blurBtn addTarget:self action:@selector(blurTapMothed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *removeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurTapMothed:)];
    [_blurView.toolbar addGestureRecognizer:removeTap];
    
    saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, SCREEN_HEIGHT - 40 - 70 - 12, 40, 12)];
    saleLabel.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 40);
    //saleLabel.backgroundColor = [UIColor redColor];
    [_blurView addSubview:saleLabel];
    
    buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 12)];
    buyLabel.center = CGPointMake(40 + 60 / 2, saleLabel.center.y);
    //buyLabel.backgroundColor = [UIColor redColor];
    [_blurView addSubview:buyLabel];
    
    runLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 12)];
    runLabel.center = CGPointMake(SCREEN_WIDTH - 40 - 60 / 2, saleLabel.center.y);
    [_blurView addSubview:runLabel];
    
    float y1 = blur_y1;
    
    //卖
    saleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    saleButton.center = CGPointMake(saleLabel.center.x, y1);
    [saleButton setImage:[UIImage imageNamed:@"publish_sell.png"] forState:UIControlStateNormal];
    [saleButton addTarget:self action:@selector(saleAction) forControlEvents:UIControlEventTouchUpInside];
    //[_blurView addSubview:saleButton];
    //送
    runButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    runButton.center = CGPointMake(runLabel.center.x - 30, y1);
    [runButton setImage:[UIImage imageNamed:@"publish_freeBuy.png"] forState:UIControlStateNormal];
    [runButton addTarget:self action:@selector(runAction) forControlEvents:UIControlEventTouchUpInside];
    //[_blurView addSubview:runButton];
    
    float y2 = blur_y2;
    //话题
    topicButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    topicButton.center = CGPointMake(buyLabel.center.x + 30, y1);
    [topicButton setImage:[UIImage imageNamed:@"publish_topic.png"] forState:UIControlStateNormal];
    [topicButton addTarget:self action:@selector(topicAction) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:topicButton];
    //足迹
    footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    footerButton.center = CGPointMake(runLabel.center.x - 30, y1);
    [footerButton setImage:[UIImage imageNamed:@"publish_footer.png"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(footerAction) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:footerButton];
    //买
    buyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    buyButton.center = CGPointMake(saleLabel.center.x, y1);
    [buyButton setImage:[UIImage imageNamed:@"publish_buy.png"] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:buyButton];
    
    //邀请
    inviteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 80)];
    inviteButton.center = CGPointMake(runLabel.center.x - 30, y2);
    [inviteButton setImage:[UIImage imageNamed:@"publish_invite.png"] forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    //[_blurView addSubview:inviteButton];
    [self.mainTab.view addSubview:_blurView];
    
    //rongCloud
    [self rongCloud];
    
    //shareSDK
    [self shareSDK];
    
    
    
    //TuSDK
    [self TuSDK];
    
    [APService setupWithOption:launchOptions];
    [[RCIM sharedRCIM]setReceiveMessageDelegate:self];
    //选择根视图
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    NSDictionary * versionDic = [[NSBundle mainBundle] infoDictionary];
    self.window.rootViewController = self.mainTab;
    if (dic == nil) {
        
        
//        //将登录状态写入配置文件
//        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
//        [self setNoLoginState];
        
//        self.window.rootViewController = loginNC;
        
        
        WelcomeView *wv = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) GifArray:@[@"w1", @"w2", @"w3", @"w4"]];
        //dsfa
        //welcomeView = [[WelcomeFirstView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //welcomeView.scrollView.delegate = self;
        [self.window.rootViewController.view addSubview:wv];
        _welcomeView = wv;
        
        [wv.button addTarget:self action:@selector(firstuse) forControlEvents:UIControlEventTouchUpInside];
        double delayInSeconds = 5.0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //[WelcomeFirstView animation:welcomeView.image1];
        });
        
    }else{
        /** 版本 */
        [dic setObject:[versionDic objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        if ([[dic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
            NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
            if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
                [self getFriendArr];
                [self setUserPortraitClick];
                [self rongCloudRun];
            }
            //JPush
            [self JPush];
        }
    }

    //检测版本更新
    //    [self onCheckVersion];
    
    
    //监测网络状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkNetworkState];
    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    Reachability * conn = [Reachability reachabilityForInternetConnection];
    [conn startNotifier];
    
//    UIImageView * openImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    if (SCREEN_HEIGHT == 480) {
//        openImage.image = [UIImage imageNamed:@"IOS_4s.png"];
//    }else if(SCREEN_HEIGHT == 568){
//        openImage.image = [UIImage imageNamed:@"IOS_5.png"];
//    }else if(SCREEN_WIDTH == 375){
//        openImage.image = [UIImage imageNamed:@"IOS_6.png"];
//    }else if(SCREEN_WIDTH == 414){
//        openImage.image = [UIImage imageNamed:@"IOS_6Plus.png"];
//    }
//    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(dono)];
//    openImage.userInteractionEnabled = YES;
//    [openImage addGestureRecognizer:tap];
//    
//    [self.window.rootViewController.view addSubview:openImage];
//    double delayInSeconds = 4.0;
//    //        __block ViewController* bself = self;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [WelcomeFirstView closeView:openImage];
//        ZZNavigationController * tempNC = (ZZNavigationController *)self.mainTab.viewControllers[0];
//        ShoppingViewController * shoppingVC = tempNC.viewControllers[0];
//        [shoppingVC presentViewController:self.loginNC animated:NO completion:nil];
//    });
    
    //统一导航条样式
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[GetColor16 hexStringToColor:@"#e5005d"]];
    
    self.window.backgroundColor = WHITE;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)rongCloudRun
{
    //[self connectRongCloud];
    NSTimer * contentTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                              target:self
                                                            selector:@selector(printMessage:)
                                                            userInfo:nil
                                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:contentTimer forMode:NSRunLoopCommonModes];
//    [self connectRongCloud];

}

- (void)setNoLoginState
{
    [[NSUserDefaults standardUserDefaults]setObject:GUEST forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"pwd"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"passsign"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"rongCloud"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"avatar"];
}

//集成shareSDK
- (void)shareSDK
{
    //集成shareSDK
    [ShareSDK registerApp:@"a921001d93d2"];
    
    //设置屏幕方向,默认是所有方向(optional)
    [ShareSDK setInterfaceOrientationMask:SSInterfaceOrientationMaskAll];
    
    //新浪微博登录/分享
    [ShareSDK connectSinaWeiboWithAppKey:@"358763791"
                               appSecret:@"7f942873dff9b429962dd25ab7dd96fb"
                             redirectUri:@"http://mapi.shurenbang.net/user/auth/weibo.action"
                             weiboSDKCls:[WeiboSDK class]];
    
    //微信登录/分享
    [ShareSDK connectWeChatWithAppId:@"wx814e46e128bf9e1f"
                           appSecret:@"045f365a509de870a2e45c3c38734eba"
                           wechatCls:[WXApi class]];
//    //短信分享
//    [ShareSDK connectSMS];
//    
//    [ShareSDK importQQClass:[QQApiInterface class]
//            tencentOAuthCls:[TencentOAuth class]];
    
    //QQ空间分享
    [ShareSDK connectQZoneWithAppKey:@"1104161480"
                           appSecret:@"ldr1jBIaGXeeQE4e"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //QQ分享
    [ShareSDK connectQQWithQZoneAppKey:@"1104161480"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    [ShareSDK importTencentWeiboClass:[WeiboSDK class]];
    
    
//    //腾讯微博分享
//    [ShareSDK connectTencentWeiboWithAppKey:@"801558191"
//                                  appSecret:@"f7875d9654ce92082996c76b7e9e075d"
//                                redirectUri:@"http://mapi.shurenbang.net/user/auth/weibo.action"
//                                   wbApiCls:nil];
    
}
//集成极光
- (void)JPush
{
    //集成极光推送
    //极光本地推送
    //    [APService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:2]
    //                          alertBody:@"test ios8 notification"
    //                              badge:0
    //                        alertAction:@"确定"
    //                      identifierKey:@"1"
    //                           userInfo:nil
    //                          soundName:nil
    //                             region:nil
    //                 regionTriggersOnce:YES
    //                           category:@"test"];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        
        NSMutableSet *categories = [NSMutableSet set];
        
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"Accept";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        //    action.authenticationRequired = YES;
        //    action.destructive = YES;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = YES;
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
        [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        
        [categories addObject:categorys];
        
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:categories];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
}

//集成图片处理
- (void)TuSDK
{
    [TuSDK initSdkWithAppKey:@"3b8c89851097d349-00-236nn1"];
}

- (void)dono
{
    
}

- (void)tempTap
{
    
}

- (void)onTimer
{
    // build a view from our flake image
    flakeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flake.png"]];
    
    // use the random() function to randomize up our flake attributes
    int startX = round(random() % 320);
    int leftorright = (1 + (arc4random() % (2 - 1 + 1)));
    double rounda = (50 + (arc4random() % (100 - 50 + 1))) * 0.01;
    double ronddb = -1.0 * rounda;
    double scale = 1 / round(random() % 100) + 1.0;
    double speed = 1 / round(random() % 100) + 1.0;
//    NSLog(@"%d",leftorright);
    // set the flake start position
    flakeView.frame = CGRectMake(startX, -100.0, 25.0 * scale, 25.0 * scale);
    flakeView.alpha = 1;
    
    // put the flake in our main view
    //[welcomeView.view3 addSubview:flakeView];
    
    
    
    [UIView beginAnimations:nil context:(__bridge void *)(flakeView)];
    
    // set up how fast the flake will fall
    [UIView setAnimationDuration:5 * speed];
    
    
    // set the postion where flake will move to
    flakeView.frame = CGRectMake(startX, SCREEN_HEIGHT, 25.0 * scale, 25.0 * scale);
    if (leftorright == 1) {
        CGAffineTransform newTransform = CGAffineTransformMakeRotation(M_PI * rounda);
        [flakeView setTransform:newTransform];
    }else{
        CGAffineTransform newTransform = CGAffineTransformMakeRotation(M_PI * ronddb);
        [flakeView setTransform:newTransform];
    }
    // set a stop callback so we can cleanup the flake when it reaches the
    // end of its animation
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
/*
 //- (void)round
 //{
 ////    flakeView.transform = CGAffineTransformRotate(flakeView.transform,2 * M_PI / 2);
 //    CABasicAnimation* rotationAnimation;
 //    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 //    rotationAnimation.delegate = self;
 //    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.5];
 //    rotationAnimation.duration = 0.3;
 //    rotationAnimation.repeatCount = 10;
 //    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
 //    [rotationAnimation setValue:@"rotationAnimation" forKey:@"MyAnimationType"];
 ////    [button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
 ////    [button setImage:[UIImage imageNamed:@"fabu.png"] forState:UIControlStateNormal];
 //    flakeView.transform = CGAffineTransformMakeRotation(0);
 //}
 */

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    flakeView = (__bridge UIImageView *)(context);
    [flakeView removeFromSuperview];
    // open the debug log and you will see that all flakes have a retain count
    // of 1 at this point so we know the release below will keep our memory
    // usage in check
    //    NSLog([NSString stringWithFormat:@"[flakeView retainCount] = %d", [flakeView retainCount]]);
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
//    if (scrollView.contentOffset.x == 0) {
//        [WelcomeFirstView animation:welcomeView.image1];
//        welcomeView.image2.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image2.frame.size.height);
//        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image3.frame.size.height);
//        [timer setFireDate:[NSDate distantFuture]];
//        welcomeView.page.currentPage = 0;
//    }
//    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
//        [WelcomeFirstView animation:welcomeView.image2];
//        welcomeView.image1.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image1.frame.size.height);
//        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image3.frame.size.height);
//        [timer setFireDate:[NSDate distantFuture]];
//        welcomeView.page.currentPage = 1;
//    }
//    if (scrollView.contentOffset.x == SCREEN_WIDTH * 2) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:(0.15) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
//        [timer setFireDate:[NSDate distantPast]];
//        [WelcomeFirstView animation:welcomeView.image3];
//        welcomeView.image2.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image2.frame.size.height);
//        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image1.frame.size.height);
//        welcomeView.page.currentPage = 2;
//    }
}

- (void)firstuse
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionary];
    }
    [dataDic setObject:@"1" forKey:@"finished"];
    [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
    //    welcomeView.hidden = YES;
        [_welcomeView removeFromSuperview];
    //[WelcomeFirstView closeView:welcomeView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.window.rootViewController = self.mainTab;
//    });
    
    ZZNavigationController * tempNC = (ZZNavigationController *)self.mainTab.viewControllers[0];
    
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
    HomeTopicListController * shoppingVC = tempNC.viewControllers[0];
    [shoppingVC presentViewController:loginNC animated:NO completion:nil];

    [timer invalidate];
    timer = nil;
}

//网络状态
- (void)networkStateChange
{
    [self checkNetworkState];
}

- (void)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        
    } else { // 没有网络
        [AutoDismissAlert autoDismissAlert:@"当前网络连接中断"];
        NSLog(@"没有网络");
    }
}
#pragma mark -- 融云方法

- (void)rongCloud
{
    //集成融云
    
    // 初始化 SDK，传入 App Key，deviceToken 暂时为空，等待获取权限。
    [RCIM initWithAppKey:@"tdrvipksrgmk5" deviceToken:nil];
    
    // 设置好友信息提供者。
    [RCIM setFriendsFetcherWithDelegate:self];
    
    // 设置用户信息提供者。
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:NO];
    
    // 设置检测聊天状态
//    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

- (void)printMessage:(NSTimer *)timer
{
    NSLog(@"定时连接融云");
    [self connectRongCloud];
}

- (void)connectRongCloud
{
    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
    if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
        // 连接融云服务器。
        [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
            // 此处处理连接成功。
            //获取新消息数
            [self getNewNewsCount];
            
            [APService setAlias:ACCOUNT_SELF callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
        } error:^(RCConnectErrorCode status) {
            // 此处处理连接错误。
        }];
    }
    
}

- (void)getFriendArr
{
    //获取好友列表
    self.array = [[NSMutableArray alloc]init];

    //拼接post请求所需参数
    NSDictionary * loginParam = @{@"method":@"accountGetFriend",@"parameters":@{ACCOUNT_PASSWORD,@"groupId":@"-1"}};
    
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        [self.array removeAllObjects];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            for (int i = 0; i < [[[dic objectForKey:@"data"] objectForKey:@"list"]count]; i++) {
                NSDictionary * tempdic = [[[dic objectForKey:@"data"] objectForKey:@"list"] objectAtIndex:i];
                FriendFragmentModel *friendFragmentModel = [[FriendFragmentModel alloc]init];
                [friendFragmentModel setValuesForKeysWithDictionary:tempdic];
                
                RCUserInfo *user = [[RCUserInfo alloc] init];
                user.userId = friendFragmentModel.account;
                if (![friendFragmentModel.memo isEqualToString:@""]) {
                    user.name = friendFragmentModel.memo;
                }else{
                    user.name = friendFragmentModel.nickname;
                }
                user.portraitUri = friendFragmentModel.avatar;

                [self.array addObject:user];
            }
//            RCUserInfo *userSelf = [[RCUserInfo alloc] init];
//            userSelf.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//            userSelf.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
//            userSelf.portraitUri = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
//            NSLog(@"userName = %@",userSelf.userId);
//            [self.array addObject:userSelf];
        }
    } andFailureBlock:^{
        
    }];
}

// 集成融云
// 获取好友列表的方法。
-(NSArray*)getFriends
{
    NSLog(@"self.array == %@",self.array);
    
    return self.array;
}

// 融云获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    RCUserInfo *user  = nil;
    if([userId length] == 0){
        return completion(nil);
    }
    for(RCUserInfo *u in self.array)
    {
        if([u.userId isEqualToString:userId])
        {
            user = u;
            break;
        }
    }
    NSLog(@"user == %@",user);
    //    NSDictionary *dic = @{@"user":user};
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"getListCount" object:nil userInfo:dic];
    return completion(user);
}
//融云头像点击事件
- (void)setUserPortraitClick
{
    [[RCIM sharedRCIM] setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        personalVC.account = userInfo.userId;
        personalVC.nickname = userInfo.name;
        NSLog(@"userInfo.userId == %@",userInfo.userId);
        if ([userInfo.userId isEqualToString:@"(null)"] || userInfo.userId == nil) {
            [AutoDismissAlert autoDismissAlert:@"与该用户未建立好友关系，无法查看其个人主页"];
        }else{
            [viewController.navigationController pushViewController:personalVC animated:YES];
        }
    }];
    
}
//////融云连接状态
//-(void)responseConnectionStatus:(RCConnectionStatus)status
//{
////    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
////        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您的账号在其他设备登录，是否重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
////        [alert show];
////    }
//}

#pragma mark -- UMeng统计方法
- (void)umengTrack {
    //        [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:@"54f6c573fd98c5a89e000911" reportPolicy:BATCH channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    //    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}
-(void)playBlurBtnAnimations {
    //显示由于发现或逛街隐藏的状态栏
    [self.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [UIView beginAnimations:@"_blurViewx" context:nil];
    [UIView setAnimationDuration:0.3];
    footerButton.center = CGPointMake(runLabel.center.x - 30, blur_y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurViewz" context:nil];
    [UIView setAnimationDuration:0.3];
    buyButton.center = CGPointMake(saleLabel.center.x, blur_y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurViewz" context:nil];
    [UIView setAnimationDuration:0.3];
    topicButton.center = CGPointMake(buyLabel.center.x + 30, blur_y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurViewy" context:nil];
    [UIView setAnimationDuration:0.3];
    saleButton.center = CGPointMake(saleLabel.center.x, blur_y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurViewz" context:nil];
    [UIView setAnimationDuration:0.3];
    runButton.center = CGPointMake(runLabel.center.x - 30, blur_y1);
    [UIView commitAnimations];
    
    
    
    
    [UIView beginAnimations:@"_blurViewz" context:nil];
    [UIView setAnimationDuration:0.3];
    inviteButton.center = CGPointMake(runLabel.center.x-30, blur_y2);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    CGAffineTransform transform = CGAffineTransformMakeRotation(2*M_PI);
    self.tabBarImageV.transform = transform;
    [UIView commitAnimations];
}
- (void)buyAction
{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
       
        [self showLoginAlertView];
    }else{
    //ZZNavigationController * tempNC = self.mainTab.viewControllers[0];
    //DiscoverListController * shoppingVC = tempNC.viewControllers[0];
    //[shoppingVC huanYuan];
    //求购
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    PublishSPController * vc = sb.instantiateInitialViewController;
    //        vc.theSign = @"2";
    vc.isFromPublish = YES;
    
    ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
    //[UIView beginAnimations:@"_blurView1" context:nil];
    //[UIView setAnimationDuration:1];
    //_blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    //[UIView commitAnimations];
    
    [self playBlurBtnAnimations];
    
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];
    }
    //    }
}

- (void)saleAction
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
//        [self login:nil];
//    }else{
    //ZZNavigationController * tempNC = self.mainTab.viewControllers[0];
    //DiscoverListController * shoppingVC = tempNC.viewControllers[0];
    //[shoppingVC huanYuan];
    
        ChangeSaleViewController2 * vc = [[ChangeSaleViewController2 alloc]init];
        vc.isFromPublish = YES;
//        vc.theSign = @"1";
        ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
//        [UIView beginAnimations:@"_blurView2" context:nil];
//        [UIView setAnimationDuration:1];
//        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//        [UIView commitAnimations];
    
        [self playBlurBtnAnimations];
        
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];
//    }
}

- (void)runAction
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
//        [self login:nil];
//    }else{
    //ZZNavigationController * tempNC = self.mainTab.viewControllers[0];
    //DiscoverListController * shoppingVC = tempNC.viewControllers[0];
    //[shoppingVC huanYuan];
    FreeSaleViewController *vc = [[FreeSaleViewController alloc] init];
        //GoodAssureViewController * vc = [[GoodAssureViewController alloc]init];
        ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
//        [UIView beginAnimations:@"_blurView3" context:nil];
//        [UIView setAnimationDuration:1];
//        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//        [UIView commitAnimations];
    
       [self playBlurBtnAnimations];
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];
//    }
}
- (void)topicAction
{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
       
        [self showLoginAlertView];
    }else{
    //    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
    //        [self login:nil];
    //    }else{
    //ZZNavigationController * tempNC = self.mainTab.viewControllers[0];
    //DiscoverListController * shoppingVC = tempNC.viewControllers[0];
    //[shoppingVC huanYuan];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Discover" bundle:[NSBundle mainBundle]];
    UIViewController *vc = sb.instantiateInitialViewController;
    //GoodAssureViewController * vc = [[GoodAssureViewController alloc]init];
    ZZNavigationController * nac = [[ZZNavigationController alloc] initWithRootViewController:vc];
//    [UIView beginAnimations:@"_blurView4" context:nil];
//    [UIView setAnimationDuration:1];
//    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//    [UIView commitAnimations];
    
    [self playBlurBtnAnimations];
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];
    }
    //    }
}
- (void)footerAction
{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        [self showLoginAlertView];
    }else{
    //    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
    //        [self login:nil];
    //    }else{
    //ZZNavigationController * tempNC = self.mainTab.viewControllers[0];
    //DiscoverListController * shoppingVC = tempNC.viewControllers[0];
    //[shoppingVC huanYuan];
    RunViewController2 *vc = [[RunViewController2 alloc] init];
    //GoodAssureViewController * vc = [[GoodAssureViewController alloc]init];
    ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
//    [UIView beginAnimations:@"_blurView5" context:nil];
//    [UIView setAnimationDuration:1];
//    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//    [UIView commitAnimations];
    
    [self playBlurBtnAnimations];
    //[self.mainTab pushViewController:nac];
    //    }
    
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];
    }
}
-(void)inviteAction {
    InviteFriendsTableViewController * vc = [[InviteFriendsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    //GoodAssureViewController * vc = [[GoodAssureViewController alloc]init];
    ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
    //    [UIView beginAnimations:@"_blurView5" context:nil];
    //    [UIView setAnimationDuration:1];
    //    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    //    [UIView commitAnimations];
    
    [self playBlurBtnAnimations];
    //[self.mainTab pushViewController:nac];
    //    }
    
    [self.mainTab pushViewController:nac Completion:^{
        _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    }];

}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
};


//推送
//#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
//#endif

-(void)didReceivedMessage:(RCMessage *)message left:(int)nLeft
{
    if (0 == nLeft) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
            [self getNewNewsCount];
        });
    }
}
//本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"notification == %@",notification);
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNews" object:nil];
    [self getNewNewsCount];
    //极光
    
    //    [APService showLocalNotificationAtFront:notification identifierKey:@"1"];
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    // 手势解锁相关
    //    NSString* pswd = [LLLockPassword loadLockPassword];
    //    if (pswd) {
    //        [self showLLLockViewController:LLLockViewTypeCheck];
    //    }
    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
    if (rongCloudToken != nil && ![rongCloudToken isEqualToString:@""] && rongCloudToken.length != 0) {
       [self connectRongCloud];
    }
}

//#pragma mark - 弹出手势解锁密码输入框
//- (void)showLLLockViewController:(LLLockViewType)type
//{
//    if(self.window.rootViewController.presentingViewController == nil){
//
//        LLLog(@"root = %@", self.window.rootViewController.class);
//        LLLog(@"lockVc isBeingPresented = %d", [self.lockVc isBeingPresented]);
//
//        self.lockVc = [[LLLockViewController alloc] init];
//        self.lockVc.nLockViewType = type;
//
//        self.lockVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self.window.rootViewController presentViewController:self.lockVc animated:NO completion:^{
//        }];
//        LLLog(@"创建了一个pop=%@", self.lockVc);
//    }
//}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//推送

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSLog(@"deviceToken:%@",deviceToken);
    [[RCIM sharedRCIM]setDeviceToken:deviceToken];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
        NSLog(@"token == %@",token);
        [RCIM connectWithToken:token completion:^(NSString *userId) {
            
        } error:^(RCConnectErrorCode status) {
            
        }];
    [APService registerDeviceToken:deviceToken];
}


//ios8
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    self.module = [userInfo objectForKey:@"module"];
    self.value = [userInfo objectForKey:@"value"];
    ZZNavigationController *nav = self.mainTab.viewControllers[0];
    [self tabbarSelectedIndex:0];
    [HandleNewsCenter handleMsgCenterModule:self.module Value:self.value NavigationController:nav];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    NSLog(@"RemoteNote userInfo:%@",userInfo);
//    NSLog(@" 收到推送消息: %@",[[userInfo objectForKey:@"aps"] objectForKey:nil]);
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag==10000) {
//        if (buttonIndex==1) {
//            //跳转到AppStore
//            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d",APP_ID];
//            NSURL *url = [NSURL URLWithString:str];
//            [[UIApplication sharedApplication]openURL:url];
//        }
//    }
//    else if (buttonIndex == 1) {
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
//        [RCIM connectWithToken:token completion:^(NSString *userId) {
//        } error:^(RCConnectErrorCode status) {
//        }];
//    }
//}
-(void)tabbarSelectedIndex:(NSInteger)index {
    self.tabBarBtn1.selected = NO;
    self.tabBarBtn2.selected = NO;
    self.tabBarBtn4.selected = NO;
    self.tabBarBtn5.selected = NO;
    switch (index) {
        case 0:
            self.tabBarBtn1.selected = YES;
            [self.mainTab setSelectedIndex:index];
            break;
            
        case 1:
            self.tabBarBtn2.selected = YES;
            [self.mainTab setSelectedIndex:index];
            break;
            
        case 2:
            [self.mainTab setSelectedIndex:index];
            break;
            
        case 3:
            self.tabBarBtn4.selected = YES;
            [self.mainTab setSelectedIndex:index];
            break;
            
        case 4:
            self.tabBarBtn5.selected = YES;
            [self.mainTab setSelectedIndex:index];
            break;
        default:
            break;
    }
    
    
}
//后台情况下跳转通知
- (void)toNotification{
    //可以直接跳转
    NSArray *remarkArray = @[@"sellercomment",@"buyercomment",@"userapply"];
    SubSellerOrderDetailViewController *sellerManagementTVC = [[SubSellerOrderDetailViewController alloc] init];
    SubBuyerOrderDetailViewController *zzMyOrderVC = [[SubBuyerOrderDetailViewController alloc] init];
    SubSellerEvaluateAViewController *sellerEvaluateListAVC = [[SubSellerEvaluateAViewController alloc] init];
    SubMyEvaluateViewController *myEvaluateListVC = [[SubMyEvaluateViewController alloc] init];
    SubNewFriendsApplyViewController *newFriendsAAVC = [[SubNewFriendsApplyViewController alloc] init];
    NSArray *vcArray = @[sellerEvaluateListAVC,myEvaluateListVC,newFriendsAAVC];
    ZZNavigationController * nac1 = self.mainTab.viewControllers[0];
    ZZNavigationController * nac2 = self.mainTab.viewControllers[1];
    ZZNavigationController * nac3 = self.mainTab.viewControllers[3];
    ZZNavigationController * nac4 = self.mainTab.viewControllers[4];
    [nac1 popToRootViewControllerAnimated:NO];
    [nac2 popToRootViewControllerAnimated:NO];
    [nac3 popToRootViewControllerAnimated:NO];
    [nac4 popToRootViewControllerAnimated:NO];
    
    for (int i = 0; i < remarkArray.count; i ++) {
        if ([self.module isEqualToString:[remarkArray objectAtIndex:i]]){
            MineFragmentViewController * mineVC = nac4.viewControllers[0];
            self.tabBarBtn5.selected = YES;
            self.tabBarBtn1.selected = NO;
            self.tabBarBtn2.selected = NO;
            self.tabBarBtn4.selected = NO;
            
            [self.mainTab setSelectedIndex:4];
            [mineVC.navigationController pushViewController:[vcArray objectAtIndex:i] animated:YES];
        }
    }
    
    //需要跳转是传值
    SubSubdetailViewController *detailAVC = [[SubSubdetailViewController alloc] init];
    SubSublPersonalViewController *persnalVC = [[SubSublPersonalViewController alloc] init];
    SubLocationDetailViewController * locationVc = [[SubLocationDetailViewController alloc]init];

    if ([self.module isEqualToString:@"sellerorder"]) {
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        sellerManagementTVC.orderID = self.value;
        [mineVC.navigationController pushViewController:sellerManagementTVC animated:YES];
    }
    if ([self.module isEqualToString:@"buyerorder"]) {
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        zzMyOrderVC.orderID = self.value;
        [mineVC.navigationController pushViewController:zzMyOrderVC animated:YES];
    }
    if ([self.module isEqualToString:@"userpost"]){
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        detailAVC.idNumber = self.value;
        [mineVC.navigationController pushViewController:detailAVC animated:YES];
    }
    if ([self.module isEqualToString:@"userposition"]){

        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        locationVc.ID = self.value;
        [mineVC.navigationController pushViewController:locationVc animated:YES];
    }
    if ([self.module isEqualToString:@"userinfo"]){
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        persnalVC.invitecode = self.value;
        persnalVC.myRun = @"1";
        NSLog(@"------------------self.value == %@",self.value);
        [mineVC.navigationController pushViewController:persnalVC animated:YES];
    }
    //直接到熟人
    SubMyFriendsViewController *friendsVC = [[SubMyFriendsViewController alloc] init];
    if ([self.module isEqualToString:@"userfriend"]){
        MineFragmentViewController * mineVC = nac3.viewControllers[0];
        self.tabBarBtn4.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn5.selected = NO;
        [self.mainTab setSelectedIndex:3];
        [mineVC.navigationController pushViewController:friendsVC animated:YES];
    }
    SubMyAssureViewController *myAssureVC = [[SubMyAssureViewController alloc] init];
    //跳转时需要改变偏移量
    if ([self.module isEqualToString:@"userguarantee"]){
        myAssureVC.type = @"1";
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        [mineVC.navigationController pushViewController:myAssureVC animated:YES];
    }
    if ([self.module isEqualToString:@"postguarantee"]){
        MineFragmentViewController * mineVC = nac4.viewControllers[0];
        self.tabBarBtn5.selected = YES;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = NO;
        [self.mainTab setSelectedIndex:4];
        [mineVC.navigationController pushViewController:myAssureVC animated:YES];
    }
    if ([self.module isEqualToString:@"userrecommend"]) {
        AddressBookListActivityViewController * addressVC = [[AddressBookListActivityViewController alloc]init];
        LinkManController * friendsVC = nac3.viewControllers[0];
        self.tabBarBtn5.selected = NO;
        self.tabBarBtn1.selected = NO;
        self.tabBarBtn2.selected = NO;
        self.tabBarBtn4.selected = YES;
        [self.mainTab setSelectedIndex:3];
        [friendsVC.navigationController pushViewController:addressVC animated:YES];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知:%@", [self logDic:userInfo]);
//    NSLog(@"RemoteNote userInfo:%@",userInfo);
    NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    NSLog(@"apsapsapsapsaps == %@",alertStr);
    self.module = [userInfo objectForKey:@"module"];
    self.value = [userInfo objectForKey:@"value"];
    ZZNavigationController *nav = self.mainTab.viewControllers[0];
    [self tabbarSelectedIndex:0];
    [HandleNewsCenter handleMsgCenterModule:self.module Value:self.value NavigationController:nav];
    return;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notReadNews" object:nil];
    if ([self.module isEqualToString:@"userfriend"]) {
        [self getFriendArr];
    }
    if (application.applicationState == UIApplicationStateActive) {
        [AutoDismissAlert autoDismissAlertSecond:alertStr];
        if ([self.module isEqualToString:@"userapply"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userapply" object:nil];
        }
    }else{
        ZZNavigationController *nav = self.mainTab.viewControllers[0];
        [self tabbarSelectedIndex:0];
        [HandleNewsCenter handleMsgCenterModule:self.module Value:self.value NavigationController:nav];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error == %@",error);
}

// log NSSet with UTF8
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}



//微信
//<span style="color:#ff6600;">#pragma mark - WX回调
-(BOOL)handleOpenUrl:(NSURL *)url {
    NSString * host = [url host];
    NSString * path = [[url path] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([host isEqualToString:@"userpost"]) {
        ZZNavigationController * nac1 = self.mainTab.viewControllers[0];
        ZZNavigationController * nac2 = self.mainTab.viewControllers[1];
        ZZNavigationController * nac3 = self.mainTab.viewControllers[3];
        ZZNavigationController * nac4 = self.mainTab.viewControllers[4];
        [nac1 popToRootViewControllerAnimated:NO];
        [nac2 popToRootViewControllerAnimated:NO];
        [nac3 popToRootViewControllerAnimated:NO];
        [nac4 popToRootViewControllerAnimated:NO];
        SPListController * shopVC = nac1.viewControllers[1];
        [self tabbarSelectedIndex:1];
        [HandleNewsCenter handleMsgCenterModule:host Value:path NavigationController:shopVC.navigationController];
        return YES;
    }else if ([host isEqualToString:@"usertopic"]) {
        ZZNavigationController * nac1 = self.mainTab.viewControllers[0];
        ZZNavigationController * nac2 = self.mainTab.viewControllers[1];
        ZZNavigationController * nac3 = self.mainTab.viewControllers[3];
        ZZNavigationController * nac4 = self.mainTab.viewControllers[4];
        [nac1 popToRootViewControllerAnimated:NO];
        [nac2 popToRootViewControllerAnimated:NO];
        [nac3 popToRootViewControllerAnimated:NO];
        [nac4 popToRootViewControllerAnimated:NO];
        HomeTopicListController * topicVC = nac1.viewControllers[0];
        [self tabbarSelectedIndex:0];
        [HandleNewsCenter handleMsgCenterModule:host Value:path NavigationController:topicVC.navigationController];
        return YES;
    }else if ([AlipayWrapper handleResult:url] || [WXApi handleOpenURL:url delegate:self]) {
        //客户端支付时回调
        return YES;
    } else{
        return [ShareSDK handleOpenURL:url
                            wxDelegate:self];
    }
}
#pragma mark- 微信支付
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXSuccess" object:nil];
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
    //    [alert release];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleOpenUrl:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenUrl:url];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */



//自定义tabBar
- (void)tabBarClick1:(UIButton *)sender {
    
    self.tabBarBtn1.selected = YES;
    self.tabBarBtn2.selected = NO;
    self.tabBarBtn4.selected = NO;
    self.tabBarBtn5.selected = NO;
    [self.mainTab setSelectedIndex:sender.tag-10001];
    
    //    for (int i=10001; i<=10005; i++) {
    //        UIButton *temp=(UIButton*)[_customTab viewWithTag:i];
    //        [temp setEnabled:temp.tag==sender.tag?NO:YES];
    //    }
}
- (void)tabBarClick2:(UIButton *)sender {
    
    self.tabBarBtn1.selected = NO;
    self.tabBarBtn2.selected = YES;
    self.tabBarBtn4.selected = NO;
    self.tabBarBtn5.selected = NO;
    [self.mainTab setSelectedIndex:sender.tag-10001];
    
}

- (void)tabBarClick4:(UIButton *)sender {
    
    self.tabBarBtn1.selected = NO;
    self.tabBarBtn2.selected = NO;
    self.tabBarBtn4.selected = YES;
    self.tabBarBtn5.selected = NO;
    [self.mainTab setSelectedIndex:sender.tag-10001];
    
}

- (void)tabBarClick5:(UIButton *)sender {
    
    self.tabBarBtn1.selected = NO;
    self.tabBarBtn2.selected = NO;
    self.tabBarBtn4.selected = NO;
    self.tabBarBtn5.selected = YES;
    [self.mainTab setSelectedIndex:sender.tag-10001];
    
}



- (void)creatBtns
{
    
    self.tabBarBtn1 = [CustomTabBarBtn buttonWithType:UIButtonTypeCustom];
    self.tabBarBtn1.frame = CGRectMake(0, 0, SCREEN_WIDTH/5, 49);
    [self.tabBarBtn1 setTitle:@"发现" forState:UIControlStateNormal];
    self.tabBarBtn1.backgroundColor = [UIColor clearColor];
    //    [self.tabBarBtn1 setImage:[UIImage imageNamed:@"guangjie"] forState:UIControlStateHighlighted];
    [self.tabBarBtn1 setImage:[UIImage imageNamed:@"zuji+"] forState:UIControlStateNormal];
    [self.tabBarBtn1 setImage:[UIImage imageNamed:@"zuji"] forState:UIControlStateSelected];
    self.tabBarBtn1.tag = 10001;
    self.tabBarBtn1.selected = YES;
    [self.tabBarBtn1 addTarget:self action:@selector(tabBarClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTab addSubview:self.tabBarBtn1];
    
    self.tabBarBtn2 = [CustomTabBarBtn buttonWithType:UIButtonTypeCustom];
    self.tabBarBtn2.frame = CGRectMake(SCREEN_WIDTH/5, 0, SCREEN_WIDTH/5, 49);
    [self.tabBarBtn2 setTitle:@"求购" forState:UIControlStateNormal];
    self.tabBarBtn2.backgroundColor = [UIColor clearColor];
    //    [self.tabBarBtn2 setImage:[UIImage imageNamed:@"zuji"] forState:UIControlStateHighlighted];
    [self.tabBarBtn2 setImage:[UIImage imageNamed:@"guangjie+"] forState:UIControlStateNormal];
    [self.tabBarBtn2 setImage:[UIImage imageNamed:@"guangjie"] forState:UIControlStateSelected];
    self.tabBarBtn2.tag = 10002;
    [self.tabBarBtn2 addTarget:self action:@selector(tabBarClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTab addSubview:self.tabBarBtn2];
    
    
    self.tabBarImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 49/2, 0, 49, 49)];
    self.tabBarImageV.image = [UIImage imageNamed:@"fabu+"];
    self.tabBarImageV.userInteractionEnabled = YES;
    [self.customTab addSubview:self.tabBarImageV];
    UITapGestureRecognizer *tabBarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarTapMothed:)];
    [self.tabBarImageV addGestureRecognizer:tabBarTap];
    
    
    self.tabBarBtn4 = [CustomTabBarBtn buttonWithType:UIButtonTypeCustom];
    self.tabBarBtn4.frame = CGRectMake(SCREEN_WIDTH/5 * 3, 0, SCREEN_WIDTH/5, 49);
    [self.tabBarBtn4 setTitle:@"熟人" forState:UIControlStateNormal];
    self.tabBarBtn4.backgroundColor = [UIColor clearColor];
    //    [self.tabBarBtn4 setImage:[UIImage imageNamed:@"shuren"] forState:UIControlStateHighlighted];
    [self.tabBarBtn4 setImage:[UIImage imageNamed:@"shuren+"] forState:UIControlStateNormal];
    [self.tabBarBtn4 setImage:[UIImage imageNamed:@"shuren"] forState:UIControlStateSelected];
    self.tabBarBtn4.tag = 10004;
    [self.tabBarBtn4 addTarget:self action:@selector(tabBarClick4:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTab addSubview:self.tabBarBtn4];
    
    self.tabBarBtn5 = [CustomTabBarBtn buttonWithType:UIButtonTypeCustom];
    self.tabBarBtn5.frame = CGRectMake(SCREEN_WIDTH/5 * 4, 0, SCREEN_WIDTH/5, 49);
    [self.tabBarBtn5 setTitle:@"我的" forState:UIControlStateNormal];
    self.tabBarBtn5.backgroundColor = [UIColor clearColor];
    [self.tabBarBtn5 setImage:[UIImage imageNamed:@"wode+"] forState:UIControlStateNormal];
    [self.tabBarBtn5 setImage:[UIImage imageNamed:@"wode"] forState:UIControlStateSelected];
    self.tabBarBtn5.tag = 10005;
    [self.tabBarBtn5 addTarget:self action:@selector(tabBarClick5:) forControlEvents:UIControlEventTouchUpInside];
    [self.customTab addSubview:self.tabBarBtn5];
    
    //新的熟人
    self.newwFriendView = [[UIImageView alloc] initWithFrame:CGRectMake(44, 5, 8, 8)];
    self.newwFriendView.image = [UIImage imageNamed:@"newfriend_notic"];
    self.newwFriendView.hidden = YES;
    [self.tabBarBtn4 addSubview:self.newwFriendView];
    
    //足迹变化提示
    self.footerPrintView = [[UIImageView alloc] initWithFrame:CGRectMake(44, 5, 8, 8)];
    self.footerPrintView.image = [UIImage imageNamed:@"newfriend_notic"];
    self.footerPrintView.hidden = YES;
    [self.tabBarBtn2 addSubview:self.footerPrintView];
    
    //新消息提示
    self.signView = [[UIImageView alloc] init];
    //WithFrame:CGRectMake(44, 5, 8, 8)];
    self.signView.hidden = YES;
    [self.tabBarBtn4 addSubview:self.signView];
    
    self.signLabel = [[UILabel alloc] init];
    self.signLabel.textAlignment = NSTextAlignmentCenter;
    self.signLabel.font = SIZE_FOR_12;
    self.signLabel.textColor = [UIColor whiteColor];
    self.signLabel.backgroundColor = [UIColor clearColor];
    [self.signView addSubview:self.signLabel];
    
    //新版本提示
    self.versionSignView = [[UIImageView alloc] initWithFrame:CGRectMake(44, 5, 8, 8)];
    self.versionSignView.image = [UIImage imageNamed:@"newfriend_notic"];
    self.versionSignView.hidden = YES;
    [self.tabBarBtn5 addSubview:self.versionSignView];
    
}

//总消息数
- (void)getNewNewsCount
{
    NSInteger count = [[RCIM sharedRCIM] getTotalUnreadCount];
    if (count > 0 && count < 10) {
            self.signView.hidden = NO;
            self.signView.image = [UIImage imageNamed:@"newUnreadMessageCount1"];
            [self reSetFrame:18];
            self.signLabel.text = [NSString stringWithFormat:@"%ld",count];
        }else if(count >= 10 && count < 100){
            self.signView.hidden = NO;
            self.signView.image = [UIImage imageNamed:@"newUnreadMessageCount2"];
            [self reSetFrame:23];
            self.signLabel.text = [NSString stringWithFormat:@"%ld",count];
        }else if (count >=100){
            self.signView.hidden = NO;
            self.signView.image = [UIImage imageNamed:@"newUnreadMessageCount3"];
            [self reSetFrame:29];
            self.signLabel.text = @"99+";
        }else{
            self.signView.hidden = YES;
            self.signLabel.text = @"0";
        }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewNewsCountNF" object:nil userInfo:@{@"count": [NSString stringWithFormat:@"%ld", count]}];
}

- (void)reSetFrame:(int)width
{
    self.signView.frame = CGRectMake(38, 0, width, 18);
    self.signLabel.frame = CGRectMake(0, 0-1, width, 18);
}

- (void)tabBarTapMothed:(UITapGestureRecognizer *)tap
{
    //旋转动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    CGAffineTransform transform = CGAffineTransformMakeRotation(0.75*M_PI);
    self.tabBarImageV.transform = transform;
    [UIView commitAnimations];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        _blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        
        float y1 = blur_y1;
        float y2 = blur_y2;
        [UIView animateWithDuration:0.3 animations:^{
            footerButton.center = CGPointMake(runLabel.center.x, y1);
            topicButton.center = CGPointMake(buyLabel.center.x, y1);
            buyButton.center = CGPointMake(saleLabel.center.x, y1);
            
//            saleButton.center = CGPointMake(saleLabel.center.x, y1);
//            runButton.center = CGPointMake(runLabel.center.x, y1);
            
            inviteButton.center = CGPointMake(runLabel.center.x, y2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                footerButton.center = CGPointMake(runLabel.center.x+5, y1+5);
                topicButton.center = CGPointMake(buyLabel.center.x-5, y1+5);
                buyButton.center = CGPointMake(saleLabel.center.x-5, y1+5);
                
//                buyButton.center = CGPointMake(buyLabel.center.x + 5, y1 + 5);
//                saleButton.center = CGPointMake(saleLabel.center.x, y1 + 5);
//                runButton.center = CGPointMake(runLabel.center.x - 5, y1 + 5);
//                topicButton.center = CGPointMake(buyLabel.center.x - 5, y2 + 5);
//                footerButton.center = CGPointMake(saleLabel.center.x - 5, y2 + 5);
//                inviteButton.center = CGPointMake(runLabel.center.x - 5, y2 + 5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    footerButton.center = CGPointMake(runLabel.center.x, y1 );
                    //saleButton.center = CGPointMake(saleLabel.center.x, y1 );
                    //runButton.center = CGPointMake(runLabel.center.x, y1);
                    topicButton.center = CGPointMake(buyLabel.center.x, y1);
                    buyButton.center = CGPointMake(saleLabel.center.x, y1);
                    //inviteButton.center = CGPointMake(runLabel.center.x, y2);
                }];
            }];
        }];
    });
    
    [[WQGuideView share] showAtIndex:1 GuideViewRemoveBlock:nil];
}

- (void)blurTapMothed:(UITapGestureRecognizer *)tap
{
    //旋转动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelay:0.0];
    CGAffineTransform transform = CGAffineTransformMakeRotation(2*M_PI);
    self.tabBarImageV.transform = transform;
    
    [UIView commitAnimations];
    
    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    
    float y1 = blur_y1;
    float y2 = blur_y2;
    [UIView beginAnimations:@"_blurView1" context:nil];
    [UIView setAnimationDuration:0.3];
    footerButton.center = CGPointMake(runLabel.center.x - 30, y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurView2" context:nil];
    [UIView setAnimationDuration:0.3];
    saleButton.center = CGPointMake(saleLabel.center.x, y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurView3" context:nil];
    [UIView setAnimationDuration:0.3];
    runButton.center = CGPointMake(runLabel.center.x - 30, y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurView4" context:nil];
    [UIView setAnimationDuration:0.3];
    topicButton.center = CGPointMake(buyLabel.center.x + 30, y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurView5" context:nil];
    [UIView setAnimationDuration:0.3];
    buyButton.center = CGPointMake(saleLabel.center.x, y1);
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"_blurView5" context:nil];
    [UIView setAnimationDuration:0.3];
    inviteButton.center = CGPointMake(runLabel.center.x - 30, y2);
    [UIView commitAnimations];
}

//检测版本更新
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%d",APP_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *results = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [self dictionaryWithJsonString:results];
        
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if (![lastVersion isEqualToString:currentVersion]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新的版本更新，是否前往更新？" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
            }else{
            }
        }
    }];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager * mgr = [SDWebImageManager sharedManager];
    //取消下载
    [mgr cancelAll];
    //清除内容中的所有图片
    [mgr.imageCache clearMemory];
}

//JSON字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败:%@",err);
        return nil;
    }
    return dic;
}
#pragma mark- 登录alertview
//显示登录alertview
-(void)showLoginAlertView {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录，是否立即登录" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self presentLoginStoryboard];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，是否立即登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即登录", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [self presentLoginStoryboard];
            break;
        }
        default:
            break;
    }
}
-(void)presentLoginStoryboard {
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
    [self.window.rootViewController presentViewController:loginNC animated:YES completion:^{}];
}
#pragma mark- 登录alertview
////显示登录alertview
//-(void)showLoginAlertView {
//    
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//            //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录，是否立即登录" preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"立即登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                [self presentLoginStoryboard];
//            }]];
//            
//            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                
//            }]];
//            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//            
//            
//        }else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，是否立即登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即登录", nil];
//            [alert show];
//        }
//    
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    switch (buttonIndex) {
//        case 1:{
//            [self presentLoginStoryboard];
//            break;
//        }
//        default:
//            break;
//    }
//}
//-(void)presentLoginStoryboard {
//    ZZNavigationController * tempNC = (ZZNavigationController *)self.mainTab.viewControllers[0];
//    LoginViewController * loginVC = [[LoginViewController alloc]init];
//    ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
//    HomeTopicListController * shoppingVC = tempNC.viewControllers[0];
//    [shoppingVC presentViewController:loginNC animated:NO completion:nil];
//}
@end
