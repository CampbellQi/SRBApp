//
//  MyChatViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyChatViewController.h"
#import "RCChatSettingViewController.h"
#import "MyChatSettingViewController.h"
#import "DetailActivityViewController.h"
#import "RCPreviewViewController.h"
#import "PreviewViewController.h"
#import "PersonalViewController.h"
#import "RCIM.h"
#import "SecondSubclassDetailViewController.h"
#import "SubChatSettingViewController.h"

@interface MyChatViewController ()
{
    BOOL isBack;
}
@property (nonatomic) RCUserAvatarStyle portaitStyle;
@end

@implementation MyChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self setHidesBottomBarWhenPushed:YES];
    
    //自定义导航左按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt2"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    self.enableSettings = NO;
    self.navigationItem.rightBarButtonItem = nil;
////    自定义导航右按钮
    UIButton *customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customRightBtn.frame = CGRectMake(0, 0, 62/2, 62/2);
    [customRightBtn setImage:[UIImage imageNamed:@"rc_bar_more"] forState:UIControlStateNormal];
    [customRightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];

    //取消角标
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //进入详情页面
    __block MyChatViewController *tempVC = self;
    self.messageTapHandler = ^(RCMessage *metadata){
        SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
        RCRichContentMessage *content = (RCRichContentMessage*)metadata.content;
        detailAVC.idNumber = content.extra;
        [tempVC.navigationController pushViewController:detailAVC animated:YES];
    };
    
    self.portaitStyle = RCUserAvatarCycle;
    
    
    UISwipeGestureRecognizer * backSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backSwip:)];
    [self.view addGestureRecognizer:backSwip];
}

- (void)backSwip:(UISwipeGestureRecognizer *)swip
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"chat"];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"chat"];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}
- (void)leftBarButtonItemPressed:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBarButtonItemPressed:(id)sender{
    
    if ([self.type isEqualToString:@"personal"]) {
        SubChatSettingViewController *temp = [[SubChatSettingViewController alloc]init];
        temp.targetId = self.currentTarget;
        temp.hidesBottomBarWhenPushed = YES;
        temp.conversationType = self.conversationType;
        temp.portraitStyle = RCUserAvatarCycle;
        [self.navigationController pushViewController:temp animated:YES];
    }else{
        MyChatSettingViewController *temp = [[MyChatSettingViewController alloc]init];
        temp.targetId = self.currentTarget;
        temp.hidesBottomBarWhenPushed = YES;
        temp.conversationType = self.conversationType;
        temp.portraitStyle = RCUserAvatarCycle;
        [self.navigationController pushViewController:temp animated:YES];
    }
}

-(void)showPreviewPictureController:(RCMessage*)rcMessage{
    PreviewViewController *temp=[[PreviewViewController alloc] init];
    temp.rcMessage = rcMessage;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:temp];
    
    //导航和原有的配色保持一致
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)onBeginRecordEvent{
    NSLog(@"录音开始");
}
-(void)onEndRecordEvent{
    NSLog(@"录音结束");
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
