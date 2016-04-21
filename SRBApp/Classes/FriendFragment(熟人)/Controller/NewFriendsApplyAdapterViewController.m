//
//  NewFriendsApplyAdapterViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "NewFriendsApplyAdapterViewController.h"
#import "MJRefresh.h"
#import "FriendFragmentModel.h"
#import "FriendBaseCell.h"
#import "ZZGoPayBtn.h"
#import "AppDelegate.h"
#import "FriendMoreViewController.h"
#import "FriendsViewController.h"
#import "PersonalViewController.h"
#import "CommonFriendViewController.h"
#import "CommonFriendLabel.h"

#import "RCIM.h"
#import "RCTextMessage.h"

static int page = 0;
static int count = NumOfItemsForShuren;
@interface NewFriendsApplyAdapterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,RCSendMessageDelegate>

//@interface NewFriendsApplyAdapterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,RCSendMessageDelegate>
@end

@implementation NewFriendsApplyAdapterViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;
    NoDataView * imageview;
//    BOOL isOperation;
    BOOL isBack;
    NSString * tempFriendID;
    BOOL _canedit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新的熟人";
    isBack = NO;
    [self customInit];
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


- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NewFriendModel * newFriendModel = [dataArray objectAtIndex:indexPath.row];
        NSDictionary * dic = [self parametersForDic:@"accountHiddenFriendApply" parameters:@{ACCOUNT_PASSWORD,@"friendId":newFriendModel.friendId}];
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"] intValue];
            if (result == 0) {
                if (dataArray.count == 0) {
                    imageview.hidden = NO;
                }
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }];
        //    [self delItem:indexPath];
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - 控件初始化
- (void)customInit
{
    UIButton * buttons = [UIButton buttonWithType:UIButtonTypeCustom];
    buttons.frame = CGRectMake(0, 0, 20, 20);
    [buttons addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [buttons setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttons];

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 12, 25);
    [button addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableview];
    tableview.backgroundColor = [UIColor clearColor];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    imageview.center = tableview.center;
    [tableview addSubview:imageview];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBaseCell * cell = [FriendBaseCell friendBaseCellWithTableView:tableView];
    cell.friendNewModel = dataArray[indexPath.row];
    cell.addBtn.indexpath = indexPath;
//    cell.ignoreBtn.indexpath = indexPath;
    [cell.addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.commonFriendBtn.indexpath = indexPath;
    [cell.commonFriendBtn addTarget:self action:@selector(commentFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logoImg.tag = indexPath.row;
    //头像点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
    [cell.logoImg addGestureRecognizer:tap];
    return cell;
}

- (void)commentFriend:(ZZGoPayBtn *)tap
{
    CommonFriendViewController * commonFriendVC = [[CommonFriendViewController alloc]init];
    FriendSearchModel *model = [dataArray objectAtIndex:tap.indexpath.row];
    commonFriendVC.sellerAccount = model.account;
    [self.navigationController pushViewController:commonFriendVC animated:YES];
}

//进入个人主页
- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    NewFriendModel *model = dataArray[sender.view.tag];
    personalVC.myRun = @"2";
    personalVC.account = model.account;
    NSLog(@"model.account == %@",personalVC.account);
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 加好友和忽略
- (void)addFriend:(ZZGoPayBtn *)sender
{
    FriendFragmentModel * friendModel = dataArray[sender.indexpath.row];
    NSDictionary * dic = [self parametersForDic:@"accountAgreeFriend" parameters:@{ACCOUNT_PASSWORD,@"friendId":friendModel.friendId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"修改备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * text = [alertView textFieldAtIndex:0];
            text.delegate = self;
            [text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            text.returnKeyType = UIReturnKeyDone;
            text.placeholder = @"填写备注名";
            tempFriendID = [[dic objectForKey:@"data"] objectForKey:@"friendId"];
            [alertView show];
            AppDelegate *app  = APPDELEGATE;
            [app getFriendArr];
            //            isOperation = YES;
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview reloadData];
        [tableview headerBeginRefreshing];
    } andFailureBlock:^{
        
    }];
    
    
//    RCTextMessage *content = [[RCTextMessage alloc] init];
//    content.content = @"我通过了你的熟人申请，现在我们可以聊天了";
//    content.pushContent = @"我通过了你的熟人申请，现在我们可以聊天了";
//    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:friendModel.account content:content delegate:self];
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
        if (chNum >= 6) {
            _canedit = NO;
        }
        if (!position) {
            if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
                NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
                text.text = [toBeString substringToIndex:tempIndex];
                _canedit = YES;
            }
        }
    }
    else{
        if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
            NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
            text.text = [toBeString substringToIndex:tempIndex];
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
    
    if ([ChangeSizeOfNSString convertToInts:toBeString] <= 12) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)panduan:(NSString *)str
{
    
    if (str.length == 0 || str == nil || [str isEqualToString:@""]) {
        return;
    }
    if ([ChangeSizeOfNSString convertToInts:str] > 12) {
        [AutoDismissAlert autoDismissAlert:@"备注过长,请控制字数"];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"修改备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * text = [alertView textFieldAtIndex:0];
        text.delegate = self;
        text.returnKeyType = UIReturnKeyDone;
        [text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        text.placeholder = @"修改备注";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertView show];
        });
        return;
    }
    NSDictionary * dic = [self parametersForDic:@"accountMemoFriend" parameters:@{ACCOUNT_PASSWORD,@"friendId":tempFriendID,@"memo":str}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequestPost];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField * text = [alertView textFieldAtIndex:0];
        [self panduan:text.text];
    }
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    UITextField * text = [alertView textFieldAtIndex:0];
//    if (buttonIndex == 1) {
//        FriendFragmentModel * friendModel = dataArray[alertView.tag];
//        NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
//        NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
//        NSDictionary * dic = [self parametersForDic:@"accountDeleteFriendApply" parameters:@{@"account":name,@"password":pass,@"friendId":friendModel.friendId,@"say":text.text}];
//        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//            int result = [[dic objectForKey:@"result"] intValue];
//            if (result == 0) {
//
//            }else if(result == 4){
//                
//            }else{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//            [tableview headerBeginRefreshing];
//        }];
//    }
//}

- (void)ignoreBtn:(ZZGoPayBtn *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"原因..." message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = sender.indexpath.row;
    [alert show];
}


#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendApply" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                NewFriendModel * newFriendModel = [[NewFriendModel alloc]init];
                [newFriendModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:newFriendModel];
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        imageview.hidden = NO;
        [dataArray removeAllObjects];
        [tableview reloadData];
        page = 0;
        [tableview headerEndRefreshing];
    }];

}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForShuren;
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendApply" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForShuren]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                NewFriendModel * newFriendModel = [[NewFriendModel alloc]init];
                [newFriendModel setValuesForKeysWithDictionary:tempdic];
                
                NSInteger tempTotal = dataArray.count < 10 ? dataArray.count : [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
                [dataArray addObject:newFriendModel];
                if (dataArray.count > tempTotal) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForShuren;
                    break;
                }
            }
            imageview.hidden = YES;
            [tableview reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForShuren;
        }else{
            page -= NumOfItemsForShuren;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForShuren;
        [tableview footerEndRefreshing];
    }];
    
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
