//
//  FriendsViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FriendsViewController.h"

#import "MJRefresh.h"
#import "FriendFragmentModel.h"
#import "FriendBaseCell.h"
#import "FriendGroupModel.h"
#import "SecondView.h"
#import "SearchFriendViewController.h"
#import "MyChatViewController.h"

#import "MyChatListViewController.h"
#import "RCIM.h"
#import "NewFriendsApplyAdapterViewController.h"
#import "SGActionView.h"

#import "MyFriendsViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "FriendMoreViewController.h"
#import "ZZNavigationController.h"
#import "SelectPersonRongViewController.h"
#import "LogoImgView.h"
#import "AMBlurView.h"
#import "RCIMClient.h"
#import "SubRegViewController.h"
#import "SonOfAskAddressViewController.h"

@interface FriendsViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate>
//@property (nonatomic, strong) UIImageView *zuijinSignView;   //新的消息提醒
@property (nonatomic, strong) UIImageView *signView;   //新的熟人提醒
@property (nonatomic, strong) UILabel *countNewLabel;  //新的熟人个数
@property (nonatomic, strong) UILabel *countZJLabel;  //新的消息个数
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation FriendsViewController
{
    NSString * perNum;                      //人数
    NSInteger listCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationTitle:@"熟 人" textColor:[UIColor whiteColor]];
//    [self setHidesBottomBarWhenPushed:YES];
    
//    self.navigationItem.leftBarButtonItem = nil;
//    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.button1.frame = CGRectMake(0, 0, 20, 20);
//    [self.button1 addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
//    [self.button1 setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.button1];
//         self.navigationItem.leftBarButtonItem = nil;
    //初始化控件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewFriends) name:@"userapply" object:nil];
    //[self getNewFriends];
    [self customView];
//    [self createLogin];
    //判断是否是游客
    
//    NSString *account= [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//
//    if ([account isEqualToString:GUEST]) {
//        self.guestVC.view.hidden = NO;
//    }
}

//- (void)createLogin
//{
//    self.guestVC = [[GuestLoginViewController alloc] initWithSign:FRIEND_SGIN ViewController:self];
//    [self.guestVC.regBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
//    [self.guestVC.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    [self addChildViewController:self.guestVC];
//    [self.view addSubview:self.guestVC.view];
//    self.guestVC.view.hidden = YES;
//}
//
////注册
//- (void)regist:(UIButton *)sender
//{
//    SubRegViewController *regVC = [[SubRegViewController alloc] init];
//    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:regVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}
////登录
//- (void)login:(UIButton *)sender
//{
//    LoginViewController *loginVC =[[LoginViewController alloc] init];
//    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}


//收到通知的操作
- (void)reloadPost
{
    [self getNewFriends];
//    AppDelegate *app = APPDELEGATE;
//    app.newwFriendView.hidden = YES;
    [self refreshChatListView];
}
//获取当前会话列表条数
//- (void)getListCount
//{
//    listCount = [self getConversationList:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)]].count;
//    NSLog(@"listCount == %ld",listCount);
//    if (listCount > 0) {
//        NSLog(@"listCount >  0");
//        [self.view addSubview:self.myChatListVC.view];
//        [self addChildViewController:self.myChatListVC];
//        emptyImageV.hidden = YES;
//    }else{
//        [self.myChatListVC removeFromParentViewController];
//        [self.myChatListVC.view removeFromSuperview];
//        emptyImageV.hidden = NO;
//        NSLog(@"listCount <= 0");
//    }
//
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"chatList"];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
    [app getNewNewsCount];
    [self getNewFriends];
    
    [self setNavigationTitle:@"熟 人" textColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button1];
    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
//        self.guestVC.view.hidden = NO;
//    }else{
//        self.guestVC.view.hidden = YES;
//        [app getNewNewsCount];
//        [self getNewFriends];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"chatList"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)showGuideView {

}
#pragma mark - 右上角button
- (void)more:(UIButton *)sender
{
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] isEqualToString:GUEST]) {
//        FriendMoreViewController * moreVC = [[FriendMoreViewController alloc]init];
//        moreVC.array = @[@"意见反馈"];
//        moreVC.imgArr = @[@"fankui"];
//        [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
//        [self addChildViewController:moreVC];
//    }else{
   
        FriendMoreViewController * moreVC = [[FriendMoreViewController alloc]init];
        moreVC.array = @[@"发现熟人",@"邀请熟人",@"扫 一 扫"];
        moreVC.imgArr = @[@"faxian",@"yaoqinghaoyou",@"TwoDimensionCode"];
        [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
        [self addChildViewController:moreVC];
    
    
//    }
}

#pragma mark - 搜索手势,最近联系人手势,新的熟人手势
- (void)searchVC:(UITapGestureRecognizer *)tap
{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
    SearchFriendViewController * searchVC = [[SearchFriendViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    }
}
//我的熟人
- (void)zuijinTap:(UITapGestureRecognizer *)tap
{
    MyFriendsViewController *myFriendsVC = [[MyFriendsViewController alloc] init];
    myFriendsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myFriendsVC animated:YES];
}
//新的熟人
- (void)newTap:(UITapGestureRecognizer *)tap
{
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
    self.signView.hidden = YES;
    NewFriendsApplyAdapterViewController * newFriendVC = [[NewFriendsApplyAdapterViewController alloc]init];
    newFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newFriendVC animated:YES];
    }
}

#pragma mark - 请求完数据做的处理（熟人）
- (void)customView
{
    self.topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    self.topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    //    _tableview.tableHeaderView = topBGView;
    [self.view addSubview:self.topBGView];
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 7.5, SCREEN_WIDTH - 30, 25)];
    searchView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 2;
    [self.topBGView addSubview:searchView];
    
    UIImageView * searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 15, 15)];
    searchImg.image = [UIImage imageNamed:@"hy_search"];
    [searchView addSubview:searchImg];
    
    UILabel * searchlabel = [[UILabel alloc]initWithFrame:CGRectMake(searchImg.frame.size.width + searchImg.frame.origin.x + 10, 5, 100, 14)];
    searchlabel.font = SIZE_FOR_14;
    searchlabel.text = @"添加熟人";
    searchlabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [searchView addSubview:searchlabel];
    

    UITapGestureRecognizer * searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchVC:)];
    [searchView addGestureRecognizer:searchTap];

    
    
    SecondView * secondZuijinView = [[SecondView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 60)];
    secondZuijinView.logoImg.image = [UIImage imageNamed:@"my_friends"];
    secondZuijinView.titleLabel.text = @"我的熟人";
    [self.topBGView addSubview:secondZuijinView];
    
    //添加会话列表
    self.myChatListVC = [[MyChatListViewController alloc] init];
    self.myChatListVC.view.frame = CGRectMake(0, self.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.topBGView.frame.size.height);
    [self.view addSubview:self.myChatListVC.view];
    self.myChatListVC.friendFragmentVC = self;
//    [self refreshChatListView];
    [self addChildViewController:self.myChatListVC];
    
    //好友总数
    self.countZJLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 75, secondZuijinView.titleLabel.frame.origin.y - 2, 100, 20)];
    self.countZJLabel.textAlignment = NSTextAlignmentRight;
    self.countZJLabel.text = @"0";
    self.countZJLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.countZJLabel.font = [UIFont systemFontOfSize:14];
    [secondZuijinView addSubview:self.countZJLabel];
    
    
    SecondView * secondNewView = [[SecondView alloc]initWithFrame:CGRectMake(0, 101, SCREEN_WIDTH, 60)];
    secondNewView.logoImg.image = [UIImage imageNamed:@"new_friends"];
    secondNewView.titleLabel.text = @"新的熟人";
    [self.topBGView addSubview:secondNewView];
    //最近联系人
    UIView *zuijinView =[[UIView alloc] initWithFrame:CGRectMake(0, secondNewView.frame.origin.y + secondNewView.frame.size.height + 20, SCREEN_WIDTH, 40)];
    zuijinView.backgroundColor = [UIColor whiteColor];
    [self.topBGView addSubview:zuijinView];
    
    UILabel *zuijinLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    zuijinLabel.text = @"最近联系人";
    zuijinLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    zuijinLabel.font = [UIFont systemFontOfSize:15];
    [zuijinView addSubview:zuijinLabel];
    
    UIImageView *zuijinImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 15 - 70, 10, 20, 20)];
    zuijinImageV.image = [UIImage imageNamed:@"friends_add1"];
    zuijinImageV.userInteractionEnabled = YES;
    [zuijinView addSubview:zuijinImageV];
    
    UIButton *zuijinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zuijinBtn.frame = CGRectMake(SCREEN_WIDTH - 5 - 80, 0, 80, 40);
    [zuijinBtn setTitle:@"发起聊天" forState:UIControlStateNormal];
    [zuijinBtn addTarget:self action:@selector(zuijin) forControlEvents:UIControlEventTouchUpInside];
    [zuijinBtn setTitleColor:[GetColor16 hexStringToColor:@"e5005d"] forState:UIControlStateNormal];
    zuijinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zuijinView addSubview:zuijinBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [zuijinView addSubview:lineView];
    
    UITapGestureRecognizer *zuijinImageVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zuijin)];
    [zuijinImageV addGestureRecognizer:zuijinImageVTap];
    
    self.signView = [[UIImageView alloc] initWithFrame:CGRectMake(secondNewView.titleLabel.frame.size.width + secondNewView.titleLabel.frame.origin.x, secondNewView.titleLabel.frame.origin.y + 4, 7, 7)];
    self.signView.hidden = YES;
    self.signView.image = [UIImage imageNamed:@"newfriend_notic"];
    [secondNewView addSubview:self.signView];
    
    //新的熟人人数
    self.countNewLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 75, secondNewView.titleLabel.frame.origin.y - 2, 100, 20)];
    self.countNewLabel.textAlignment = NSTextAlignmentRight;
    self.countNewLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.countNewLabel.text = @"0";
    self.countNewLabel.font = [UIFont systemFontOfSize:14];
    [secondNewView addSubview:self.countNewLabel];
    
    
    UITapGestureRecognizer * zuijinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zuijinTap:)];
    UITapGestureRecognizer * newTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newTap:)];
    [secondZuijinView addGestureRecognizer:zuijinTap];
    [secondNewView addGestureRecognizer:newTap];
}
////获取会话列表
//-(NSArray*)getConversationList:(NSArray*)conversationTypes{
//    NSLog(@"conversationTypes == %@",conversationTypes);
//    RCIM *rcim = [RCIM sharedRCIM];
//    return rcim.conversationList;
//}

-(BOOL)showCustomEmptyBackView
{
    return YES;
}

- (void)zuijin{
//    AppDelegate *app = APPDELEGATE;
//    [app getFriendArr];
    //    跳转好友列表界面，可以是融云提供的UI组件，也可以是自己实现的UI
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
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
}

//新的请求人数
- (void)getNewFriends
{
    AppDelegate *app = APPDELEGATE;
    
    NSMutableDictionary * loginDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if ([[loginDic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
        NSDictionary * dic = [self parametersForDic:@"getUserFriendCount"
                                         parameters:@{ACCOUNT_PASSWORD}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * applyCount = [[dic objectForKey:@"data"] objectForKey:@"applyCount"];
            NSString * friendCount = [[dic objectForKey:@"data"] objectForKey:@"friendCount"];
            
            if ([applyCount isEqualToString:@"0"] || !applyCount) {
                self.signView.hidden = YES;
                self.countNewLabel.text = @"0";
                app.newwFriendView.hidden = YES;
            }else{
                self.countNewLabel.text = applyCount;
                self.signView.hidden = NO;
                app.newwFriendView.hidden = NO;
            }
            if ([friendCount isEqualToString:@"0"]) {
                self.countZJLabel.text = @"0";
            }else{
                self.countZJLabel.text = friendCount;
            }
            //tempDataDic = [dic objectForKey:@"data"];
//            NSString * updateContacts = [[dic objectForKey:@"data"] objectForKey:@"updateContacts"];
//            if (updateContacts == nil || [updateContacts isEqualToString:@""] || updateContacts.length == 0) {
//                isHaveTime = NO;
//            }else{
//                isHaveTime = YES;
//            }
            //[self alertShowWithDic:[dic objectForKey:@"data"]];
        } andFailureBlock:^{
            
        }];
    }else{
        return;
    }
}

- (void)alertShowWithDic:(NSDictionary *)dic
{
    NSString * updateContacts = [dic objectForKey:@"updateContacts"];
    //NSString * updateContacts = nil;
    if (updateContacts == nil || [updateContacts isEqualToString:@""] || updateContacts.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"导入通讯录，帮你找到老熟人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AppDelegate * app = APPDELEGATE;
        [app.mainTab setSelectedIndex:3];
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        app.zhedangView.hidden = YES;
        app.tabBarBtn1.selected = NO;
        app.tabBarBtn4.selected = YES;
        SonOfAskAddressViewController * myAssureVC = [[SonOfAskAddressViewController alloc]init];
        [self.navigationController pushViewController:myAssureVC animated:YES];
    }
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}
////、获取会话列表cell条数（1.3.3）
//-(NSArray*)getConversationList:(NSArray*)conversationTypes{
//    NSLog(@"conversationTypes == %@",conversationTypes);
//    return conversationTypes;
//}
- (void)didSelectedPersons:(NSArray*)selectedArray viewController:(RCSelectPersonViewController *)viewController
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
