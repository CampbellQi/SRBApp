//
//  TopicToGoodsController.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LinkManController.h"
#import "FriendsViewController.h"
#import "NewLocationViewController.h"
#import "FriendMoreViewController.h"
#import "UIColor+Dice.h"
#import "LoginViewController.h"

@interface LinkManController ()
{
    UIButton *_footerBtn;
    UIButton *_friendsBtn;
    UIScrollView *_mainSV;
    UILabel *_lineLbl;
    CDRTranslucentSideBar * rightSideBar;
    NewRightSideBarViewController * rightSideBarVC;
    NewShoppingViewController *_newShoppingVC;
    BOOL isShow;
    UIButton *_moreBtn;
    FriendsViewController *_friendsVC;
}
@end

@implementation LinkManController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    
    if (dic == nil) {
        NSDictionary * versionDic = [[NSBundle mainBundle] infoDictionary];
        dic = [NSMutableDictionary dictionary];
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        [dic setObject:[versionDic objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    }else{
        
        NSString * oldYear = [dic objectForKey:@"year"];
        NSString * oldMonth = [dic objectForKey:@"month"];
        NSString * oldDay = [dic objectForKey:@"day"];
        
        NSDate *  senddate=[NSDate date];
        NSCalendar  * cal=[NSCalendar  currentCalendar];
        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
        
        NSString * year = [NSString stringWithFormat:@"%ld",(long)[conponent year]];
        NSString * month = [NSString stringWithFormat:@"%ld",(long)[conponent month]];
        NSString * day = [NSString stringWithFormat:@"%ld",(long)[conponent day]];
        
        [dic setObject:year forKey:@"year"];
        [dic setObject:month forKey:@"month"];
        [dic setObject:day forKey:@"day"];
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
        //将登录状态写入配置文件
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        if (([year intValue] - [oldYear intValue]) * 365 + ([month intValue] - [oldMonth intValue])* 30 + [day intValue] - [oldDay intValue] > 7 && oldYear > 0) {
            [AutoDismissAlert autoDismissAlert:@"账号已过期,请重新登录!"];
            [dic setObject:@"0" forKey:@"isLogin"];
            [dic writeToFile:USER_CONFIG_PATH atomically:YES];
            [self presentViewController:loginNC animated:NO completion:nil];
            //                [self setNoLoginState];
        }else{
            if ([[dic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
            }else{
                //                    [self setNoLoginState];
                [self presentViewController:loginNC animated:NO completion:nil];
            }
        }
    }
    
    //    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    //    if ([dataDic objectForKey:@"shopping"]== nil) {
    //        [dataDic setObject:@"1" forKey:@"shopping"];
    //        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
    //        static dispatch_once_t token;
    //        dispatch_once(&token, ^{
    //            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(seeFinished) userInfo:nil repeats:YES];
    //        });
    //        
    //    }
}
#pragma mark- 页面
-(void)setUpView {
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [changeBtn setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
//    changeBtn.frame = CGRectMake(0, 0, 25, 25);
//    [changeBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    //滑动主页
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAIN_NAV_HEIGHT)];
    sv.contentSize = CGSizeMake(sv.width * 2, 0);
    [self.view addSubview:sv];
    sv.pagingEnabled = YES;
    sv.delegate = self;
    _mainSV = sv;
  
    NewLocationViewController *nsvc = [[NewLocationViewController alloc] init];
    nsvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, sv.height);
    [sv addSubview:nsvc.view];
    [self addChildViewController:nsvc];
    
    FriendsViewController *nsvc2 = [[FriendsViewController alloc] init];
    nsvc2.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, sv.height);
    [sv addSubview:nsvc2.view];
    [self addChildViewController:nsvc2];
    _friendsVC = nsvc2;
    //_newShoppingVC = nsvc2;
    
    //导航栏
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    self.navigationItem.titleView = iv;
    //iv.backgroundColor = [UIColor yellowColor];
    
    float btnHeight = iv.height;
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, btnHeight)];
    [footerBtn setTitle:@"足 迹" forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor diceColorWithRed:252 green:106 blue:165 alpha:1] forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [iv addSubview:footerBtn];
    footerBtn.selected = YES;
    [footerBtn addTarget:self action:@selector(footerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _footerBtn = footerBtn;
    
    UIButton *friendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(footerBtn.x + footerBtn.width, 0, 90, btnHeight)];
    [friendsBtn setTitle:@"熟 人" forState:UIControlStateNormal];
    [friendsBtn setTitleColor:[UIColor diceColorWithRed:252 green:106 blue:165 alpha:1] forState:UIControlStateNormal];
    [friendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [iv addSubview:friendsBtn];
    [friendsBtn addTarget:self action:@selector(friendsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _friendsBtn = friendsBtn;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(footerBtn.x + (footerBtn.width - 40)/2, btnHeight-10, 40, 2)];
    lbl.backgroundColor = [UIColor whiteColor];
    [iv addSubview:lbl];
    _lineLbl = lbl;

    //导航栏
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, 0, 20, 20);
    [_moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_moreBtn];
    self.navigationItem.leftBarButtonItem = nil;
    _moreBtn.hidden = YES;
}
//- (void)seeLogin
//{
//    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
//    //NSString * isFinished = [dataDic objectForKey:@"finished"];
//    NSString * isLogin = [dataDic objectForKey:@"isLogin"];
//    if ([isLogin isEqualToString:@"1"]) {
//        //[timer invalidate];
//        //[[[UIApplication sharedApplication].windows lastObject] addSubview:self.bgViews];
//    }
//}
#pragma mark- 事件
#pragma mark - 右上角button
- (void)more:(UIButton *)sender
{
    //    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] isEqualToString:GUEST]) {
    //        FriendMoreViewController * moreVC = [[FriendMoreViewController alloc]init];
    //        moreVC.array = @[@"意见反馈"];
    //        moreVC.imgArr = @[@"fankui"];
    //        [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
    //        [self addChildViewController:moreVC];
    //    }else{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
    FriendMoreViewController * moreVC = [[FriendMoreViewController alloc]init];
    moreVC.array = @[@"发现熟人",@"邀请熟人",@"扫 一 扫"];
    moreVC.imgArr = @[@"faxian",@"yaoqinghaoyou",@"TwoDimensionCode"];
    [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
    [self addChildViewController:moreVC];
    
        }
}
-(void)showFooterView {
    _footerBtn.selected = YES;
    _friendsBtn.selected = NO;
    _moreBtn.hidden = YES;
    [_lineLbl setOrigin:CGPointMake(_footerBtn.x + (_footerBtn.width - 40)/2, _lineLbl.y)];
}
-(void)showFriendsView {
    _friendsBtn.selected = YES;
    _footerBtn.selected = NO;
    _moreBtn.hidden = NO;
    [_lineLbl setOrigin:CGPointMake(_friendsBtn.x + (_friendsBtn.width - 40)/2, _lineLbl.y)];
    [_friendsVC showGuideView];
}
- (void)footerBtnClicked:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self showFooterView];
        [_mainSV setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)friendsBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self showFriendsView];
        [_mainSV setContentOffset:CGPointMake(_mainSV.frame.size.width, 0) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_mainSV.contentOffset.x == 0){
        [self showFooterView];
    }else {
        [self showFriendsView];
    }
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
