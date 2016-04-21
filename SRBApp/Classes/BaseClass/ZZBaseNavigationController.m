//
//  ZZBaseNavigationController.m
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import "ZZBaseNavigationController.h"
#import "AppDelegate.h"

@interface ZZBaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation ZZBaseNavigationController
{
    UIViewController * tempViewController;
}
//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
//{
//    ZZBaseNavigationController * nvc = [super initWithRootViewController:rootViewController];
//    self.interactivePopGestureRecognizer.delegate = self;
//    nvc.delegate = self;
//    return nvc;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    self.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"e5005d"];
    UINavigationBar * navBar = [UINavigationBar appearance];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    [navBar setFrame:frame];

    self.navigationBar.translucent = NO;
    
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (navigationController.viewControllers.count == 1) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        app.zhedangView.hidden = NO;
//        app.tabBarBtn1.enabled = NO;
//        app.tabBarBtn2.enabled = NO;
//        app.tabBarBtn4.enabled = NO;
//        app.tabBarBtn5.enabled = NO;
//        app.tabBarImageV.userInteractionEnabled = NO;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (navigationController.viewControllers.count == 1) {
//
    tempViewController = viewController;
    AppDelegate *app = APPDELEGATE;
    app.zhedangView.hidden = YES;
//        app.tabBarBtn1.enabled = YES;
//        app.tabBarBtn2.enabled = YES;
//        app.tabBarBtn4.enabled = YES;
//        app.tabBarBtn5.enabled = YES;
//        app.tabBarImageV.userInteractionEnabled = YES;
//    }
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1) {
        return NO;
    }
    
    return YES;
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
