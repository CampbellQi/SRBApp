//
//  FriendFragmentViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FriendFragmentViewController.h"
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

#import "ChangeGroupViewController.h"
#import "MyChatListViewController.h"
#import "PersonalViewController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "FriendMoreViewController.h"
#import "ZZNavigationController.h"
#import "LogoImgView.h"
#import "AMBlurView.h"

@interface FriendFragmentViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIImageView *zuijinSignView;   //新的消息提醒
@property (nonatomic, strong) UIImageView *signView;   //新的熟人提醒
@property (nonatomic, strong) UILabel *countNewLabel;  //新的熟人个数
@property (nonatomic, strong) UILabel *countZJLabel;  //新的消息个数
@property (nonatomic,strong)UIView * bgView;

@end

@implementation FriendFragmentViewController
{
    UITableView * _tableview;
    NSMutableArray * _resourceDataArray;    //数据源
    NSMutableArray * _resourceGroupArray;   //分组
    UITextField * nameText;
    UITextField * numText;
    NSString * name;
    NSString * pass;
    UIView * blurView;
    UIView * bgView;
    NSString * groupID;
    NSString * perNum;                      //人数
    FriendGroupModel * tempGroupModel;
    UIActionSheet * actionSheetCreate;
    UIActionSheet * actionSheetEdit;
    UIActionSheet * actionSheetMove;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"熟 人";
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 20, 20);
    [button1 addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    //初始化控件
    [self customInit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    [self getNewFriends];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if ([dataDic objectForKey:@"friend"]== nil) {
        [dataDic setObject:@"1" forKey:@"friend"];
        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.bgView];
    }
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor clearColor];
        
        UIView * tempBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tempBGView.backgroundColor = [UIColor blackColor];
        tempBGView.alpha = 0.4;
        [_bgView addSubview:tempBGView];
        
        UIImageView * alertImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 46, 165, 125)];
        alertImg.image = [UIImage imageNamed:@"alert_friend"];
        [_bgView addSubview:alertImg];
        UITapGestureRecognizer * removeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTap:)];
        [_bgView addGestureRecognizer:removeTap];
    }
    return _bgView;
}
- (void)removeTap:(UITapGestureRecognizer *)tap
{
    [_bgView removeFromSuperview];
}

- (void)reloadPost
{
    [_resourceGroupArray removeAllObjects];
    [_tableview reloadData];
    [self urlRequestPost];
    [self getNewFriends];
}

#pragma mark - 右上角button
- (void)more:(UIButton *)sender
{
    FriendMoreViewController * moreVC = [[FriendMoreViewController alloc]init];
    moreVC.array = @[@"发现熟人",@"导入通讯录",@"邀请熟人",@"意见反馈"];
    moreVC.imgArr = @[@"faxian",@"daorutongxunlu",@"yaoqinghaoyou", @"fankui"];
    [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
    [self addChildViewController:moreVC];
}

- (void)customInit
{
    
    actionSheetCreate = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建分组", nil];
    actionSheetCreate.tag = 5000;

    
    actionSheetEdit = [[UIActionSheet alloc]initWithTitle:@"编辑分组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加",@"删除",@"修改", nil];
    actionSheetEdit.tag = 5001;
    

    
    _resourceDataArray = [NSMutableArray array];
    _resourceGroupArray = [NSMutableArray array];
    
    //是否全屏
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self blurView];
    //tableView
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 49);
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.rowHeight = 60;
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.backgroundColor = [UIColor clearColor];
    [_tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableview headerBeginRefreshing];
    [self.view addSubview: _tableview];

    [self finishedPost];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNewNewsCount];
    [self urlRequestPost];
}

- (void)blurView
{
    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blurView.backgroundColor = [UIColor clearColor];
    
    UIView * tempBlurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tempBlurView.alpha = 0.4;
    tempBlurView.backgroundColor = [UIColor blackColor];
    [blurView addSubview:tempBlurView];

    bgView = [[UIView alloc]initWithFrame:CGRectMake(15, (SCREEN_HEIGHT - 180)/2, SCREEN_WIDTH - 30, 152)];
    bgView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 38)];
    topView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [bgView addSubview:topView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width - 120)/2, 11, 120, 16)];
    titleLabel.text = @"修改分组";
    titleLabel.font = SIZE_FOR_IPHONE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    nameText = [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.size.height + topView.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
    nameText.placeholder = @"修改分组名称";
//    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.delegate = self;
    nameText.font = SIZE_FOR_14;
    
    [bgView addSubview:nameText];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height + topView.frame.origin.y + 38, bgView.frame.size.width, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [bgView addSubview:lineView];
    
    numText = [[UITextField alloc]initWithFrame:CGRectMake(10, lineView.frame.size.height + lineView.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
    numText.placeholder = @"设置/修改分组顺序（数字序号）";
    numText.delegate = self;
//    numText.borderStyle = UITextBorderStyleRoundedRect;
    numText.font = SIZE_FOR_14;
    [bgView addSubview:numText];
    
    
    UIView * lineViews = [[UIView alloc]initWithFrame:CGRectMake(0, numText.frame.size.height + numText.frame.origin.y + 4, bgView.frame.size.width, 1)];
    lineViews.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [bgView addSubview:lineViews];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, lineViews.frame.size.height + lineViews.frame.origin.y + 4, bgView.frame.size.width/2, 30);
    //        cancelBtn.highlighted = YES;
    [cancelBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 111000;
    [cancelBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:RGBCOLOR(28, 0, 206, 1) forState:UIControlStateNormal];
    [sureBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(bgView.frame.size.width/2, lineViews.frame.size.height + lineViews.frame.origin.y + 4, bgView.frame.size.width/2, 30);
    sureBtn.tag = 111001;
    [sureBtn setTitle:@"修改" forState:UIControlStateNormal];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(bgView.frame.size.width / 2 - 1, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
    lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    [bgView addSubview:cancelBtn];
    [bgView addSubview:sureBtn];
    [bgView addSubview:lineView2];
    [blurView addSubview:bgView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = bgView.frame;
    rect.origin.y -= 70;
    bgView.frame = rect;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect rect = bgView.frame;
    rect.origin.y += 70;
    bgView.frame = rect;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)changeBtn:(UIButton *)btn
{
    
    if (btn.tag == 111001) {
        [self changeRequest];
    }
    if (btn.tag == 111000) {
        numText.text = @"";
        [blurView removeFromSuperview];
    }
}

#pragma mark - 搜索手势,最近联系人手势,新的熟人手势
- (void)searchVC:(UITapGestureRecognizer *)tap
{
    SearchFriendViewController * searchVC = [[SearchFriendViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)zuijinTap:(UITapGestureRecognizer *)tap
{
    //会话列表
    MyChatListViewController *zuijinVC = [[MyChatListViewController alloc]init];
    zuijinVC.portraitStyle = RCUserAvatarCycle;
    zuijinVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:zuijinVC animated:YES];
}

- (void)newTap:(UITapGestureRecognizer *)tap
{
    self.signView.hidden = YES;
    NewFriendsApplyAdapterViewController * newFriendVC = [[NewFriendsApplyAdapterViewController alloc]init];
    newFriendVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newFriendVC animated:YES];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroupModel * groupModel = _resourceGroupArray[section];
    NSArray * tempArr = groupModel.group;
    if (!groupModel.isZhedie) {
        return 0;
    }else{
        return tempArr.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _resourceGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBaseCell * cell = [FriendBaseCell friendBaseCellWithTableView:tableView];
    UILongPressGestureRecognizer * cellLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:cellLongPress];
    cell.indexpath = indexPath;
    [cell setFriendFragment:indexPath withFriendGroup:_resourceGroupArray[indexPath.section]];
    cell.logoImg.indexpath = indexPath;
    UITapGestureRecognizer * logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoTap:)];
    [cell.logoImg addGestureRecognizer:logoTap];
//    if (is_IOS_7) {
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
//    }

    return cell;
}

- (void)logoTap:(UITapGestureRecognizer *)tap
{
    LogoImgView * logoView = (LogoImgView *)tap.view;
    FriendGroupModel * groupModel = _resourceGroupArray[logoView.indexpath.section];
    NSArray * groupArr = groupModel.group;
    PersonalViewController * personalVC = [[PersonalViewController alloc]init];
    personalVC.account = [groupArr[logoView.indexpath.row] objectForKey:@"account"];
    //nickname
    personalVC.nickname = [groupArr[logoView.indexpath.row] objectForKey:@"nickname"];
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - 移动分组
- (void)cellLongPress:(UILongPressGestureRecognizer *)longPress
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    if (longPress.state == UIGestureRecognizerStateEnded) {
        FriendBaseCell * cell = (FriendBaseCell *)longPress.view;
        NSMutableArray * temparr = [NSMutableArray array];
        NSMutableArray * IDArr = [NSMutableArray array];
        for (int i = 0; i < _resourceGroupArray.count; i++) {
            FriendGroupModel * friendGroupModel = _resourceGroupArray[i];
            [temparr addObject:friendGroupModel.groupName];
            [IDArr addObject:friendGroupModel.groupId];
        }
        
        UIActionSheet * actionsheet = [[UIActionSheet alloc]initWithTitle:@"移动至" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i = 0; i < temparr.count; i++) {
            [actionsheet addButtonWithTitle:temparr[i]];
        }
        [actionsheet addButtonWithTitle:@"取消"];
        actionsheet.cancelButtonIndex = actionsheet.numberOfButtons - 1;
        actionsheet.tag = 5002;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
//        [SGActionView showSheetWithTitle:@"移动至" itemTitles:temparr itemSubTitles:nil selectedIndex:10 selectedHandle:^(NSInteger index) {
            //[friendVC yidongFenzu:cell andIndex:index andArr:temparr];
        
        __weak FriendFragmentViewController * friendVC = self;
        __weak NSMutableArray * tempResourceGroupArray = _resourceGroupArray;
        __weak NSString * tempName = name;
        __weak NSString * tempPass = pass;
        self.moveBlock=  ^(NSInteger index){
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:friendVC.view animated:YES];
            hud.labelText = @"操作中,请稍后";
            hud.dimBackground = YES;
            [hud show:YES];
            FriendGroupModel * friendGroupModel = tempResourceGroupArray[cell.indexpath.section];
            NSDictionary * tempdic = friendGroupModel.group[cell.indexpath.row];
            NSDictionary * dic = [friendVC parametersForDic:@"accountMoveFriend" parameters:@{@"account":tempName,@"password":tempPass,@"friendId":[tempdic objectForKey:@"friendId"],@"groupId":[IDArr objectAtIndex:index]}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    NSLog(@"%@",[dic objectForKey:@"message"]);
                    [friendVC urlRequestPost];
                }else{
                    NSLog(@"%@",[dic objectForKey:@"message"]);
                }
                [hud removeFromSuperview];
            }];
        };
//        }];
    }
}


- (void)yidongFenzu:(FriendBaseCell *)cell andIndex:(NSInteger)index andArr:(NSMutableArray *)temparr
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"操作中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    FriendGroupModel * friendGroupModel = _resourceGroupArray[cell.indexpath.section];
    NSDictionary * tempdic = friendGroupModel.group[cell.indexpath.row];
    NSDictionary * dic = [self parametersForDic:@"accountMoveFriend" parameters:@{@"account":name,@"password":pass,@"friendId":[tempdic objectForKey:@"friendId"],@"groupId":[temparr objectAtIndex:index]}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [self urlRequestPost];
        }else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
        [HUD removeFromSuperview];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //单聊
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
    if (nil == myChatVC) {
        myChatVC =[[MyChatViewController alloc]init];
        myChatVC.portraitStyle = RCUserAvatarCycle;
    }
    FriendGroupModel * friendGroupModel = _resourceGroupArray[indexPath.section];
    NSDictionary * tempDic = friendGroupModel.group[indexPath.row];
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = [tempDic objectForKey:@"account"];
    user.name = [tempDic objectForKey:@"nickname"];
    user.portraitUri = [tempDic objectForKey:@"avatar"];
    
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myChatVC animated:YES];
}


#pragma mark - 长按事件
- (void)longpress:(UILongPressGestureRecognizer *)longpress
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    FriendGroupModel * groupModel = _resourceGroupArray[longpress.view.tag];
    tempGroupModel = groupModel;
    if (longpress.state == UIGestureRecognizerStateEnded) {
        //如果是未分组
        if (longpress.view.tag == 0) {
//            [SGActionView showSheetWithTitle:@"选择" itemTitles:@[@"添加"] itemSubTitles:@[@"(添加一个分组)"] selectedIndex:10 selectedHandle:^(NSInteger index) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加分组" message:@"分组名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                alert.tag = longpress.view.tag;
//                [alert show];
//            }];
            
            [actionSheetCreate showInView:[UIApplication sharedApplication].keyWindow];
            
        }else{
//            [SGActionView showSheetWithTitle:@"选择" itemTitles:@[@"添加",@"删除",@"修改"] itemSubTitles:@[@"(添加一个分组)",@"(删除该分组)",@"(修改该分组的名称以及顺序)"] selectedIndex:10 selectedHandle:^(NSInteger index) {
//                //第0组
//                if (index ==0) {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加分组" message:@"分组名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    alert.tag = longpress.view.tag;
//                    [alert show];
//                }else if (index == 1){
//                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:@"您确定要删除该分组吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alertView.tag = 10000;
//                    groupID = groupModel.groupId;
//                    [alertView show];
//                }else{
////                    ChangeGroupViewController * changeGroupVC = [[ChangeGroupViewController alloc]init];
////                    changeGroupVC.groupName = groupModel.groupName;
////                    changeGroupVC.index = longpress.view.tag;
////
////                    [self.view addSubview:blurView];
//                    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    nameText.text = groupModel.groupName;
//                    [app.mainTab.view addSubview:blurView];
//                    groupID = groupModel.groupId;
//                    [nameText becomeFirstResponder];
//                }
//            }];
            
            [actionSheetEdit showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

#pragma mark - 修改分组名称
- (void)changeRequest
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //过滤空格,以及判断留言是否为空
//    NSString * textStr = [nameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * textStr = nameText.text;
    if (textStr == nil || textStr.length == 0 ||[textStr isEqualToString:@""]) {
//        [AutoDismissAlert autoDismissAlert:@"请输入分组名称"];
//        return;
        textStr = @"";
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"操作中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
//    FriendGroupModel * groupModel = _resourceGroupArray[index];
    
    NSString * groupNumText = numText.text;
    if (groupNumText.length == 0 || groupNumText == nil) {
        groupNumText = @"";
    }
    
    NSDictionary * tempDic = [self parametersForDic:@"accountModifyFriendGroup" parameters:@{@"account":name,@"password":pass,@"groupId":groupID,@"groupName":textStr,@"groupOrder":groupNumText}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:tempDic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [self urlRequestPost];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        numText.text = @"";
        [HUD removeFromSuperview];
        [blurView removeFromSuperview];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textString = textField.text;
    NSUInteger length = [textString length];
    
    BOOL bChange =YES;
    if (length >= 14)
        bChange = NO;
    
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 5000) {
        if (buttonIndex == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分组名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * tempText = [alert textFieldAtIndex:0];
            tempText.delegate = self;
//            [tempText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            tempText.tag = 3100;
            [alert show];
        }
    }else if(actionSheet.tag == 5001){
        //第0组
        if (buttonIndex ==0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分组名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * tempText = [alert textFieldAtIndex:0];
            tempText.delegate = self;
            tempText.tag = 3200;
//            [tempText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            alert.tag = 0;
            [alert show];
        }else if (buttonIndex == 1){
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"确定删除该分组?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10000;
            groupID = tempGroupModel.groupId;
            [alertView show];
        }else if(buttonIndex == 2){
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            nameText.text = tempGroupModel.groupName;
            numText.text = [tempGroupModel.groupOrder substringToIndex:tempGroupModel.groupOrder.length - 2];
            [app.mainTab.view addSubview:blurView];
            groupID = tempGroupModel.groupId;
            [nameText becomeFirstResponder];
        }
    }else if (actionSheet.tag == 5002){
        if (buttonIndex != actionSheet.numberOfButtons - 1) {
           self.moveBlock(buttonIndex);
        }
        if (buttonIndex == actionSheet.numberOfButtons - 1) {
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    
    if (buttonIndex == 1) {
        if (alertView.tag == 10000) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"操作中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            NSDictionary * tempdic = [self parametersForDic:@"accountDeleteFriendGroup" parameters:@{@"account":name,@"password":pass,@"groupId":groupID}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                NSLog(@"%d",result);
                if (result == 0) {
                    [self urlRequestPost];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD removeFromSuperview];
            }];
        }else{
            UITextField * text = [alertView textFieldAtIndex:0];
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"操作中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            //过滤空格,以及判断是否为空
//            NSString * textStr = [text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * textStr = text.text;
            if (textStr == nil || textStr.length == 0 ||[textStr isEqualToString:@""]) {
                textStr = @"";
            }
            NSDictionary * tempdic = [self parametersForDic:@"accountCreateFriendGroup" parameters:@{@"account":name,@"password":pass,@"groupName":textStr}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    [self urlRequestPost];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD removeFromSuperview];
        }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - 对分组进行优化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 分组头做优化,
    static NSString *HeaderID = @"myHeader";
    UIView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    
    if (myHeader == nil) {
        myHeader = [[UIView alloc]init];
    }
    myHeader.tag = section;
    UILongPressGestureRecognizer * longPressTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    longPressTap.minimumPressDuration = 0.5;
    [myHeader addGestureRecognizer:longPressTap];
    
    [myHeader setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
    FriendGroupModel * groupModel = _resourceGroupArray[section];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    //用button的tag属性记录section数值
    [button setTag:section];
    [button addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
    [myHeader addSubview:button];
    
    //增加三角指示图片
    UIImage *image = [UIImage imageNamed:@"hy_guan"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView setFrame:CGRectMake(25, 15, 4.5, 9.5)];
    [button addSubview:imageView];
    
    //分组信息
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, SCREEN_WIDTH - 45 - 5 - 50, 20)];
    infoLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    infoLabel.text = [NSString stringWithFormat:@"%@",groupModel.groupName];
    infoLabel.font = [UIFont systemFontOfSize:15];
    [button addSubview:infoLabel];
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50 - 15, 12.5, 50, 15)];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    numLabel.text = [NSString stringWithFormat:@"%@人",groupModel.count];
    numLabel.font = [UIFont systemFontOfSize:15];
    [button addSubview:numLabel];
    
    //分隔线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [button addSubview:lineView];
    
    // 根据对应的sction设定三角图片的旋转角度
    NSInteger sectionStatus = (NSInteger)groupModel.isZhedie;
    // 如果是0,表示折叠, 如果是1,表示展开,旋转90
    if (sectionStatus == 0) {
        [UIView animateWithDuration:1 animations:^{
          [imageView setTransform:CGAffineTransformMakeRotation(0)];
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            [imageView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }];
    }
    return myHeader;
}


#pragma mark - 聊天
- (void)chatBtn:(ZZGoPayBtn *)sender
{
    //单聊
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
    if (nil == myChatVC) {
        myChatVC =[[MyChatViewController alloc]init];
        myChatVC.portraitStyle = RCUserAvatarCycle;
    }
    FriendGroupModel * friendGroupModel = _resourceGroupArray[sender.indexpath.section];
    NSDictionary * tempDic = friendGroupModel.group[sender.indexpath.row];
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = [tempDic objectForKey:@"account"];
    user.name = [tempDic objectForKey:@"nickname"];
    user.portraitUri = [tempDic objectForKey:@"avatar"];
    
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myChatVC animated:YES];
}

#pragma mark - Actions
- (void)clickHeader:(UIButton *)button
{
    // 1. 知道点击的sction
    NSInteger section = button.tag;
    // 根据sctionInfo中的数值求反就可了.
    // 1.1 先从friendList中取出对应的字典
    FriendGroupModel * groupModel = _resourceGroupArray[section];
//    // 1.2 从字典中取出组名
//    NSString *groupName = groupModel.groupName;
//    // 1.3 设置sctionInfo中的数值
//    NSInteger sectionNumber = (NSInteger)groupModel.isZhedie;
    
    groupModel.isZhedie = !groupModel.isZhedie;
    
    
    // 刷新所有数据
    [_tableview reloadData];
    // a. 如果现在时展开的,那么折叠表格
    // b. 如果现在时折叠的,那么展开表格
}

#pragma mark - post请求
- (void)urlRequestPost
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendItem" parameters:@{@"account":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_resourceGroupArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                FriendGroupModel * friendGroupModel = [[FriendGroupModel alloc]init];
                [friendGroupModel setValuesForKeysWithDictionary:tempdic];
                friendGroupModel.isZhedie = YES;
                [_resourceGroupArray addObject:friendGroupModel];
            }
            [_tableview reloadData];
        }else if(result == 4){
            [_tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableview headerEndRefreshing];

    }];
    
}
#pragma mark - 请求完数据做的处理
- (void)finishedPost
{
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    _tableview.tableHeaderView = topBGView;
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 7.5, SCREEN_WIDTH - 30, 25)];
    searchView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 2;
    [topBGView addSubview:searchView];
    
    UIImageView * searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 15, 15)];
    searchImg.image = [UIImage imageNamed:@"hy_search"];
    [searchView addSubview:searchImg];
    
    UILabel * searchlabel = [[UILabel alloc]initWithFrame:CGRectMake(searchImg.frame.size.width + searchImg.frame.origin.x + 10, 5, 100, 14)];
    searchlabel.font = SIZE_FOR_14;
    searchlabel.text = @"昵称/手机号";
    searchlabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [searchView addSubview:searchlabel];
    
    UITapGestureRecognizer * searchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchVC:)];
    [searchView addGestureRecognizer:searchTap];
    
    SecondView * secondZuijinView = [[SecondView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 60)];
    secondZuijinView.logoImg.image = [UIImage imageNamed:@"rct_contacts"];
    secondZuijinView.titleLabel.text = @"最近联系人";
    [topBGView addSubview:secondZuijinView];
    
    //新消息数
    self.zuijinSignView = [[UIImageView alloc] initWithFrame:CGRectMake(secondZuijinView.titleLabel.frame.size.width + secondZuijinView.titleLabel.frame.origin.x, secondZuijinView.titleLabel.frame.origin.y + 4, 7, 7)];
    self.zuijinSignView.hidden = YES;
    self.zuijinSignView.image = [UIImage imageNamed:@"newfriend_notic"];
    [secondZuijinView addSubview:self.zuijinSignView];
    
    self.countZJLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, secondZuijinView.titleLabel.frame.origin.y - 2, 25, 20)];
    self.countZJLabel.textAlignment = NSTextAlignmentCenter;
    self.countZJLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.countZJLabel.font = [UIFont systemFontOfSize:14];
    [secondZuijinView addSubview:self.countZJLabel];
    
    
    SecondView * secondNewView = [[SecondView alloc]initWithFrame:CGRectMake(0, 101, SCREEN_WIDTH, 60)];
    secondNewView.logoImg.image = [UIImage imageNamed:@"new_friends"];
    secondNewView.titleLabel.text = @"新的熟人";
    [topBGView addSubview:secondNewView];
    
    self.signView = [[UIImageView alloc] initWithFrame:CGRectMake(secondNewView.titleLabel.frame.size.width + secondNewView.titleLabel.frame.origin.x, secondNewView.titleLabel.frame.origin.y + 4, 7, 7)];
    self.signView.hidden = YES;
    self.signView.image = [UIImage imageNamed:@"newfriend_notic"];
    [secondNewView addSubview:self.signView];
    
    //新的熟人人数
    self.countNewLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, secondNewView.titleLabel.frame.origin.y - 2, 25, 20)];
    self.countNewLabel.textAlignment = NSTextAlignmentCenter;
    self.countNewLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.countNewLabel.font = [UIFont systemFontOfSize:14];
    [secondNewView addSubview:self.countNewLabel];
    
    UITapGestureRecognizer * zuijinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zuijinTap:)];
    UITapGestureRecognizer * newTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newTap:)];
    [secondZuijinView addGestureRecognizer:zuijinTap];
    [secondNewView addGestureRecognizer:newTap];
}

//新的请求人数
- (void)getNewFriends
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendApplyCount" parameters:@{@"account":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * countNew = [[dic objectForKey:@"data"] objectForKey:@"count"];
        if ([countNew isEqualToString:@"0"]) {
            self.signView.hidden = YES;
            self.countNewLabel.text = @"0";
        }else{
            self.countNewLabel.text = countNew;
            self.signView.hidden = NO;
        }
    }];
}
//总消息数
- (void)getNewNewsCount
{
    AppDelegate * app = APPDELEGATE;
    int count = [[RCIM sharedRCIM] getTotalUnreadCount];

    if (count > 0) {
        self.zuijinSignView.hidden = NO;
        self.countZJLabel.text = [NSString stringWithFormat:@"%d",count];
    }else{
        self.countZJLabel.text = @"0";

        self.zuijinSignView.hidden = YES;

        app.signView.hidden = YES;
    }
}

- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
        [self getNewNewsCount];
        [self getNewFriends];
    });
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
