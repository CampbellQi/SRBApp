//
//  DynamicViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/15.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "DynamicViewController.h"
#import "LoginViewController.h"
#import "LKPageView.h"
#import "ZZMyOrderViewController.h"
#import "SellerManagementViewController.h"
#import "ZZNavigationController.h"
#import "BrowsingHistoryViewController.h"
#import "MyEvaluateListViewController.h"
//#import "FriendFragmentViewController.h"
#import "FriendsViewController.h"
#import "FansViewController.h"
#import "ImpressionViewController.h"

#define SHARE_URL @"http://www.shurenbang.net"
#import "APService.h"
#import <CoreLocation/CoreLocation.h>
#import "PersonalViewController.h"
#import "FootPrintViewController.h"
#import "SquareViewController.h"



@interface DynamicViewController ()


@end

@implementation DynamicViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray * pagearray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1; i <=5; i++) {
        [pagearray addObject:[NSString stringWithFormat:@"page_%d",i]];
    }
    
    LKPageView * page= [[LKPageView alloc]initWithPathStringArray:pagearray andFrame:CGRectMake(0, 50,SCREEN_WIDTH , 40)];
    [self.view addSubview:page];
    
    UIButton * order = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [order setTitle:@"订单" forState:UIControlStateNormal];
    order.frame  = CGRectMake(20, 150, 40, 30);
    [self.view addSubview:order];
    [order addTarget:self action:@selector(order:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * seller = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [seller setTitle:@"管理" forState:UIControlStateNormal];
    seller.frame  = CGRectMake(80, 150, 40, 30);
    [self.view addSubview:seller];
    [seller addTarget:self action:@selector(seller:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * history = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [history setTitle:@"历史" forState:UIControlStateNormal];
    history.frame  = CGRectMake(140, 150, 40, 30);
    [self.view addSubview:history];
    [history addTarget:self action:@selector(history:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * myPingjia = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [myPingjia setTitle:@"我的评价" forState:UIControlStateNormal];
    myPingjia.frame  = CGRectMake(200, 150, 60, 30);
    [self.view addSubview:myPingjia];
    [myPingjia addTarget:self action:@selector(myPingjia:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * friend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [friend setTitle:@"熟人" forState:UIControlStateNormal];
    friend.frame  = CGRectMake(260, 150, 40, 30);
    [self.view addSubview:friend];
    [friend addTarget:self action:@selector(friend:) forControlEvents:UIControlEventTouchUpInside];
    

    UIButton * location = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [location setTitle:@"足迹" forState:UIControlStateNormal];
    location.frame  = CGRectMake(20, 200, 40, 30);
    [self.view addSubview:location];
    [location addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * fans = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fans setTitle:@"粉丝" forState:UIControlStateNormal];
    fans.frame  = CGRectMake(80, 200, 40, 30);
    [self.view addSubview:fans];
    [fans addTarget:self action:@selector(fans:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * impression = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [impression setTitle:@"印象" forState:UIControlStateNormal];
    impression.frame  = CGRectMake(140, 200, 40, 30);
    [self.view addSubview:impression];
    [impression addTarget:self action:@selector(impression:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * person = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [person setTitle:@"个人" forState:UIControlStateNormal];
    person.frame  = CGRectMake(200, 200, 40, 30);
    [self.view addSubview:person];
    [person addTarget:self action:@selector(person:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * square = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [square setTitle:@"广场" forState:UIControlStateNormal];
    square.frame  = CGRectMake(260, 200, 40, 30);
    [self.view addSubview:square];
    [square addTarget:self action:@selector(square:) forControlEvents:UIControlEventTouchUpInside];

    //shareTest
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(200, 300, 100, 100);
    [shareBtn setImage:[UIImage imageNamed:@"icon_detail_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareToAnyPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];

  
    NSLog(@"%@",USER_CONFIG_PATH);
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self isLogin];
}

- (void)isLogin
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    //判断是否是第一次运行
    if (dic == nil) {
        dic = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"first"];
        LoginViewController * loginVC =  [[LoginViewController alloc]init];
        ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];

        [self presentViewController:loginNC animated:NO completion:nil];
    }else{
        //如果未登录,则跳转到登录界面
        if ([dic objectForKey:@"isLogin"]) {
            LoginViewController * loginVC =  [[LoginViewController alloc]init];
            ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
            
            [self presentViewController:loginNC animated:NO completion:nil];
            
        }
    }
}

- (void)square:(UIButton *)sender
{
    SquareViewController * squareVC = [[SquareViewController alloc]init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

- (void)person:(UIButton *)sender
{
    PersonalViewController * personVC = [[PersonalViewController alloc]init];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)fans:(UIButton *)sender
{
    FansViewController * fansVC = [[FansViewController alloc]init];
    [self.navigationController pushViewController:fansVC animated:YES];
}
- (void)impression:(UIButton *)sender
{
    ImpressionViewController * impressionVC = [[ImpressionViewController alloc]init];
    [self.navigationController pushViewController:impressionVC animated:YES];
}

- (void)location:(UIButton *)sender
{
    FootPrintViewController * locationVC = [[FootPrintViewController alloc]init];
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)friend:(UIButton *)sender
{
    FriendsViewController * friendVC = [[FriendsViewController alloc]init];
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (void)myPingjia:(UIButton *)sender
{
    MyEvaluateListViewController * myEvaluateVC = [[MyEvaluateListViewController alloc]init];
    [self.navigationController pushViewController:myEvaluateVC animated:YES];
}

- (void)seller:(UIButton *)seller
{
    SellerManagementViewController * sellerVC = [[SellerManagementViewController alloc]init];
    [self.navigationController pushViewController:sellerVC animated:YES];
}

- (void)order:(UIButton *)sender
{
    ZZMyOrderViewController * orderVC = [[ZZMyOrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)history:(UIButton *)sender
{
    BrowsingHistoryViewController * browsingVC = [[BrowsingHistoryViewController alloc]init];
    [self.navigationController pushViewController:browsingVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
