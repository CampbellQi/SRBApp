//
//  SecondMyChatViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SecondMyChatViewController.h"

@interface SecondMyChatViewController ()

@end

@implementation SecondMyChatViewController
{
    BOOL isBack;
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
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftBarButtonItemPressed:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
