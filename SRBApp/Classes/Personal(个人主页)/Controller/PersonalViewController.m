//
//  PersonalViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalViewController.h"
#import "GetColor16.h"
#import <UIImageView+WebCache.h>
#import "PersonalModel.h"

#import "RelationTable.h"
#import "CircleTable.h"
#import "ShopTotalViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PersonImformationViewController.h"
//#import "PersonalLocationTable.h"
#import "PersonalLocationListController.h"
#import "PersonalDealViewController.h"
//#import "PersonalDealJYViewController.h"
#import "PersonalTopicListController.h"
#import "MoreViewController.h"
#import "ImageViewController.h"
#import "MyLabel.h"
#import "BussinessViewController.h"

@interface PersonalViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) JTSImageViewController *tempJtsVC;

@property (nonatomic, strong) PersonalTopicListController *assureVC;
@property (nonatomic, strong) PersonalDealViewController *dealVC;
@property (nonatomic, strong) PersonalLocationListController *locationVC;

@end

@implementation PersonalViewController
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBig = NO;
    isBack = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatTopView];
    [self urlRequestPostT];
    self.imageArray = [NSArray array];
    
    [self.view addSubview:self.topView];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlRequestPostTAgain) name:@"refreshPersonalPublishCountNF" object:nil];
}

- (void)refresh
{
    for(UIView *view in [self.view subviews])
    {
        if (view != _topView) {
            [view removeFromSuperview];
        }
    }
    [self creatTopView];
    [self urlRequestPostT];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (down_IOS_8) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        [self.dealVC removeFromParentViewController];
        [self.dealVC.view removeFromSuperview];
        [self.assureVC removeFromParentViewController];
        [self.assureVC.view removeFromSuperview];
        [self.locationVC removeFromParentViewController];
        [self.locationVC.view removeFromSuperview];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    if (self.mineFragmentVC != nil) {
       [self.mineFragmentVC postRun];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)operationFriend
{
    
    if ([[self.dataDic objectForKey:@"isFriended"] isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除好友?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 12346;
        [alert show];
        
    }else{
        NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加熟人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * text = [alert textFieldAtIndex:0];
        text.delegate = self;
        alert.tag = 12345;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        text.placeholder = [NSString stringWithFormat:@"我是%@",nickName];
        [alert show];
    }
}

- (void)operationBlack
{
    NSDictionary * tempdic;
    if ([[self.dataDic objectForKey:@"isBlack"] isEqualToString:@"0"]) {
        tempdic  = [self parametersForDic:@"accountBlackUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    }else{
        tempdic  = [self parametersForDic:@"accountDeleteBlackUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [self urlRequestPostTAgain];
            [hud hide:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [hud hide:YES];
        }
    }];
}

- (void)textChanged:(UITextField *)text
{
    NSString * toBeString = text.text;
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [text markedTextRange];
        UITextPosition * position = [text positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 10) {
            _canedit = NO;
        }
        if (!position) {
            if (toBeString.length > 20) {
                text.text = [toBeString substringToIndex:20];
                _canedit = YES;
            }
        }
    }
    else{
        if (toBeString.length > 20) {
            text.text = [toBeString substringToIndex:20];
            _canedit = NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length <= 20) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 12346) {
        if (buttonIndex == 1) {
            NSDictionary * tempdic = [self parametersForDic:@"accountDeleteFriend" parameters:@{ACCOUNT_PASSWORD,@"friendId":[self.dataDic objectForKey:@"friendId"]}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    [self urlRequestPostTAgain];
                    AppDelegate * app = APPDELEGATE;
                    [app getFriendArr];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }];
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
        }
    }else if (alertView.tag == 12345){
        NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        UITextField * text = [alertView textFieldAtIndex:0];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"处理中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        if ([text.text isEqualToString:@""] || text.text.length == 0) {
            text.text = [NSString stringWithFormat:@"我是%@",nickName];
        }
        
        if (buttonIndex == 1) {
            NSDictionary * tempdic = [self parametersForDic:@"accountApplyFriend" parameters:@{ACCOUNT_PASSWORD,@"friendAccount":[self.dataDic objectForKey:@"account"],@"say":text.text}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    [self urlRequestPostTAgain];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }];
        }
        [HUD removeFromSuperview];
    }
}

- (void)showMore:(UIButton *)sender
{
    MoreViewController * moreVC = [[MoreViewController alloc]init];
    
    if ([[self.dataDic objectForKey:@"isFriended"] isEqualToString:@"1"]) {
        if ([[self.dataDic objectForKey:@"isBlack"] isEqualToString:@"0"]) {
            moreVC.array = @[@"修改备注",@"删除熟人",@"共同熟人",@"屏蔽消息",@"二 维 码"];
            moreVC.imgArr = @[@"personal_remark_1",@"pop_friend_del",@"detail_section_commonfriend_systemColor",@"pop_personal_shield",@"QRiamge_pink"];
        }else{
            moreVC.array = @[@"修改备注",@"删除熟人",@"共同熟人",@"取消屏蔽",@"二 维 码"];
            moreVC.imgArr = @[@"personal_remark_1",@"pop_friend_del",@"detail_section_commonfriend_systemColor",@"pop_personal_allow",@"QRiamge_pink"];
        }
        
    }else{
        moreVC.array = @[@"添加熟人",@"共同熟人",@"二维码"];
        moreVC.imgArr = @[@"pop_friend_add",@"detail_section_commonfriend_systemColor",@"QRiamge_pink"];
    }
    moreVC.dataDic = self.dataDic;
    [[UIApplication sharedApplication].windows.lastObject addSubview:moreVC
     .view];
    [self addChildViewController:moreVC];
}

- (void)chatBtn:(UIButton *)sender
{
    if (isChatBtnDrag == NO) {
        MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = self.account;
        user.name = self.nickname;
        user.portraitUri = self.avatar;
        myChatVC.portraitStyle = RCUserAvatarCycle;
        myChatVC.currentTarget = user.userId;
        myChatVC.currentTargetName = user.name;
        myChatVC.type = @"personal";
        myChatVC.conversationType = ConversationType_PRIVATE;
        myChatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myChatVC animated:YES];
    }
    isChatBtnDrag = NO;

}

- (void)dragMoving:(UIButton *)sender withEvent:(UIEvent *)ev
{
    isChatBtnDrag = YES;
    CGPoint point = [[[ev allTouches] anyObject] locationInView:self.view];
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    CGFloat btnx = sender.frame.size.width/2;
    CGFloat btny = sender.frame.size.height/2;

    if(x<=btnx)
    {
        point.x = btnx;
    }
    
    
    
    if(x >= SCREEN_WIDTH - btnx)
    {
        point.x = SCREEN_WIDTH - btnx;
    }
    
    if (y <= btny) {
        point.y = btny;
    }
    
    if (y>= SCREEN_HEIGHT - btny - 64) {
        point.y = SCREEN_HEIGHT - btny - 64;
    }
//    if (y<=64) {
//        point.y = btny + 64;
//    }

    sender.center = point;
        
}

- (void)customView
{
    
    UIButton * chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 25, SCREEN_HEIGHT - 60 - 25 - 64, 60, 60);
    self.chatbutton = chatBtn;
    [chatBtn setImage:[UIImage imageNamed:@"unonline"] forState:UIControlStateNormal];
    isChatBtnDrag = NO;
    
    if (![self.account isEqualToString:ACCOUNT_SELF]) {
        chatBtn.hidden = NO;
    }else{
        chatBtn.hidden = YES;
    }
    
    [chatBtn addTarget:self action:@selector(chatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chatBtn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"sandian"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(15, 0, 35, 30);
    [rightBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];

    if (![self.account isEqualToString:ACCOUNT_SELF]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }
    
    //顶部背景
    self.topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height, SCREEN_WIDTH, 40)];
        self.topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self.view addSubview:self.topBGView];
 
    //交易按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 38.5);
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [relationBtn setTitle:@"买卖 ( )" forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    relationBtn.selected = YES;
    //[self.topBGView addSubview:relationBtn];
    
    //话题按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(30, 0, SCREEN_WIDTH/3, 38.5);
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [circleBtn setTitle:@"话题 ( )" forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    circleBtn.selected = YES;
    [self.topBGView addSubview:circleBtn];
    
    //足迹按钮
    totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    totalBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, 0, SCREEN_WIDTH/3, 38.5);
    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [totalBtn setTitle:@"足迹 ( )" forState:UIControlStateNormal];
    [totalBtn addTarget:self action:@selector(totalBtn:) forControlEvents:UIControlEventTouchUpInside];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [self.topBGView addSubview:totalBtn];
    
    //底部横线
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, circleBtn.frame.size.height + circleBtn.frame.origin.y + 0.5, SCREEN_WIDTH, 1)];
    lineImage.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
    [self.topBGView addSubview:lineImage];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(30, circleBtn.frame.size.height + circleBtn.frame.origin.y, SCREEN_WIDTH / 3, 1.5)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.topBGView addSubview:lineView];
  
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height + self.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
    self.sv.pagingEnabled = YES;
    self.sv.delaysContentTouches = NO;
    self.sv.delegate = self;
    self.sv.showsHorizontalScrollIndicator = NO;
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    [self.view addSubview:self.sv];
    
    self.dealVC = [[PersonalDealViewController alloc]init];
    self.dealVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
//    self.dealVC.personVC = self;
    //[self.sv addSubview:self.dealVC.view];
    self.dealVC.account = [self.dataDic objectForKey:@"account"];
    //[self addChildViewController:self.dealVC];
    
    //话题
    self.assureVC = [[PersonalTopicListController alloc]init];
    self.assureVC.account = [self.dataDic objectForKey:@"account"];
//    self.assureVC.personVC = self;
    self.assureVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
    [self.sv addSubview:self.assureVC.view];
    //self.assureVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:self.assureVC];
    
    //足迹
    self.locationVC = [[PersonalLocationListController alloc]init];
    self.locationVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
    CGRect tempTable = self.locationVC.tableview.frame;
    tempTable.size.height = self.locationVC.view.frame.size.height;
    self.locationVC.tableview.frame = tempTable;
    
    self.locationVC.personVC = self;
    self.locationVC.account = [self.dataDic objectForKey:@"account"];
    [self.sv addSubview:self.locationVC.view];
    [self addChildViewController:self.locationVC];
    
    if ([_myRun isEqualToString: @"1"]) {
        relationBtn.selected = NO;
        circleBtn.selected = NO;
        totalBtn.selected = YES;
        self.signLabel.frame = CGRectMake(12.5 + self.logoImageV.frame.size.height+16, self.nikeNameLabel.frame.origin.y + self.nikeNameLabel.frame.size.height + 20, SCREEN_WIDTH - 10 - 36-self.logoImageV.frame.size.width, 33);
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        [self.locationVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
    }
    if ([_myRun isEqualToString:@"2"]) {
        self.signLabel.frame = CGRectMake(12.5 + self.logoImageV.frame.size.height+16, self.nikeNameLabel.frame.origin.y + self.nikeNameLabel.frame.size.height + 20, SCREEN_WIDTH - 10 - 36-self.logoImageV.frame.size.width, 33);
    }

        [self.view addSubview:chatBtn];

//

    [self checkOnline];
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

#pragma mark - 三个button点击事件
- (void)relationBtn:(UIButton *)sender
{
    NSLog(@"click  ");
    circleBtn.selected = NO;
    totalBtn.selected = NO;
    relationBtn.selected = YES;
    //[self.locationVC.view endEditing:YES];
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
   // [self.dealVC.tableView headerBeginRefreshing];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    totalBtn.selected = NO;
    circleBtn.selected = YES;
    //[self.locationVC.view endEditing:YES];
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(30, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
    //[self.assureVC.tableView headerBeginRefreshing];
    [self.sv setContentOffset:CGPointMake(0, 0) animated:YES];
    //self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
    
}
- (void)totalBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    circleBtn.selected = NO;
    totalBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, totalBtn.frame.size.height + totalBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
    //[self.locationVC.tableview headerBeginRefreshing];
    //self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.sv setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [UIView commitAnimations];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        circleBtn.selected = YES;
        totalBtn.selected = NO;
        //relationBtn.selected = YES;
        [self.locationVC.view endEditing:YES];
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        //[self.assureVC.tableView headerBeginRefreshing];
        lineView.frame = CGRectMake(30, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        //[self.dealVC urlRequestPost];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        //relationBtn.selected = NO;
        totalBtn.selected = YES;
        circleBtn.selected = NO;
        [self.locationVC.view endEditing:YES];
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3 - 30, totalBtn.frame.size.height + totalBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        //[self.assureVC urlRequestPost];
        //[self.locationVC.tableview headerBeginRefreshing];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH*2) {
        relationBtn.selected = NO;
        circleBtn.selected = NO;
        totalBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/3, 1.5);
        //[self.locationVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
        [UIView commitAnimations];
    }
}


- (UIImageView *)creatTopView
{
    if (!_topView) {
        isDown = YES;
        _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
        _topView.image = [UIImage imageNamed:@"bg.jpg"];
//        _topView.backgroundColor = [UIColor whiteColor];
        _topView.userInteractionEnabled = YES;
        
        UISwipeGestureRecognizer * downSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(becomeBig)];
        downSwip.direction = UISwipeGestureRecognizerDirectionDown;
        [_topView addGestureRecognizer:downSwip];
        
        UISwipeGestureRecognizer * upSwip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(pullUpBtns)];
        upSwip.direction = UISwipeGestureRecognizerDirectionUp;
        [_topView addGestureRecognizer:upSwip];
        
        
        //头像
        self.logoImageV = [[UIImageView alloc] init];
        self.logoImageV.frame = CGRectMake(25/2, 25/2, 40, 40);
        self.logoImageV.userInteractionEnabled = YES;
        self.logoImageV.layer.masksToBounds = YES;
        self.logoImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.logoImageV.clipsToBounds = YES;
        self.logoImageV.layer.cornerRadius = self.logoImageV.frame.size.height/2;
        [_topView addSubview:self.logoImageV];
        
        //点击进入个人信息
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonalMessage)];
        [self.logoImageV addGestureRecognizer:tap];
        
        //备注（改为昵称）
        self.remarkLabel = [[UILabel alloc] init];
        self.labelRect = [self.nickname boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
//        self.remarkLabel.text = self.nickname;
        self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);
        NSLog(@"self.labelRect.size.width == %f",self.labelRect.size.width);
        self.remarkLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#ffffff"]];
        [_topView addSubview:self.remarkLabel];
        
        //加V实名认证
        
        //性别
        self.sexImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25/2+40+16+self.remarkLabel.frame.size.width + 6, self.remarkLabel.frame.origin.y+4, 15, 15)];
        [_topView addSubview:self.sexImageV];
        
        //星座
        self.xingzuoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15)];
        [_topView addSubview:self.xingzuoImageV];
        
        //下拉
        self.rightTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightTopBtn.frame = CGRectMake(SCREEN_WIDTH - 65, 10, 40, 15);
        [self.rightTopBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        self.rightTopBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.rightTopBtn addTarget:self action:@selector(becomeBig) forControlEvents:UIControlEventTouchUpInside];
        [self.rightTopBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#c9c9c9"]] forState:UIControlStateNormal];
        [_topView addSubview:self.rightTopBtn];
        
        //下拉2
        self.rightTopPic = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightTopPic.frame = CGRectMake(SCREEN_WIDTH - 20, 10, 10, 15);
        [self.rightTopPic addTarget:self action:@selector(becomeBig) forControlEvents:UIControlEventTouchUpInside];
        [self.rightTopPic setImage:[UIImage imageNamed:@"lakai"] forState:UIControlStateNormal];
        [_topView addSubview:self.rightTopPic];
        
        //变大后的控件frame
        //昵称(弃用)
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25/2+self.logoImageV.frame.size.height+16+64, 27+self.remarkLabel.frame.size.height-9, 100, 14)];
        self.nikeNameLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"ffffff"]];
        self.nikeNameLabel.alpha = 0;
        self.nikeNameLabel.font = [UIFont systemFontOfSize:14];
        [_topView addSubview:self.nikeNameLabel];
        
        //签名
        self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5 + self.logoImageV.frame.size.height+16, self.nikeNameLabel.frame.origin.y + self.nikeNameLabel.frame.size.height, SCREEN_WIDTH - 10 - 36-self.logoImageV.frame.size.width, 33)];
        self.signLabel.font = [UIFont systemFontOfSize:12];
        self.signLabel.numberOfLines = 3;
        self.signLabel.alpha = 0;
//        self.signLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.signLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"ffffff"]];
        [_topView addSubview:self.signLabel];
        
        //靠谱指数
        self.honestyLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5 + self.logoImageV.frame.size.height+16 ,self.nikeNameLabel.frame.origin.y + self.nikeNameLabel.frame.size.height + 9 , 60, 12)];
        self.honestyLabel.text = @"靠谱指数:";
        self.honestyLabel.alpha = 0;
        self.honestyLabel.font = [UIFont systemFontOfSize:12];
        self.honestyLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"ffffff"]];
        [_topView addSubview:self.honestyLabel];
        
        //忽悠指数
        self.lieLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5 + self.logoImageV.frame.size.height+16 ,self.honestyLabel.frame.origin.y + self.honestyLabel.frame.size.height + 9 , 60, 12)];
        self.lieLabel.font = [UIFont systemFontOfSize:12];
        self.lieLabel.text = @"忽悠指数:";
        self.lieLabel.alpha = 0;
        self.lieLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"ffffff"]];
        [_topView addSubview:self.lieLabel];
        
        //靠谱百分图底图
        self.honestyBGView = [[UILabel alloc] initWithFrame:CGRectMake(self.honestyLabel.frame.origin.x + self.honestyLabel.frame.size.width + 6, self.honestyLabel.frame.origin.y, 70, 10)];
        self.honestyBGView.layer.masksToBounds = YES;
        self.honestyBGView.layer.cornerRadius = 5;
        self.honestyBGView.alpha = 0;
        self.honestyBGView.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
        [_topView addSubview:self.honestyBGView];
        
        //忽悠百分图底图
        self.lieBGView = [[UIView alloc] initWithFrame:CGRectMake(self.lieLabel.frame.origin.x + self.lieLabel.frame.size.width + 6, self.lieLabel.frame.origin.y, 70, 10)];
        self.lieBGView.layer.masksToBounds = YES;
        self.lieBGView.layer.cornerRadius = 5;
        self.lieBGView.alpha = 0;
        self.lieBGView.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
        [_topView addSubview:self.lieBGView];
        
        //靠谱百分图上层图
        self.honestyOnView = [[UILabel alloc] init];
        self.honestyOnView.layer.masksToBounds = YES;
        self.honestyOnView.layer.cornerRadius = 5;
        self.honestyOnView.alpha = 0;
        self.honestyOnView.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
        [self.honestyBGView addSubview:self.honestyOnView];
        
        //忽悠百分图上层图
        self.lieOnView = [[UIView alloc] init];
        self.lieOnView.layer.masksToBounds = YES;
        self.lieOnView.layer.cornerRadius = 5;
        self.lieOnView.alpha = 0;
        self.lieOnView.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#959595"]];
        [self.lieBGView addSubview:self.lieOnView];
        
        //靠谱百分比
        self.hoestyPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.honestyBGView.frame.origin.x + self.honestyBGView.frame.size.width + 12, self.honestyBGView.frame.origin.y, 30, 12)];
        self.hoestyPercentLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#ffffff"]];
        self.hoestyPercentLabel.alpha = 0;
        self.hoestyPercentLabel.font = [UIFont systemFontOfSize:10];
        [_topView addSubview:self.hoestyPercentLabel];
        
        //忽悠百分比
        self.liePercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lieBGView.frame.origin.x + self.lieBGView.frame.size.width + 12, self.lieBGView.frame.origin.y, 30, 12)];
        self.liePercentLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#ffffff"]];
        self.liePercentLabel.font = [UIFont systemFontOfSize:10];
        self.liePercentLabel.alpha = 0;
        [_topView addSubview:self.liePercentLabel];
        
        //地址icon
        self.addressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12.5 + self.logoImageV.frame.size.height+16+24, self.lieLabel.frame.origin.y + self.lieLabel.frame.size.height + 10, 12, 18)];
        self.addressImageV.alpha = 0;
        self.addressImageV.image = [UIImage imageNamed:@"fb_wz1"];
        [_topView addSubview:self.addressImageV];
        //地址
        self.addressLabel = [[MyLabel alloc] initWithFrame:CGRectMake(12.5 + self.logoImageV.frame.size.height+16+12, self.lieLabel.frame.origin.y + self.lieLabel.frame.size.height + 8, SCREEN_WIDTH - 10 - 36-self.logoImageV.bounds.size.width-24, 33)];
        self.addressLabel.alpha = 0;
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.verticalAlignment = VerticalAlignmentTop;
        self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.addressLabel.font = SIZE_FOR_12;
        self.addressLabel.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"ffffff"]];
        [_topView addSubview:self.addressLabel];
        
        //上拉
        self.pullUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pullUpBtn.frame = CGRectMake(0, self.topView.frame.size.height-22, SCREEN_WIDTH, 15);
        self.pullUpBtn.alpha = 0;
        [self.pullUpBtn addTarget:self action:@selector(pullUpBtns) forControlEvents:UIControlEventTouchUpInside];
        [self.pullUpBtn setImage:[UIImage imageNamed:@"shouqilai"] forState:UIControlStateNormal];
        [_topView addSubview:self.pullUpBtn];
        
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = _topView.center;
        [activity setHidesWhenStopped:YES];
        [_topView addSubview:activity];
        
        return _topView;
    }
    return nil;
}

//变大
- (void)becomeBig
{
    if (!isDown) {
        return;
    }
    isDown = NO;
    isBig = YES;
    [UIView animateWithDuration:0.35 animations:^{
        for (int i = 1; i < 36; i++) {
            double delayInSeconds = 0.01*i;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.logoImageV.frame = CGRectMake(25/2, 25/2, 40+1*i, 40+1*i);
                self.logoImageV.layer.cornerRadius = (40+1*i)/2;
            });
        }
        
        self.rightTopBtn.hidden = YES;
        self.rightTopPic.hidden = YES;
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 212);
        NSString *memo = [self.dataDic objectForKey:@"memo"];

        if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
            self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
            self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
            NSString *str = [self.dataDic objectForKey:@"nickname"];
            if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, 150, self.labelRect.size.height);
            }else{
                self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);                }
        }else{
            self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
            self.remarkLabel.text = memo;
            if (memo.length >=7) {
                self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, 150, self.labelRect.size.height);
            }else{
                self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);
            }
            
        }

//        self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);
        self.sexImageV.frame = CGRectMake(25/2+75+16+self.remarkLabel.frame.size.width + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
        self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
//        self.nikeNameLabel.alpha = 1;
        self.signLabel.alpha = 1;
        self.honestyLabel.alpha = 1;
        self.lieLabel.alpha = 1;
        self.addressLabel.alpha = 1;
        self.addressImageV.alpha = 1;
        self.honestyBGView.alpha = 1;
        self.lieBGView.alpha = 1;
        self.pullUpBtn.alpha = 1;
        self.hoestyPercentLabel.alpha = 1;
        self.liePercentLabel.alpha = 1;
        self.honestyOnView.alpha = 1;
        self.lieOnView.alpha = 1;
        self.pullUpBtn.hidden = NO;
        
        self.nikeNameLabel.frame = CGRectMake(25/2+75+16, 27+self.remarkLabel.frame.size.height-9, 100, 14);
        
        CGRect rect = [[self.dataDic objectForKey:@"sign"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25/2 - 75 - 16 - 15, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
        CGRect signLabelFram = self.signLabel.frame;
        signLabelFram.size.width = SCREEN_WIDTH - 25/2 - 75 - 16 - 15;
        signLabelFram.origin.x = 25/2 + 75 + 16;
        signLabelFram.size.height = rect.size.height;
        self.signLabel.frame = signLabelFram;
        
        self.honestyLabel.frame = CGRectMake(12.5 + 75+16 ,self.signLabel.frame.origin.y + self.signLabel.frame.size.height + 12 , 60, 12);
        self.lieLabel.frame = CGRectMake(12.5 + 75+16 ,self.honestyLabel.frame.origin.y + self.honestyLabel.frame.size.height + 9 , 60, 12);
        self.addressImageV.frame  = CGRectMake(12.5 + 75+16, self.lieLabel.frame.origin.y + self.lieLabel.frame.size.height + 10, 12, 18);
        self.addressLabel.frame = CGRectMake(12.5 + 75+16+12, self.lieLabel.frame.origin.y + self.lieLabel.frame.size.height + 12, SCREEN_WIDTH - 10 - 36-75-24, 33);
        self.pullUpBtn.frame = CGRectMake(0, self.topView.frame.size.height-22, SCREEN_WIDTH, 15);
//        self.topView.image = [UIImage imageNamed:@"bg.jpg"];
//        [self.topView sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"userbackground"]]];
        
        if (((NSString *)[self.dataDic  objectForKey:@"userbackground"]).length == 0) {
            [self.topView setImage:[UIImage imageNamed:@"bg_mine_header.jpg"]];
        }else{
            [self.topView sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"userbackground"]]];
        }
        
        self.honestyBGView.frame = CGRectMake(self.honestyLabel.frame.origin.x + self.honestyLabel.frame.size.width + 6, self.honestyLabel.frame.origin.y, 70, 10);
        self.lieBGView.frame = CGRectMake(self.lieLabel.frame.origin.x + self.lieLabel.frame.size.width + 6, self.lieLabel.frame.origin.y, 70, 10);
        self.hoestyPercentLabel.frame = CGRectMake(self.honestyBGView.frame.origin.x + self.honestyBGView.frame.size.width + 12, self.honestyBGView.frame.origin.y, 30, 12);
        self.liePercentLabel.frame = CGRectMake(self.lieBGView.frame.origin.x + self.lieBGView.frame.size.width + 12, self.lieBGView.frame.origin.y, 30, 12);
        self.honestyOnView.frame = CGRectMake(0, 0, self.honestyBGView.frame.size.width *[[self.dataDic objectForKey:@"evaluationper"] floatValue]/100, 10);
        self.lieOnView.frame = CGRectMake(0, 0, self.lieBGView.frame.size.width *[[self.dataDic objectForKey:@"fakeper"] floatValue]/100, 10);

        
        self.topBGView.frame = CGRectMake(0, self.topView.frame.size.height, SCREEN_WIDTH, 40);
        self.sv.frame = CGRectMake(0, self.topView.frame.size.height + self.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 104);
        
        
        
        self.sv.frame = CGRectMake(0, self.topView.frame.size.height + self.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        //self.dealVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.assureVC.view.frame = CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.locationVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        CGRect tempTable = self.locationVC.tableview.frame;
        tempTable.size.height = self.locationVC.view.frame.size.height;
        self.locationVC.tableview.frame = tempTable;
        
        activity.center = _topView.center;
    }];
}
//变小
- (void)pullUpBtns
{
    if (isDown) {
        return;
    }
    isDown = YES;
    isBig = NO;
    [UIView animateWithDuration:0.35 animations:^{
        for (int i = 36; i > 1; i--) {
            double delayInSeconds = 0.01*i;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.logoImageV.frame = CGRectMake(25/2, 25/2, 75-1*i, 75-1*i);
                self.logoImageV.layer.cornerRadius = (75-1*i)/2;
            });
        }
        
        self.rightTopPic.hidden = NO;
        self.rightTopBtn.hidden = NO;
        self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
        NSString *memo = [self.dataDic objectForKey:@"memo"];
        if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
            self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
            self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
            NSString *str = [self.dataDic objectForKey:@"nickname"];
            if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
            }else{
                self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);                }
        }else{
            self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
            self.remarkLabel.text = memo;
            if (memo.length >=7) {
                self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
            }else{
                self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);                }
            
        }
//        self.remarkLabel.frame = CGRectMake(15 + 40 +21, 27, self.labelRect.size.width, self.labelRect.size.height);
        self.sexImageV.frame = CGRectMake(25/2+40+16+self.remarkLabel.frame.size.width + 6 + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
         self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
        
//        self.nikeNameLabel.alpha = 0;
        self.signLabel.alpha = 0;
        self.honestyLabel.alpha = 0;
        self.lieLabel.alpha = 0;
        self.addressLabel.alpha = 0;
        self.addressImageV.alpha = 0;
        self.honestyBGView.alpha = 0;
        self.lieBGView.alpha = 0;
        self.liePercentLabel.alpha = 0;
        self.hoestyPercentLabel.alpha = 0;
        self.honestyOnView.alpha = 0;
        self.lieOnView.alpha = 0;
        self.pullUpBtn.alpha = 0;
        self.pullUpBtn.hidden = YES;
        
        self.topView.image = [UIImage imageNamed:@"bg.jpg"];
        self.topBGView.frame = CGRectMake(0, self.topView.frame.size.height, SCREEN_WIDTH, 40);

        self.sv.frame = CGRectMake(0, self.topView.frame.size.height + self.topBGView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        //self.dealVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.assureVC.view.frame = CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        self.locationVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.frame.size.height - self.topBGView.frame.size.height - 64);
        CGRect tempTable = self.locationVC.tableview.frame;
        tempTable.size.height = self.locationVC.view.frame.size.height;
        self.locationVC.tableview.frame = tempTable;
        
        activity.center = _topView.center;
    }];
}

//点击进入个人信息
- (void)tapToPersonalMessage
{
//    PersonImformationViewController *personalIVC = [[PersonImformationViewController alloc] init];
//    personalIVC.headImageUrl = [self.dataDic objectForKey:@"avatar"];
//    personalIVC.name = [self.dataDic objectForKey:@"nickname"];
//    personalIVC.sex = [self.dataDic objectForKey:@"sex"];
//    personalIVC.position = [self.dataDic objectForKey:@"location"];
//    personalIVC.birthday = [self.dataDic objectForKey:@"birthday"];
//    personalIVC.sign = [self.dataDic objectForKey:@"sign"];
//    [self.navigationController pushViewController:personalIVC animated:YES];
    
    
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    NSString * urlStr = [self.dataDic objectForKey:@"avatar"];
    imageVC.imageUrl = [urlStr stringByReplacingOccurrencesOfString:@"_sm" withString:@""];
    imageVC.imgIndex = 1;
    //[self presentViewController:imageVC animated:YES completion:nil];
    
    NSString * tempString = [urlStr stringByReplacingOccurrencesOfString:@"_sm" withString:@""];
    NSURL * url = [NSURL URLWithString:tempString];
    JTSImageInfo * imageInfo = [[JTSImageInfo alloc]init];
    
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tempView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [tempView addGestureRecognizer:tapGesture];
    
    UIView * secondView = [[UIView alloc]initWithFrame:tempView.frame];
    secondView.backgroundColor = [UIColor blackColor];
    secondView.alpha = 0.7;

    UIActivityIndicatorView * tempActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    tempActivity.center = tempView.center;
    [tempActivity setHidesWhenStopped:YES];
    [tempActivity startAnimating];
    
    [tempView addSubview:secondView];
    [tempView addSubview:tempActivity];
    [[[[UIApplication sharedApplication]windows]lastObject] addSubview:tempView];
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [tempActivity stopAnimating];
        
        if (image == nil) {
            [AutoDismissAlert autoDismissAlert:@"获取头像失败"];
            return;
        }
        
        imageInfo.image = image;
        imageInfo.referenceRect = self.logoImageV.frame;
        imageInfo.referenceView = self.logoImageV.superview;
        
        JTSImageViewController * jtImageVC = [[JTSImageViewController alloc]initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_None];
        self.tempJtsVC = jtImageVC;
        [jtImageVC showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        [tempView removeFromSuperview];
    }];

}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [(UIView *)tap.view removeFromSuperview];
    [[SDWebImageManager sharedManager]cancelAll];
}

//网络请求
- (void)urlRequestPostT
{
    if (self.account == nil || [self.account isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"账号不存在"];
        return;
    }
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            
            [self customView];
            //赋值部分
            NSString *memo = [self.dataDic objectForKey:@"memo"];
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.navigationItem.title = [self.dataDic objectForKey:@"nickname"];
                self.nickname = [self.dataDic objectForKey:@"nickname"];
            }else{
                self.navigationItem.title = memo;
                self.nickname = memo;
            }
            
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
                NSString *str = [self.dataDic objectForKey:@"nickname"];
                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
                }else{
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);
                }
            }else{
                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = memo;
                if (memo.length >=7) {
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
                }else{
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);                }
                
            }
            
            self.sexImageV.frame = CGRectMake(25/2+40+16+self.remarkLabel.frame.size.width + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
            self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
            self.xingzuoImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"xingzuo-%@",[self.dataDic objectForKey:@"constellationcode"]]];
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                self.sexImageV.image = [UIImage imageNamed:@"woman"];
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
                self.sexImageV.image = [UIImage imageNamed:@"man"];
            }
            [self.logoImageV sd_setImageWithURL:[self.dataDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//            self.avatar = [self.dataDic objectForKey:@"avatar"];
            self.logoImageV.contentMode = UIViewContentModeScaleAspectFill;
            self.logoImageV.clipsToBounds = YES;
            
            
//            CGRect rect = [[self.dataDic objectForKey:@"sign"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25/2 - 75- 16 - 15, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
//            CGRect signLabelFram = self.signLabel.frame;
//            signLabelFram.size.height = rect.size.height;
//            
//            self.signLabel.frame = signLabelFram;
            self.signLabel.text = [self.dataDic objectForKey:@"sign"];
            if ([[self.dataDic objectForKey:@"location"] length] == 0) {
                self.addressImageV.hidden = YES;
            }
            self.addressLabel.text = [self.dataDic objectForKey:@"location"];
            self.friendId = [self.dataDic objectForKey:@"friendId"];
            self.avatar = [self.dataDic objectForKey:@"avatar"];
//            self.imageArray = @[[self.dataDic objectForKey:@"avatar"]];
            
            if ([self.dataDic objectForKey:@"postCount"] != nil) {
                [relationBtn setTitle:[NSString stringWithFormat:@"买卖 (%@)",[self.dataDic objectForKey:@"postCount"]] forState:UIControlStateNormal];
            }
            if ([self.dataDic objectForKey:@"topicCount"] != nil) {
                [circleBtn setTitle:[NSString stringWithFormat:@"话题 (%@)",[self.dataDic objectForKey:@"topicCount"]] forState:UIControlStateNormal];
            }
            if ([self.dataDic objectForKey:@"locationCount"] != nil) {
                [totalBtn setTitle:[NSString stringWithFormat:@"足迹 (%@)",[self.dataDic objectForKey:@"locationCount"]] forState:UIControlStateNormal];
            }

            self.hoestyPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"evaluationper"] floatValue]];
            self.liePercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"fakeper"] floatValue]];
            self.honestyOnView.frame = CGRectMake(0, 0, self.honestyBGView.frame.size.width *[[self.dataDic objectForKey:@"evaluationper"] floatValue]/100, 10);
            self.lieOnView.frame = CGRectMake(0, 0, self.lieBGView.frame.size.width *[[self.dataDic objectForKey:@"fakeper"] floatValue]/100, 10);
            
        }else if(result == 4){
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [activity stopAnimating];
    }];
}

//网络请求
- (void)urlRequestPostTAgain
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            //赋值部分
            NSString *memo = [self.dataDic objectForKey:@"memo"];
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
                self.navigationItem.title = [self.dataDic objectForKey:@"nickname"];
                NSString *str = [self.dataDic objectForKey:@"nickname"];
                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                    [self bigOrSmallWidth:150];
                }else{
                    [self bigOrSmallWidth:self.labelRect.size.width];
                }
            }else{
                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = memo;
                self.navigationItem.title = memo;
                if (memo.length >=7) {
                    [self bigOrSmallWidth:150];
                }else{
                    [self bigOrSmallWidth:self.labelRect.size.width];
                }
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                self.sexImageV.image = [UIImage imageNamed:@"woman"];
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
                self.sexImageV.image = [UIImage imageNamed:@"man"];
            }
            [self.logoImageV sd_setImageWithURL:[self.dataDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.logoImageV.contentMode = UIViewContentModeScaleAspectFill;
            self.logoImageV.clipsToBounds = YES;
            self.signLabel.text = [self.dataDic objectForKey:@"sign"];
            if ([[self.dataDic objectForKey:@"location"] length] == 0) {
                self.addressImageV.hidden = YES;
            }
            self.addressLabel.text = [self.dataDic objectForKey:@"location"];
            self.friendId = [self.dataDic objectForKey:@"friendId"];
            self.avatar = [self.dataDic objectForKey:@"avatar"];
            
            [relationBtn setTitle:[NSString stringWithFormat:@"买卖 (%@)",[self.dataDic objectForKey:@"postCount"]] forState:UIControlStateNormal];
            [circleBtn setTitle:[NSString stringWithFormat:@"话题 (%@)",[self.dataDic objectForKey:@"topicCount"]] forState:UIControlStateNormal];
            [totalBtn setTitle:[NSString stringWithFormat:@"足迹 (%@)",[self.dataDic objectForKey:@"locationCount"]] forState:UIControlStateNormal];
            
            self.hoestyPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"evaluationper"] floatValue]];
            self.liePercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"fakeper"] floatValue]];
            self.honestyOnView.frame = CGRectMake(0, 0, self.honestyBGView.frame.size.width *[[self.dataDic objectForKey:@"evaluationper"] floatValue]/100, 10);
            self.lieOnView.frame = CGRectMake(0, 0, self.lieBGView.frame.size.width *[[self.dataDic objectForKey:@"fakeper"] floatValue]/100, 10);
            
        }else if(result == 4){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [activity stopAnimating];
    }];
}

- (void)bigOrSmallWidth:(int)width
{
    if (!isBig) {
        self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, width, self.labelRect.size.height);
        self.sexImageV.frame = CGRectMake(25/2+40+16+width + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
        self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
    }else{
        self.remarkLabel.frame = CGRectMake(25/2+75+16, 45/2, width, self.labelRect.size.height);
        self.sexImageV.frame = CGRectMake(25/2+75+16+width + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
        self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
    }
}
//检查是否在线
- (void)checkOnline
{
    if (self.account == nil || [self.account isEqualToString:@""]) {
        
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"checkRongcloudOnline" parameters:@{@"user":self.account}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *status = [[dic objectForKey:@"data"]objectForKey:@"status"];
        NSLog(@"status == %@",status);
        if ([status isEqualToString:@"1"]) {
            [self.chatbutton setImage:[UIImage imageNamed:@"online"] forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"0"]){
            [self.chatbutton setImage:[UIImage imageNamed:@"unonline"] forState:UIControlStateNormal];
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
