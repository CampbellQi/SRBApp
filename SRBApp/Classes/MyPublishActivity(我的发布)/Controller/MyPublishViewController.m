//
//  MyPublishViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyPublishViewController.h"
#import "HadPublishViewController.h"
#import "NotPublishViewController.h"
#import "HadNotViewController.h"
#import "AppDelegate.h"
#import "SaleListViewController.h"

@interface MyPublishViewController ()
{
    BOOL isBack;
    BOOL secondVC;
    BOOL thirdVC;
    int page;
    int tempPage;
}
@property (nonatomic, strong) HadPublishViewController *hadPublishVC;
@property (nonatomic, strong) NotPublishViewController *notPublishVC;
@property (nonatomic, strong) HadNotViewController *hadNotPublishVC;

@end

@implementation MyPublishViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
    [self customInit];
    if ([_dealType isEqualToString:@"1"] ||[_thedealType isEqualToString:@"1"]) {
        self.title = @"我的宝贝";
    }else{
        self.title = @"我的求购";
    }
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    //    //添加屏幕边缘手势
    //    UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
    //    //    popSwipe.delegate = self;
    //    [popSwipe setEdges:UIRectEdgeLeft];
    
    if (([_thedealType isEqualToString:@"1"] && ![self.notPublishType isEqualToString:@"1"]) || ([_thedealType isEqualToString:@"2"] && ![self.notPublishType isEqualToString:@"1"])) {
        //手动取消pop动画
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }else if([self.notPublishType isEqualToString:@"1"]){
        //手动取消pop动画
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }else{
        if (down_IOS_8) {
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    
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
        [self.hadPublishVC removeFromParentViewController];
        [self.hadNotPublishVC removeFromParentViewController];
        [self.notPublishVC removeFromParentViewController];
        [self.hadNotPublishVC.view removeFromSuperview];
        [self.notPublishVC.view removeFromSuperview];
        [self.hadPublishVC.view removeFromSuperview];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    if (([_thedealType isEqualToString:@"1"] && ![self.notPublishType isEqualToString:@"1"]) || ([_thedealType isEqualToString:@"2"] && ![self.notPublishType isEqualToString:@"1"])) {
        AppDelegate *app = APPDELEGATE;
        SaleListViewController * saleListVC = self.navigationController.viewControllers.firstObject;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [saleListVC.navigationController dismissViewController];
        app.tabBarBtn1.selected = YES;
        app.tabBarBtn2.selected = NO;
        app.tabBarBtn4.selected = NO;
        app.tabBarBtn5.selected = NO;
        app.customTab.hidden = NO;
        [app.mainTab setSelectedIndex:0];
    }else if([self.notPublishType isEqualToString:@"1"]){
        AppDelegate *app = APPDELEGATE;
        SaleListViewController * saleListVC = self.navigationController.viewControllers.firstObject;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [saleListVC.navigationController dismissViewController];
        app.tabBarBtn2.selected = NO;
        app.tabBarBtn4.selected = NO;
        app.tabBarBtn5.selected = NO;
        app.tabBarBtn1.selected = YES;
        app.customTab.hidden = NO;
        [app.mainTab setSelectedIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
{
    [self backBtn:nil];
}

- (void)customInit
{
    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    
    //已发布按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 38);
    [relationBtn setTitle:@"已发布" forState:UIControlStateNormal];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    relationBtn.selected = YES;
    [topBGView addSubview:relationBtn];
    
    
    //未发布按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 38);
    [circleBtn setTitle:@"未发布" forState:UIControlStateNormal];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:circleBtn];
    
    
    //未通过按钮
    totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 38);
    [totalBtn setTitle:@"未通过" forState:UIControlStateNormal];
    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalBtn:) forControlEvents:UIControlEventTouchUpInside];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:totalBtn];
    
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y , SCREEN_WIDTH / 3, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 64 - 39);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    
    [self.view addSubview:self.sv];
    
    self.hadPublishVC = [[HadPublishViewController alloc]init];
    self.hadPublishVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.hadPublishVC.dealType = _dealType;
    [self.sv addSubview:self.hadPublishVC.view];
    [self addChildViewController:self.hadPublishVC];
    
    self.notPublishVC = [[NotPublishViewController alloc]init];
    self.notPublishVC.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.notPublishVC.dealType = _dealType;
    //    [self.sv addSubview:self.notPublishVC.view];
    //    [self addChildViewController:self.notPublishVC];
    
    self.hadNotPublishVC = [[HadNotViewController alloc]init];
    self.hadNotPublishVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.hadNotPublishVC.dealType = _dealType;
    //    [self.sv addSubview:self.hadNotPublishVC.view];
    //    [self addChildViewController:self.hadNotPublishVC];
    
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    
    [self.view addSubview:topBGView];
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    CGPoint tempPoint = scrollView.contentOffset;
    //    if (tempPoint.x < -70) {
    //        [self backBtn:nil];
    //    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //if (velocity.x > 1) {
    NSLog(@"%f",velocity.x);
    //}
}

#pragma mark - 三个button点击事件
- (void)relationBtn:(UIButton *)sender
{
    circleBtn.selected = NO;
    totalBtn.selected = NO;
    relationBtn.selected = YES;
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
    [self.hadPublishVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    totalBtn.selected = NO;
    circleBtn.selected = YES;
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    if (!secondVC) {
        [self.sv addSubview:self.notPublishVC.view];
        [self addChildViewController:self.notPublishVC];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3*2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
    [self.notPublishVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    
}
- (void)totalBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    circleBtn.selected = NO;
    totalBtn.selected = YES;
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    if (!thirdVC) {
        [self.sv addSubview:self.hadNotPublishVC.view];
        [self addChildViewController:self.hadNotPublishVC];
        thirdVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
    [self.hadNotPublishVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
    [UIView commitAnimations];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    if (self.sv.contentOffset.x == 0) {
        circleBtn.selected = NO;
        totalBtn.selected = NO;
        relationBtn.selected = YES;
        if (tempPage != page) {
            [self.hadPublishVC urlRequestPost];
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        relationBtn.selected = NO;
        totalBtn.selected = NO;
        circleBtn.selected = YES;
        if (!secondVC) {
            [self.sv addSubview:self.notPublishVC.view];
            [self addChildViewController:self.notPublishVC];
            secondVC = YES;
        }
        if (tempPage != page) {
            [self.notPublishVC urlRequestPost];
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3*2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        [self.notPublishVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH*2) {
        relationBtn.selected = NO;
        circleBtn.selected = NO;
        totalBtn.selected = YES;
        if (!thirdVC) {
            [self.sv addSubview:self.hadNotPublishVC.view];
            [self addChildViewController:self.hadNotPublishVC];
            thirdVC = YES;
        }
        if (tempPage != page) {
            [self.hadNotPublishVC urlRequestPost];
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        [self.hadNotPublishVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
        [UIView commitAnimations];
    }
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
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
