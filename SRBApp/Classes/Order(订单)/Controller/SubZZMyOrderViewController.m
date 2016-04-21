//
//  SubZZMyOrderViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubZZMyOrderViewController.h"
#import "AppDelegate.h"
@interface SubZZMyOrderViewController ()
{
    BOOL isBack;
}
@end

@implementation SubZZMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *app = APPDELEGATE;
    app.tabBarBtn1.selected = NO;
    app.tabBarBtn2.selected = NO;
    app.tabBarBtn4.selected = NO;
//    if (is_IOS_7) {
//        UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
//        //popSwipe.delegate = self;
//        [popSwipe setEdges:UIRectEdgeLeft];
//        [self.view addGestureRecognizer:popSwipe];
//    }
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
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
