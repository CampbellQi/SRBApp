//
//  IWantToAssureViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "IWantToAssureViewController.h"
#import "GoodAssureViewController.h"
#import "OrderAssureViewController.h"
#import "AppDelegate.h"

@interface IWantToAssureViewController ()

@property (nonatomic, strong) GoodAssureViewController *myAssureGoodsTVC;
@property (nonatomic, strong) OrderAssureViewController *myAssureOrdersTVC;

@end

@implementation IWantToAssureViewController
{
    BOOL secondVC;
    BOOL isisBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"担保挣钱";
    
    
    // Do any additional setup after loading the view.
}

- (void)backBtn:(UIButton *)sender
{
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
    isisBack = YES;
    [self.navigationController dismissViewController];
}

#pragma mark - 初始化控件
- (void)customInit
{
//    //顶部背景
//    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
//    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#eeeeee"].CGColor;
//    topBGView.layer.shadowOpacity = 2;
//    topBGView.layer.shadowOffset = CGSizeMake(0, 2);
//    topBGView.layer.shadowRadius = 2;
//    [self.view addSubview:topBGView];
//    
//    //商品按钮
//    goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    goodsBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
//    [goodsBtn setTitle:@"商品担保" forState:UIControlStateNormal];
//    [goodsBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
//    [goodsBtn addTarget:self action:@selector(goodsBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [goodsBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
//    goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    goodsBtn.selected = YES;
//    [topBGView addSubview:goodsBtn];
//    
//    //订单按钮
//    ordersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    ordersBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
//    [ordersBtn setTitle:@"订单担保" forState:UIControlStateNormal];
//    [ordersBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
//    [ordersBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
//    ordersBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [ordersBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
//    [topBGView addSubview:ordersBtn];
//    
//    
//    //底部横线
//    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH / 2, 1.5)];
//    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
//    [topBGView addSubview:lineView];
//    
//    //scrollerView
//    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y - 1, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
//    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 40);
//    self.sv.pagingEnabled = YES;
//    self.sv.delegate = self;
//    self.sv.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:self.sv];
    
    self.myAssureGoodsTVC = [[GoodAssureViewController alloc]init];
    self.myAssureGoodsTVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.myAssureGoodsTVC.view];
    [self addChildViewController:self.myAssureGoodsTVC];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.myAssureGoodsTVC urlRequestPost];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    if (isisBack) {
//        [self.myAssureOrdersTVC removeFromParentViewController];
//        [self.myAssureOrdersTVC.view removeFromSuperview];
//        [self.myAssureGoodsTVC removeFromParentViewController];
//        [self.myAssureGoodsTVC.view removeFromSuperview];
//    }
}

#pragma mark - 三个button点击事件
- (void)goodsBtn:(UIButton *)sender
{
    ordersBtn.selected = NO;
    goodsBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.myAssureGoodsTVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    goodsBtn.selected = NO;
    ordersBtn.selected = YES;
    if (!secondVC) {
        [self.sv addSubview:self.myAssureOrdersTVC.view];
        [self addChildViewController:self.myAssureOrdersTVC];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, ordersBtn.frame.size.height + ordersBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.myAssureOrdersTVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        ordersBtn.selected = NO;
        goodsBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self.myAssureGoodsTVC urlRequestPost];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        goodsBtn.selected = NO;
        ordersBtn.selected = YES;
        if (!secondVC) {
            [self.sv addSubview:self.myAssureOrdersTVC.view];
            [self addChildViewController:self.myAssureOrdersTVC];
            secondVC = YES;
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, ordersBtn.frame.size.height + ordersBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self.myAssureOrdersTVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
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
