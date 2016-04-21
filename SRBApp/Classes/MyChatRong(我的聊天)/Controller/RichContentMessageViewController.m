//
//  RichContentMessageViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "RichContentMessageViewController.h"
#import "MyChatSettingViewController.h"
#import "DetailActivityViewController.h"
#import "SubclassDetailViewController.h"
#import "PreviewViewController.h"
#import "PersonalViewController.h"
#import "RCIM.h"
#import "AppDelegate.h"

@interface RichContentMessageViewController ()
@property (nonatomic) RCUserAvatarStyle portaitStyle;

@end

@implementation RichContentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.portaitStyle = RCUserAvatarCycle;
    

    //自定义导航左按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt2"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    self.enableSettings = NO;
    self.navigationItem.rightBarButtonItem = nil;
    //自定义导航右按钮
//    UIButton *customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    customRightBtn.frame = CGRectMake(0, 0, 62/2, 62/2);
//    [customRightBtn setImage:[UIImage imageNamed:@"rc_bar_more"] forState:UIControlStateNormal];
//    [customRightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];

    //进入详情页面
    __block RichContentMessageViewController *tempVC = self;
    self.messageTapHandler = ^(RCMessage *metadata){
        DetailActivityViewController *detailAVC = [[DetailActivityViewController alloc] init];
        RCRichContentMessage *content = (RCRichContentMessage*)metadata.content;
        detailAVC.idNumber = content.extra;
        
        [tempVC.navigationController pushViewController:detailAVC animated:YES];
    };
    
    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
    // 连接融云服务器。
    [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
        // 此处处理连接成功。
    } error:^(RCConnectErrorCode status) {
        // 此处处理连接错误。
    }];

}

-(void)leftBarButtonItemPressed:(id)sender
{
    [super leftBarButtonItemPressed:sender];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = YES;
}

-(void)rightBarButtonItemPressed:(id)sender{
    MyChatSettingViewController *temp = [[MyChatSettingViewController alloc]init];
    temp.targetId = self.currentTarget;
    temp.conversationType = self.conversationType;
    temp.portraitStyle = RCUserAvatarCycle;
    [self.navigationController pushViewController:temp animated:YES];
}

-(void)showPreviewPictureController:(RCMessage*)rcMessage{
    
    PreviewViewController *temp=[[PreviewViewController alloc]init];
    temp.rcMessage = rcMessage;
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:temp];
    
    //导航和原有的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)sendDebugRichMessage
{
    RCRichContentMessage *message = [[RCRichContentMessage alloc] init];
    message.title = self.title;
    message.digest = self.content;
    message.extra = self.idNumber;
    message.imageURL = self.imageUrl;
//    if ([self.photo isEqualToString:@"0"]) {
//        message.imageURL = @"";
//    }else{
//        message.imageURL = self.imageUrl;
//    }
//    -(RCMessage *)sendTextMessage:(RCConversationType)conversationType
//targetId:(NSString *)targetId
//textMessage:(RCTextMessage *)textMessage
//delegate:(id<RCSendMessageDelegate>)delegate
//object:(id)object;

    NSLog(@"message.extra == %@",message.extra);
    [[RCIM sharedRCIM] sendMessage:self.conversationType
                          targetId:self.currentTarget
                           content:message
                          delegate:self];

}

- (void)didTapMessageHandler
{
    DetailActivityViewController *detailVC = [[DetailActivityViewController alloc] init];
    detailVC.idNumber = self.idNumber;
    [self.navigationController pushViewController:detailVC animated:YES];
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
