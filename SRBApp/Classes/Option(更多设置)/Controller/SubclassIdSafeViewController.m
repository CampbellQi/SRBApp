//
//  SubclassIdSafeViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubclassIdSafeViewController.h"
#import "AppDelegate.h"

@interface SubclassIdSafeViewController ()

@end

@implementation SubclassIdSafeViewController
{
    BOOL isBack;
}
- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.mineVC post];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
