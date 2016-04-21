//
//  SubNewFriendsApplyViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubNewFriendsApplyViewController.h"
#import "AppDelegate.h"
@interface SubNewFriendsApplyViewController ()
{
    BOOL isBack;
}
@end

@implementation SubNewFriendsApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *app = APPDELEGATE;
    app.tabBarBtn1.selected = NO;
    app.tabBarBtn2.selected = NO;
    app.tabBarBtn4.selected = NO;
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
