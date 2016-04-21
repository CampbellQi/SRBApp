//
//  PublishLaterBackViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PublishLaterBackViewController.h"
#import "AppDelegate.h"
#import "ChangeBuyViewController.h"
#import "SaleListViewController.h"

@interface PublishLaterBackViewController ()

@end

@implementation PublishLaterBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn
{
    isBack = YES;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
