//
//  SearchFriendViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "PersonalViewController.h"
#import "FriendBaseCell.h"
#import "MJRefresh.h"
#import "FriendSearchModel.h"
#import "NoDataView.h"
#import "ZZGoPayBtn.h"
#import "PersonalViewController.h"
#import "ZZNavigationController.h"
#import "AppDelegate.h"
#import "LogoImgView.h"
#import "CommonFriendLabel.h"
#import "CommonFriendViewController.h"
static int page = 0;
@interface SearchFriendViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation SearchFriendViewController
{
    UITableView * _tableview;
    NSMutableArray * _resultsData;          //搜索结果
    UISearchBar * mySearchBar;
    NoDataView * imageview;
    BOOL isBack;
    BOOL _canedit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    self.title = @"添加熟人";
    [self customInit];
}
- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
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

- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    _resultsData = [NSMutableArray array];
    //是否全屏
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //tableView
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40 - 64);
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.rowHeight = 60;
    _tableview.tableFooterView = [[UIView alloc]init];
    [_tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview: _tableview];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"昵称/手机号/邀请码";
    [self.view addSubview:mySearchBar];

    for (UIView * view in mySearchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
//        //分割线的位置不带偏移
//        _tableview.separatorInset = UIEdgeInsetsZero;
//    }
    
    [mySearchBar becomeFirstResponder];
    
    //无内容时显示
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageview.hidden = YES;
    //imageview.center = _tableview.center;
    [_tableview addSubview:imageview];
    
}

#pragma mark - UIsearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
   
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self urlRequestForSearch];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - tableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendBaseCell * cell = [FriendBaseCell friendBaseCellWithTableView:tableView];
    cell.friendSearchModel = _resultsData[indexPath.row];
    cell.addBtn.indexpath = indexPath;
    [cell.addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logoImg.indexpath = indexPath;
    cell.commonFriendBtn.indexpath = indexPath;
    [cell.commonFriendBtn addTarget:self action:@selector(commentFriend:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapToPersonal:)];
    [cell.logoImg addGestureRecognizer:tap];
    return cell;
}

- (void)commentFriend:(ZZGoPayBtn *)tap
{
    CommonFriendViewController * commonFriendVC = [[CommonFriendViewController alloc]init];
    FriendSearchModel *model = [_resultsData objectAtIndex:tap.indexpath.row];
    commonFriendVC.sellerAccount = model.account;
    [self.navigationController pushViewController:commonFriendVC animated:YES];
}

- (void)TapToPersonal:(UITapGestureRecognizer *)tap
{
    LogoImgView * logoImg = (LogoImgView *)tap.view;
    FriendSearchModel *model = [_resultsData objectAtIndex:logoImg.indexpath.row];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.account = model.account;
    personalVC.nickname = model.nickname;
    [self.navigationController pushViewController:personalVC animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultsData.count;
}

#pragma mark - 添加朋友
- (void)addFriend:(ZZGoPayBtn *)sender
{
    [self.view endEditing:YES];
    NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加熟人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * text = [alert textFieldAtIndex:0];
    text.delegate = self;
    text.returnKeyType = UIReturnKeyDone;
    [text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    text.placeholder = [NSString stringWithFormat:@"我是%@",nickName];
    alert.tag = sender.indexpath.row;
    [alert show];
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
    UITextField * text = [alertView textFieldAtIndex:0];
   
    if (buttonIndex == 1) {
        
        NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        if ([text.text isEqualToString:@""] || text.text.length == 0) {
            text.text = [NSString stringWithFormat:@"我是%@",nickName];
        }
        
        if (_resultsData == nil || _resultsData.count == 0) {
            return;
        }
        [HUD removeFromSuperview];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"处理中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        FriendSearchModel * searchModel = _resultsData[alertView.tag];
//        NSString * sayStr = text.text;
//        if (sayStr == nil || [sayStr isEqualToString:@""] || sayStr.length == 0) {
//            sayStr = [NSString stringWithFormat:@"我是%@,我想加你为好友",name];
//        }else{
//            sayStr = text.text;
//        }
        NSDictionary * tempdic = [self parametersForDic:@"accountApplyFriend" parameters:@{ACCOUNT_PASSWORD,@"friendAccount":searchModel.account,@"say":text.text}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [AutoDismissAlert autoDismissAlert:@"已发送添加熟人请求"];
                [self urlRequestForSearch];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [HUD removeFromSuperview];
        } andFailureBlock:^{
            [HUD removeFromSuperview];
        }];
    }
}

#pragma mark - 搜索post请求
- (void)urlRequestForSearch
{
    NSDictionary * dic = [self parametersForDic:@"accountSearchFriend" parameters:@{ACCOUNT_PASSWORD,@"keyword":mySearchBar.text,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForShuren]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //[HUD removeFromSuperview];
        [_resultsData removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i =0; i <temparrs.count; i++) {
                NSDictionary * tempDic = temparrs[i];
                FriendSearchModel * friendSearchModel = [[FriendSearchModel alloc]init];
                [friendSearchModel setValuesForKeysWithDictionary:tempDic];
                [_resultsData addObject:friendSearchModel];
            }
            imageview.hidden = YES;
        }else if ([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
        }
        [_tableview reloadData];
        page = 0;
        [_tableview headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        imageview.hidden = NO;
        [_resultsData removeAllObjects];
        [_tableview reloadData];
        [_tableview headerEndRefreshing];
        
    }];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestForSearch];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForShuren;
    NSDictionary * dic = [self parametersForDic:@"accountSearchFriend" parameters:@{ACCOUNT_PASSWORD,@"keyword":mySearchBar.text,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForShuren]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                FriendSearchModel * friendSearchModel = [[FriendSearchModel alloc]init];
                [friendSearchModel setValuesForKeysWithDictionary:tempdic];
                [_resultsData addObject:friendSearchModel];
                if (_resultsData.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_resultsData removeLastObject];
                    page -= NumOfItemsForShuren;
                    break;
                }
            }
            imageview.hidden = YES;
            [_tableview reloadData];
        }else if(result == 4){
            page -= NumOfItemsForShuren;
        }else{
            page -= NumOfItemsForShuren;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForShuren;
        [_tableview footerEndRefreshing];
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
