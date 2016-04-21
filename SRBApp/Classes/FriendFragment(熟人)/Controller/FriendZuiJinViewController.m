//
//  FriendZuiJinViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FriendZuiJinViewController.h"
#import "AppDelegate.h"

@interface FriendZuiJinViewController ()

@end

@implementation FriendZuiJinViewController
{
    BOOL isBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 11.5, 24.5);
    [button addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;

    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            app.customTab.hidden = NO;
            
        });
    }
    
}

- (void)backBtn:(UIButton *)sender
{

//    app.button.hidden = NO;

    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    NSArray *views = [app.mainTab.view subviews];
//    for(id v in views){
//        if([v isKindOfClass:[UITabBar class]]){
//            [(UITabBar *)v setHidden:NO];
////            [(UITabBar *)v bringSubviewToFront:app.button];
//
//        }
////        [app.tab.view bringSubviewToFront:app.button];
////        [(UITabBar *)v bringSubviewToFront:app.button];
//    }
//    
//    
////    app.tab.tabBar.hidden = NO;
////    app.button.hidden = NO;
////    [app.tab.view bringSubviewToFront:app.button];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4855 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.friendVC.showBlock();
//    });
//    app.tab.tabBar.hidden = YES;
    
//    AppDelegate *app = APPDELEGATE;
    
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];

    
//    [app.tab.view addSubview:app.button];
//    app.button.hidden = NO;

    
//    AppDelegate * app = APPDELEGATE;
//    app.button.hidden = NO;
    
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
