//
//  AddressBookListActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AddressBookListActivityViewController.h"
#import "AddressBookListCell.h"
#import "PersonalViewController.h"
#import "AddressBookListModel.h"
#import <UIImageView+WebCache.h>
#import "SGActionView.h"
#import "AppDelegate.h"
#import "AskedAddressBookViewController.h"
#import "MJRefresh.h"
#import "MyImgView.h"


@interface AddressBookListActivityViewController ()<UIAlertViewDelegate>
{
    NSMutableArray * arr;
    NSString * message;
    int starta;
    int buttontag;
    NoDataView * noData;
    BOOL isOperation;
    BOOL isBack;
    UIView * topView;
    UIView * noDataView;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation AddressBookListActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现熟人";
    arr = [[NSMutableArray alloc]init];
    starta = 0;
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    topView.layer.shadowOffset = CGSizeMake(4, 2);
    topView.layer.shadowOpacity = 0.8;
    topView.hidden = YES;
    
    MyLabel * titleLabel = [[MyLabel alloc]initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH - 30 - 60 , 18)];
    titleLabel.text = @"导入通讯录，完善您的熟人圈";
    titleLabel.font = SIZE_FOR_IPHONE;
    titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [topView addSubview:titleLabel];
    
    UIButton * importBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    importBtn.frame = CGRectMake(SCREEN_WIDTH - 75, 7, 60, 25);
    importBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    importBtn.layer.masksToBounds = YES;
    importBtn.layer.cornerRadius = 2;
    [importBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [importBtn setTitle:@"导 入" forState:UIControlStateNormal];
    importBtn.backgroundColor = [GetColor16 hexStringToColor:@"#f84887"];
    [importBtn addTarget:self action:@selector(importBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:importBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [_tableView headerBeginRefreshing];
    [self.view addSubview:_tableView];
    [self.view addSubview:topView];
    
    noData = [[NoDataView alloc]initWithFrame:_tableView.frame];
    noData.hidden = YES;
    [_tableView addSubview:noData];
    
    noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    noDataView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
    MyImgView * renImgView = [[MyImgView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 75, 60, 100)];
    renImgView.image = [UIImage imageNamed:@"xiaoren"];
    [noDataView addSubview:renImgView];
    
    MyImgView * wordImgView = [[MyImgView alloc]initWithFrame:CGRectMake(renImgView.frame.size.width + renImgView.frame.origin.x + 10, 75, 130, 50)];
    wordImgView.image = [UIImage imageNamed:@"friends_find_empty"];
    [noDataView addSubview:wordImgView];
    
    UIButton * secondImportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondImportBtn.frame = CGRectMake((SCREEN_WIDTH - 180)/2, wordImgView.frame.size.height + wordImgView.frame.origin.y + 120, 180, 45);
    [secondImportBtn setBackgroundImage:[UIImage imageNamed:@"friends_find_empty_btn_nor"] forState:UIControlStateNormal];
    [secondImportBtn setBackgroundImage:[UIImage imageNamed:@"friends_find_empty_btn_pre"] forState:UIControlStateHighlighted];
    secondImportBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [secondImportBtn setTitle:@"导入通讯录" forState:UIControlStateNormal];
    [secondImportBtn addTarget:self action:@selector(importBtn:) forControlEvents:UIControlEventTouchUpInside];
    [noDataView addSubview:secondImportBtn];

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)importBtn:(UIButton *)sender
{
    AskedAddressBookViewController * aksedVC = [[AskedAddressBookViewController alloc]init];
    aksedVC.addressBookVC = self;
    aksedVC.isFaxian = YES;
    [self.navigationController pushViewController:aksedVC animated:YES];
}

- (void)footerRefresh
{
    [_tableView footerEndRefreshing];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self post];
    });
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
//    if (isOperation) {
//        AppDelegate * appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        FriendFragmentViewController * friendVC = [[FriendFragmentViewController alloc]init];
//        UINavigationController * friendNC = appDele.mainTab.viewControllers[3];
//        friendVC = [friendNC.childViewControllers objectAtIndex:0];
//        [friendVC urlRequestPost];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookListCell * cell = [[AddressBookListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.titleLabel.text = [arr[indexPath.row] nickname];
    cell.sourceLabel.text = [NSString stringWithFormat:@"%@",[arr[indexPath.row] source]];
    cell.headImage.indexpath = indexPath;
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail:)];
    [cell.headImage addGestureRecognizer:imgTap];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[arr[indexPath.row]avatar]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.headImage.clipsToBounds = YES;
    if ([[arr[indexPath.row] isFriended] isEqualToString:@"1"]) {
        [cell.signButton setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.signButton setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    }else{
        [cell.signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.signButton.backgroundColor = [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
        [cell.signButton setTitle:@"添加" forState:UIControlStateNormal];
        [cell.signButton addTarget:self action:@selector(addfriend:) forControlEvents:UIControlEventTouchUpInside];
        cell.signButton.tag = 100 + indexPath.row;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addfriend:(id)sender
{
    NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    UIButton * button = sender;
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"添加熟人" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * text = [alert textFieldAtIndex:0];
    text.returnKeyType = UIReturnKeyDone;
    text.placeholder = [NSString stringWithFormat:@"我是%@",nickName];
    alert.tag = button.tag;
    buttontag = (int)button.tag - 100;
    [alert show];
}



-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    
    if (buttonIndex == 1) {
        NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
        if ([tf.text isEqualToString:@""] || tf.text.length == 0) {
            tf.text = [NSString stringWithFormat:@"我是%@",nickName];
        }
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountApplyFriend" parameters:@{ACCOUNT_PASSWORD, @"friendAccount": [arr[buttontag] account], @"say":tf.text}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [AutoDismissAlert autoDismissAlert:@"申请成功,等待对方确认"];
                [self post];
                isOperation = YES;
            }else{
                if (![result isEqualToString:@"4"]) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }
        } andFailureBlock:^{
            
        }];
    }
}

- (void)detail:(UITapGestureRecognizer *)tap
{
    MyImgView * tempImg = (MyImgView *)tap.view;
    PersonalViewController * vc = [[PersonalViewController alloc]init];
    vc.account = [arr[tempImg.indexpath.row]account];
    vc.nickname = [arr[tempImg.indexpath.row]nickname];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendRecommend" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [arr removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            
            NSArray * array = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in array) {
                AddressBookListModel * model = [[AddressBookListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [arr addObject:model];
            }
            topView.hidden = NO;
            noDataView.hidden = YES;
            noData.hidden = YES;
            _tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        }else if ([result isEqualToString:@"4"]){
            topView.hidden = YES;
            noDataView.hidden = NO;
            noData.hidden = YES;
            _tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        }else{
            noData.hidden = NO;
            topView.hidden = YES;
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            noData.frame = _tableView.frame;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    } andFailureBlock:^{
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        noData.frame = _tableView.frame;
        noData.hidden = NO;
        topView.hidden = YES;
        [arr removeAllObjects];
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
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
