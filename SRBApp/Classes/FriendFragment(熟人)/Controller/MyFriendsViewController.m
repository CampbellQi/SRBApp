//
//  MyFriendsViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyFriendsViewController.h"
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

#import "MyChatListViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "FriendMoreViewController.h"
#import "ZZNavigationController.h"
#import "LogoImgView.h"
#import "AMBlurView.h"


@interface MyFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
//@property (nonatomic, strong) UIImageView *zuijinSignView;   //新的消息提醒
@property (nonatomic, strong) UIImageView *signView;   //新的熟人提醒
@property (nonatomic, strong) UILabel *countNewLabel;  //新的熟人个数
//@property (nonatomic, strong) UILabel *countZJLabel;  //新的消息个数


@end

@implementation MyFriendsViewController
{
    UITableView * _tableview;
    NSMutableArray * _resourceDataArray;    //数据源
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

- (void)changeRequest:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的熟人";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    //    自定义导航右按钮
    UIButton *customRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customRightBtn.frame = CGRectMake(0, 0, 62/2, 62/2);
    [customRightBtn setImage:[UIImage imageNamed:@"rc_bar_more"] forState:UIControlStateNormal];
    [customRightBtn addTarget:self action:@selector(creatGroup:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customRightBtn];
    
    //初始化控件
    [self customInit];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    
    
}

- (void)backBtn:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = NO;
    app.mainTab.tabBar.hidden = YES;
}


- (void)reloadPost
{
    [_resourceGroupArray removeAllObjects];
    [tempDataArr removeAllObjects];
    [_tableview reloadData];
    [self urlRequestPost];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)customInit
{
    
    actionSheetCreate = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建分组", nil];
    actionSheetCreate.tag = 5000;
    
    
    actionSheetEdit = [[UIActionSheet alloc]initWithTitle:@"编辑分组" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加",@"删除",@"修改", nil];
    actionSheetEdit.tag = 5001;
    
    
    _resourceDataArray = [NSMutableArray array];
    _resourceGroupArray = [NSMutableArray array];
    tempDataArr = [NSMutableArray array];
    searchResults = [NSMutableArray array];
    
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    mySearchBar.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    mySearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:mySearchBar.bounds.size];
    [mySearchBar setPlaceholder:@"搜索"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    //searchDisplayController.active = NO;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]init];

    
    for (UIView * view in mySearchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            UIView * tempView = view.subviews[0];
            tempView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
            break;
        }
    }
    
    //是否全屏
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self blurView];
    //tableView
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.rowHeight = 60;
    _tableview.tableFooterView = [[UIView alloc]init];
    _tableview.tableHeaderView = mySearchBar;
    _tableview.backgroundColor = [UIColor clearColor];
    [_tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableview headerBeginRefreshing];
    [self.view addSubview: _tableview];
    
    noDataView = [[NoDataView alloc]initWithFrame:_tableview.frame];
    noDataView.hidden = YES;
    [_tableview addSubview:noDataView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
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
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 110, SCREEN_WIDTH - 30, 152)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.95];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 38)];
    topView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:topView];
    
//    UIView * topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height + topView.frame.origin.y, bgView.frame.size.width, 1)];
//    topLineView.backgroundColor = [UIColor lightGrayColor];
//    [bgView addSubview:topLineView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((topView.frame.size.width - 120)/2, 10, 120, 18)];
    titleLabel.text = @"修改分组";
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    nameText = [[UITextField alloc]initWithFrame:CGRectMake(10, topView.frame.size.height + topView.frame.origin.y + 4, bgView.frame.size.width - 20, 30)];
    nameText.returnKeyType = UIReturnKeyDone;
    nameText.placeholder = @"修改分组名称";
    nameText.borderStyle = UITextBorderStyleRoundedRect;
    nameText.delegate = self;
    nameText.font = SIZE_FOR_14;
    
    [bgView addSubview:nameText];
    
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height + topView.frame.origin.y + 38, bgView.frame.size.width, 1)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [bgView addSubview:lineView];
    
    numText = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameText.frame) + 5, bgView.frame.size.width - 20, 30)];
    numText.placeholder = @"设置/修改分组顺序（数字序号）";
    numText.delegate = self;
    numText.borderStyle = UITextBorderStyleRoundedRect;
    numText.returnKeyType = UIReturnKeyDone;
    numText.keyboardType = UIKeyboardTypeNumberPad;
    numText.font = SIZE_FOR_14;
    [bgView addSubview:numText];
    
    
    UIView * lineViews = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numText.frame) + 8, bgView.frame.size.width, 1)];
    lineViews.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:lineViews];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, lineViews.frame.size.height + lineViews.frame.origin.y, bgView.frame.size.width/2, 36);
    [cancelBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 111000;
    [cancelBtn setTitleColor:RGBCOLOR(53, 137, 246, 1) forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:RGBCOLOR(53, 137, 246, 1) forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(bgView.frame.size.width/2, lineViews.frame.size.height + lineViews.frame.origin.y, bgView.frame.size.width/2, 36);
    sureBtn.tag = 111001;
    [sureBtn setTitle:@"修改" forState:UIControlStateNormal];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(bgView.frame.size.width / 2 - 1, cancelBtn.frame.origin.y, 1, cancelBtn.frame.size.height)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    
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
#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }else{
        FriendGroupModel * groupModel = _resourceGroupArray[section];
        NSArray * tempArr = groupModel.group;
        if (!groupModel.isZhedie) {
            return 0;
        }else{
            return tempArr.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return _resourceGroupArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBaseCell * cell = [FriendBaseCell friendBaseCellWithTableView:tableView];
    cell.indexpath = indexPath;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [cell setFriendFragmentModel:searchResults[indexPath.row]];
    }else{
       [cell setFriendFragment:indexPath withFriendGroup:_resourceGroupArray[indexPath.section]];
        UILongPressGestureRecognizer * cellLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:cellLongPress];
    }
    
    cell.logoImg.indexpath = indexPath;
//    UITapGestureRecognizer * logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoTap:)];
//    [cell.logoImg addGestureRecognizer:logoTap];
    //    if (is_IOS_7) {
    //        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    //    }
    
    return cell;
}

//- (void)logoTap:(UITapGestureRecognizer *)tap
//{
//    LogoImgView * logoView = (LogoImgView *)tap.view;
//    FriendGroupModel * groupModel = _resourceGroupArray[logoView.indexpath.section];
//    NSArray * groupArr = groupModel.group;
//    PersonalViewController * personalVC = [[PersonalViewController alloc]init];
//    personalVC.account = [groupArr[logoView.indexpath.row] objectForKey:@"account"];
//    //nickname
//    personalVC.nickname = [groupArr[logoView.indexpath.row] objectForKey:@"nickname"];
//    [self.navigationController pushViewController:personalVC animated:YES];
//}

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
        
        __weak MyFriendsViewController * friendVC = self;
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
            [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    NSLog(@"%@",[dic objectForKey:@"message"]);
                    [friendVC urlRequestPost];
                }else{
                    NSLog(@"%@",[dic objectForKey:@"message"]);
                }
                [hud removeFromSuperview];
            } andFailureBlock:^{
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
    FriendGroupModel * friendGroupModel = _resourceGroupArray[cell.indexpath.section];
    NSDictionary * tempdic = friendGroupModel.group[cell.indexpath.row];
    NSDictionary * dic = [self parametersForDic:@"accountMoveFriend" parameters:@{ACCOUNT_PASSWORD,@"friendId":[tempdic objectForKey:@"friendId"],@"groupId":[temparr objectAtIndex:index]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [self urlRequestPost];
        }else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        FriendFragmentModel * friendModel = searchResults[indexPath.row];
        PersonalViewController * personalVC = [[PersonalViewController alloc]init];
        personalVC.account = friendModel.account;
        //nickname
        personalVC.nickname = friendModel.nickname;
        [self.navigationController pushViewController:personalVC animated:YES];
    }else{
        FriendGroupModel * groupModel = _resourceGroupArray[indexPath.section];
        NSArray * groupArr = groupModel.group;
        PersonalViewController * personalVC = [[PersonalViewController alloc]init];
        personalVC.account = [groupArr[indexPath.row] objectForKey:@"account"];
        //nickname
        personalVC.nickname = [groupArr[indexPath.row] objectForKey:@"nickname"];
        [self.navigationController pushViewController:personalVC animated:YES];
    }
    
}
- (void)creatGroup:(UIButton *)sender
{
    [actionSheetCreate showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - 长按事件
- (void)longpress:(UILongPressGestureRecognizer *)longpress
{
    name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    FriendGroupModel * groupModel = _resourceGroupArray[longpress.view.tag];
    tempGroupModel = groupModel;
    if (longpress.state == UIGestureRecognizerStateEnded) {
        //如果不是未分组
        if (!longpress.view.tag == 0) {
            [actionSheetEdit showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

#pragma mark - 修改分组名称
- (void)changeRequest
{
    [self.view endEditing:YES];
    NSString * textStr = nameText.text;
    if (textStr == nil || textStr.length == 0 ||[textStr isEqualToString:@""]) {
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
    
    NSDictionary * tempDic = [self parametersForDic:@"accountModifyFriendGroup" parameters:@{ACCOUNT_PASSWORD,@"groupId":groupID,@"groupName":textStr,@"groupOrder":groupNumText}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempDic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequestPost];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        numText.text = @"";
        [HUD removeFromSuperview];
        [blurView removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
        [blurView removeFromSuperview];
    }];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString *textString = textField.text;
//    NSUInteger length = [textString length];
//    
//    BOOL bChange =YES;
//    if (length >= 14)
//        bChange = NO;
//    
//    if (range.length == 1) {
//        bChange = YES;
//    }
//    return bChange;
//}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for (UIView * tempView in alertView.subviews) {
        NSLog(@"%@",tempView);
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    for (UIView * tempView in alertView.subviews) {
        NSLog(@"%@",tempView);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 5000) {
        if (buttonIndex == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"分组名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * tempText = [alert textFieldAtIndex:0];
            tempText.delegate = self;
            tempText.returnKeyType = UIReturnKeyDone;
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
            tempText.returnKeyType = UIReturnKeyDone;
            tempText.tag = 3200;
            alert.tag = 0;
            [alert show];
        }else if (buttonIndex == 1){
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"确定删除该分组?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 10000;
            groupID = tempGroupModel.groupId;
            [alertView show];
        }else if(buttonIndex == 2){
            nameText.text = tempGroupModel.groupName;
            numText.text = [[tempGroupModel.groupOrder substringToIndex:tempGroupModel.groupOrder.length - 2] isEqualToString:@"0"] ? @"": [tempGroupModel.groupOrder substringToIndex:tempGroupModel.groupOrder.length - 2];
            [nameText becomeFirstResponder];
            [self.view addSubview:blurView];
            groupID = tempGroupModel.groupId;
            
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
    if (buttonIndex == 1) {
        if (alertView.tag == 10000) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"操作中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            NSDictionary * tempdic = [self parametersForDic:@"accountDeleteFriendGroup" parameters:@{ACCOUNT_PASSWORD,@"groupId":groupID}];
            [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    [self urlRequestPost];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD removeFromSuperview];
            } andFailureBlock:^{
                [HUD removeFromSuperview];
            }];
        }else{
            UITextField * text = [alertView textFieldAtIndex:0];
            
            //过滤空格,以及判断是否为空
            //            NSString * textStr = [text.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * textStr = text.text;
            if (textStr == nil || textStr.length == 0 ||[textStr isEqualToString:@""]) {
                textStr = @"";
                [AutoDismissAlert autoDismissAlert:@"名称不能为空"];
                return;
            }
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"操作中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            
            name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
            pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
            
            NSDictionary * tempdic = [self parametersForDic:@"accountCreateFriendGroup" parameters:@{@"account":name,@"password":pass,@"groupName":textStr}];
            [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    [self urlRequestPost];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
                [HUD removeFromSuperview];
            } andFailureBlock:^{
                [HUD removeFromSuperview];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        return 40;
    }
}


#pragma mark - 对分组进行优化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView) {
        return nil;
    }else{
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
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendItem" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_resourceGroupArray removeAllObjects];
        [tempDataArr removeAllObjects];
        
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                FriendGroupModel * friendGroupModel = [[FriendGroupModel alloc]init];
                [friendGroupModel setValuesForKeysWithDictionary:tempdic];
                friendGroupModel.isZhedie = YES;
                [_resourceGroupArray addObject:friendGroupModel];
                NSArray * personArr = friendGroupModel.group;
                for (int j = 0; j < personArr.count; j++) {
                    FriendFragmentModel * friendModel = [[FriendFragmentModel alloc]init];
                    NSDictionary * personDic = personArr[j];
                    [friendModel setValuesForKeysWithDictionary:personDic];
                    [tempDataArr addObject:friendModel];
                }
            }
            noDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            [_tableview reloadData];
            noDataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            noDataView.hidden = NO;
        }
        [_tableview reloadData];
        [_tableview headerEndRefreshing];
    } andFailureBlock:^{
        [_resourceGroupArray removeAllObjects];
        [tempDataArr removeAllObjects];
        [_tableview reloadData];
        [_tableview headerEndRefreshing];
        noDataView.hidden = NO;
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchString:(NSString *)searchString

{
    //一旦SearchBar輸入內容有變化，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    
    // Return YES to cause the search result table view to be reloaded.
    
    [self filterContentForSearchText:searchString
                               scope:[mySearchBar scopeButtonTitles][mySearchBar.selectedScopeButtonIndex]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller

shouldReloadTableForSearchScope:(NSInteger)searchOption

{
    //如果设置了选项，当Scope Button选项有變化的时候，則執行這個方法，詢問要不要重裝searchResultTableView的數據
    
    // Return YES to cause the search result table view to be reloaded.
    
    [self filterContentForSearchText:mySearchBar.text
                               scope:mySearchBar.scopeButtonTitles[searchOption]];
    
    return YES;
}

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
    
    NSArray *subViews;
    
    if (is_IOS_7) {
        subViews = [(mySearchBar.subviews[0]) subviews];
    }
    else {
        subViews = mySearchBar.subviews;
    }
    
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResults removeAllObjects];
    //NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < tempDataArr.count; i++) {
        FriendFragmentModel * friendModel = tempDataArr[i];
        NSString *storeString = friendModel.nickname;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [searchResults addObject:friendModel];
        }
    }
    
    
    //[searchResults addObjectsFromArray:tempResults];
}


- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
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
