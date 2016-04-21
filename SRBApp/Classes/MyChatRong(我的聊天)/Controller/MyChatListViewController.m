//
//  MyChatListViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyChatListViewController.h"
#import "RCSelectPersonViewController.h"
#import "SelectPersonRongViewController.h"
#import "MyChatViewController.h"
#import "AppDelegate.h"
#import "FriendsViewController.h"


@interface MyChatListViewController ()<RCIMConnectionStatusDelegate,RCSelectPersonViewControllerDelegate,UITableViewDelegate>
{
    UIView * emptyView;
}
@property (nonatomic, strong) UIButton *customRightBtn;
@end

@implementation MyChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    self.portraitStyle = RCUserAvatarCycle;
    isBack = NO;
//    [self setHidesBottomBarWhenPushed:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    
//    AppDelegate *app = APPDELEGATE;
//    app.signView.hidden = YES;
    
    //自定义导航标题颜色
//    [self setNavigationTitle:@"最近联系人" textColor:[UIColor whiteColor]];
    
    //自定义导航左右按钮
//    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
//    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt1"] forState:UIControlStateNormal];
//    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    //自定义导航右按钮
    self.customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.customRightBtn.frame = CGRectMake(0, 0, 31, 31);
    [self.customRightBtn setImage:[UIImage imageNamed:@"rc_add_people"] forState:UIControlStateNormal];
    [self.customRightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.customRightBtn];
    
    //无数据的占位图
    emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UIImageView * emptyImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 485/2/2, 40, 485/2, 280 - 140)];
    emptyImageV.image = [UIImage imageNamed:@"empty_comment2"];
    [emptyView addSubview:emptyImageV];
    
//    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, emptyImageV.frame.size.height + 40, 120, 40)];
//    emptyLabel.text = @"暂时没有会话";
//    emptyLabel.textAlignment = NSTextAlignmentCenter;
//    emptyLabel.textColor = [GetColor16 hexStringToColor:@"c9c9c9"];
//    [emptyView addSubview:emptyLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewNewsCountNF:) name:@"GetNewNewsCountNF" object:nil];
    
}
//有新消息时候
-(void)getNewNewsCountNF:(NSNotification *)aNF {
    NSString *count = [[aNF userInfo] objectForKey:@"count"];
    if ([count intValue] != 0) {
        emptyView.hidden = YES;
    }
    
}
//连接状态
-(void)responseConnectionStatus:(RCConnectionStatus)status
{
//    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
//        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您的账号在其他设备登录，是否重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        [alert show];
//    }
}
-(BOOL)showCustomEmptyBackView
{
    self.conversationListView.hidden = NO;
    [self.conversationListView setBackgroundView:emptyView];
    return YES;
}

-(void)viewWillLayoutSubviews{
    if (self.conversationStore.count == 0) {
        emptyView.hidden = NO;
    }else{
        emptyView.hidden = YES;
    }
    AppDelegate * appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDele getNewNewsCount];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversationStore.count == 0) {
        emptyView.hidden = NO;
    }else{
        emptyView.hidden = YES;
    }
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    AppDelegate *app = APPDELEGATE;
//    if (isBack) {
//        app.mainTab.tabBar.hidden = YES;
//    }
//}

//- (void)leftBarButtonItemPressed:(UIBarButtonItem *)sender
//{
////    isBack = YES;
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)sender
{
    //跳转好友列表界面，可以是融云提供的UI组件，也可以是自己实现的UI
    SelectPersonRongViewController *temp = [[SelectPersonRongViewController alloc]init];
    //控制多选
    temp.isMultiSelect = YES;
    temp.portaitStyle = RCUserAvatarCycle;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:temp];
    //导航和的配色保持一直
    UIImage *image= [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    temp.delegate = self;
    //    [self presentModalViewController:nav animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}


-(void)didSelectedPersons:(NSArray*)selectedArray viewController:(RCSelectPersonViewController *)viewController
{
    if(selectedArray == nil || selectedArray.count == 0)
    {
        NSLog(@"Select person array is nil");
        return;
    }
    int count = (int)selectedArray.count;
    
    
    //只选择一个人得时候,创建单人聊天
    if (1 == count) {
        RCUserInfo* userInfo = selectedArray[0];
        [self startPrivateChat:userInfo];
    }
    //选择多个人得时候
    else if(count  > 1){
        
        [self startDiscussionChat:selectedArray];
        
    }
    
}

/**
 *  启动一对一聊天
 *
 *  @param userInfo
 */
-(void)startPrivateChat:(RCUserInfo*)userInfo{
    
    MyChatViewController* chat = [self getChatController:userInfo.userId conversationType:ConversationType_PRIVATE];
    if (nil == chat) {
        chat =[[MyChatViewController alloc]init];
        chat.portraitStyle = RCUserAvatarCycle;
        [self addChatController:chat];
    }
    
    chat.currentTarget = userInfo.userId;
    chat.currentTargetName = userInfo.name;
    chat.conversationType = ConversationType_PRIVATE;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 *  启动讨论组
 *
 *  @param userInfos
 */
-(void)startDiscussionChat:(NSArray*)userInfos{
    
    NSMutableString *discussionName = [NSMutableString string] ;
    NSMutableArray *memberIdArray =[NSMutableArray array];
    NSInteger count = userInfos.count ;
    for (int i=0; i<count; i++) {
        RCUserInfo *userinfo = userInfos[i];
        //NSString *name = userinfo.name;
        if (i == userInfos.count - 1) {
            [discussionName appendString:userinfo.name];
        }else{
            [discussionName  appendString:[NSString stringWithFormat:@"%@%@",userinfo.name,@","]];
        }
        [memberIdArray addObject:userinfo.userId];
        
    }
    //创建讨论组
    [[RCIMClient sharedRCIMClient]createDiscussion:discussionName userIdList:memberIdArray completion:^(RCDiscussion *discussInfo) {
        NSLog(@"create discussion ssucceed!");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MyChatViewController* chat = [self getChatController:discussInfo.discussionId conversationType:ConversationType_PRIVATE];
            if (nil == chat) {
                chat =[[MyChatViewController alloc]init];
                chat.portraitStyle = RCUserAvatarCycle;
                [self addChatController:chat];
            }
            
            chat.currentTarget = discussInfo.discussionId;
            chat.currentTargetName = discussInfo.discussionName;
            chat.conversationType = ConversationType_DISCUSSION;
            chat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chat animated:YES];
        });
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"DISCUSSION_INVITE_FAILED %ld",status);
            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"创建讨论组失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        });
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        [self.friendFragmentVC setNavigationTitle:@"最近联系人" textColor:[UIColor whiteColor]];
        self.friendFragmentVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.customRightBtn];
        self.friendFragmentVC.myChatListVC.view.frame = CGRectMake(0, self.friendFragmentVC.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
        [UIView animateWithDuration:0.3 animations:^{
            self.friendFragmentVC.view.frame = CGRectMake(self.friendFragmentVC.view.x, 0 - self.friendFragmentVC.topBGView.frame.size.height + 64, SCREEN_WIDTH, SCREEN_HEIGHT + 64 + 45);
        }];
    }else if(velocity.y < 0){
        self.hidesBottomBarWhenPushed = YES;
        [self.friendFragmentVC setNavigationTitle:@"熟 人" textColor:[UIColor whiteColor]];
        self.friendFragmentVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.friendFragmentVC.button1];
        self.friendFragmentVC.myChatListVC.view.frame = CGRectMake(0, self.friendFragmentVC.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
        [UIView animateWithDuration:0.3 animations:^{
            self.friendFragmentVC.view.frame = CGRectMake(self.friendFragmentVC.view.x, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        }];
    }
}


/**
 *  重载选择表格事件
 *
 *  @param conversation
 */
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    //暂时不加群组功能
    if(conversation.conversationType == ConversationType_GROUP)
    {
//        DemoGroupListViewController* groupVC = [[DemoGroupListViewController alloc] init];
//        self.currentGroupListView = groupVC;
//        groupVC.portraitStyle = RCUserAvatarCycle;
//        [self.navigationController pushViewController:groupVC animated:YES];
        return;
    }
    //该方法目的延长会话聊天UI的生命周期
    MyChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    if (nil == chat) {
        chat =[[MyChatViewController alloc]init];
        chat.portraitStyle = RCUserAvatarCycle;
        [self addChatController:chat];
    }
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
//    chat.currentTargetName = curCell.userNameLabel.text;
    chat.currentTargetName = conversation.conversationTitle;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}
@end
