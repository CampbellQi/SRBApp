//
//  TopicToGoodsController.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SPAndShoppingScrollController.h"
//求购列表
#import "SPListController.h"
#import "NewShoppingViewController.h"
#import "UIColor+Dice.h"
#import "LoginViewController.h"

@interface SPAndShoppingScrollController ()
{
    UIButton *_btn1;
    UIButton *_btn2;
    UIScrollView *_mainSV;
    UILabel *_lineLbl;
    CDRTranslucentSideBar * rightSideBar;
    NewRightSideBarViewController * rightSideBarVC;
    
    UIButton * rightBtn;
    UIButton * changeBtn;
    
    NewShoppingViewController *_shoppingVC;
}
@end

@implementation SPAndShoppingScrollController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    //self.view.backgroundColor = [UIColor redColor];
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
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    SPListController *nsvc = [sb instantiateViewControllerWithIdentifier:@"SPListController"];
    nsvc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, sv.height);
    [sv addSubview:nsvc.view];
    [self addChildViewController:nsvc];
    
    NewShoppingViewController *nsvc2 = [[NewShoppingViewController alloc] init];
    nsvc2.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, sv.height);
    [sv addSubview:nsvc2.view];
    [self addChildViewController:nsvc2];
    _shoppingVC = nsvc2;
    
    //导航栏
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    self.navigationItem.titleView = iv;
    //iv.backgroundColor = [UIColor yellowColor];
    
    float btnHeight = iv.height;
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, btnHeight)];
    [btn1 setTitle:@"求 购" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor diceColorWithRed:252 green:106 blue:165 alpha:1] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [iv addSubview:btn1];
    btn1.selected = YES;
    [btn1 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    _btn1 = btn1;
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.x + btn1.width, 0, 90, btnHeight)];
    [btn2 setTitle:@"行 程" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor diceColorWithRed:252 green:106 blue:165 alpha:1] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [iv addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    _btn2 = btn2;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(btn1.x + (btn1.width - 40)/2, btnHeight-10, 40, 2)];
    lbl.backgroundColor = [UIColor whiteColor];
    [iv addSubview:lbl];
    _lineLbl = lbl;
    
    //侧滑
    rightSideBar = [[CDRTranslucentSideBar alloc]initWithDirection:YES];
    rightSideBar.sideBarWidth = 160;
    rightSideBar.animationDuration = 0.3f;
    rightSideBar.translucentAlpha = 1;
    rightSideBar.delegate = self;
    rightSideBar.view.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
    rightSideBar.view.layer.shadowOpacity = 0.6;
    rightSideBar.view.layer.shadowOffset = CGSizeMake(-4, 3);
    
    rightSideBarVC = [[NewRightSideBarViewController alloc]init];
    rightSideBarVC.rightSideBar = rightSideBar;
    rightSideBarVC.shoppingVC = _shoppingVC;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shopping_filter"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn addTarget:_shoppingVC action:@selector(shaiXuan:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(0, 0, 25, 25);
    [changeBtn addTarget:_shoppingVC action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    rightBtn.hidden = YES;
    changeBtn.hidden = YES;
}
#pragma mark- 事件
-(void)showBtn1View {
    _btn1.selected = YES;
    _btn2.selected = NO;
    [_lineLbl setOrigin:CGPointMake(_btn1.x + (_btn1.width - 40)/2, _lineLbl.y)];
    
    [_shoppingVC huanYuan];
    
    rightBtn.hidden = YES;
    changeBtn.hidden = YES;
}
-(void)showBtn2View {
    _btn2.selected = YES;
    _btn1.selected = NO;
    [_lineLbl setOrigin:CGPointMake(_btn2.x + (_btn2.width - 40)/2, _lineLbl.y)];
    
    rightBtn.hidden = NO;
    changeBtn.hidden = NO;
}
- (void)btn1Clicked:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self showBtn1View];
        [_mainSV setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)btn2Clicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self showBtn2View];
        [_mainSV setContentOffset:CGPointMake(_mainSV.frame.size.width, 0) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_mainSV.contentOffset.x == 0){
        [self showBtn1View];
    }else {
        [self showBtn2View];
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
