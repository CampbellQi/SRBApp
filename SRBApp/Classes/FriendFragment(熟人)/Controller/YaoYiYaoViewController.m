//
//  YaoYiYaoViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/24.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "YaoYiYaoViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YaoYiYaoViewController ()

@end

@implementation YaoYiYaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"摇一摇";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];
}

- (void)backBtn
{
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


- (void) motionBegan:(UIEventSubtype)motionwithEvent:(UIEvent
                                                      
                                                      *)event
{
    
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    
//    [AutoDismissAlert autoDismissAlert:@"取消摇动"];
    
}




-
(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event




{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    //摇动结束
    
    if(event.subtype
       == UIEventSubtypeMotionShake) {
        
        //somethinghappens
        [AutoDismissAlert autoDismissAlert:@"好爽"];
        
        
        
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
