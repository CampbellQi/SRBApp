//
//  MyAssureViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyAssureViewController.h"


@interface MyAssureViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MyAssureViewController
{
    BOOL secondVC;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    self.title = @"我的担保";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self customInit];
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (down_IOS_8) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        [self.myAssureGoodsTVC removeFromParentViewController];
        [self.myAssureGoodsTVC.view removeFromSuperview];
        [self.myAssureOrdersTVC removeFromParentViewController];
        [self.myAssureOrdersTVC.view removeFromSuperview];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化控件
- (void)customInit
{
    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    //商品按钮
    goodsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [goodsBtn setTitle:@"我担保的商品" forState:UIControlStateNormal];
    [goodsBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [goodsBtn addTarget:self action:@selector(goodsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [goodsBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    goodsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    goodsBtn.selected = YES;
    [topBGView addSubview:goodsBtn];
    
    //订单按钮
    ordersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ordersBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [ordersBtn setTitle:@"我担保的订单" forState:UIControlStateNormal];
    [ordersBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [ordersBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    ordersBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ordersBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:ordersBtn];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH / 2, 1.5)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y - 1, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 40);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.sv];
    
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    
    self.myAssureGoodsTVC = [[MyAssureGoodsViewController alloc]init];
    self.myAssureGoodsTVC.tableView.frame = CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y-40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    [self.sv addSubview:self.myAssureGoodsTVC.view];
    [self addChildViewController:self.myAssureGoodsTVC];
    
    self.myAssureOrdersTVC = [[MyAssureOrdersViewController alloc]init];
    self.myAssureOrdersTVC.tableView.frame = CGRectMake(SCREEN_WIDTH, topBGView.frame.size.height + topBGView.frame.origin.y-40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    [self.view addSubview:topBGView];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    
//    //检测单击事件
//    if (gestureRecognizer == _leftGestureRecognizer && [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        NSLog(@"UITableViewCellContentView");
//        return YES;
//    }
//    if (gestureRecognizer == _tapGestureRecognizer && [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        NSLog(@"UITableViewCellContentView");
//        return YES;
//    }
//    if (gestureRecognizer == _rightGestureRecognizer && [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        NSLog(@"UITableViewCellContentView");
//        return YES;
//    }
//    return NO;
//}

#pragma mark - 三个button点击事件
- (void)goodsBtn:(UIButton *)sender
{
    ordersBtn.selected = NO;
    goodsBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.myAssureGoodsTVC.tableView headerBeginRefreshing];
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
    [self.myAssureOrdersTVC.tableView headerBeginRefreshing];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.sv.contentOffset.x == 0) {
        ordersBtn.selected = NO;
        goodsBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, goodsBtn.frame.size.height + goodsBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        //[self.myAssureGoodsTVC urlRequestPost];
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
        //[self.myAssureOrdersTVC urlRequestPost];
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
