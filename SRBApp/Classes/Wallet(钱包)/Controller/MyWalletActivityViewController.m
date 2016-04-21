//
//  MyWalletActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyWalletActivityViewController.h"
#import "MyWalletCell.h"
#import "BalanceActivityViewController.h"
#import "AccountDetailActivityViewController.h"
#import "WithdrawActivityViewController.h"
#import "RechargeViewController.h"
#import "RechargeListViewController.h"
#import "MyAliPayViewController.h"
#import "DrawRecordsViewController.h"
#import "HadAliPayViewController.h"
#import "AppDelegate.h"
@interface MyWalletActivityViewController ()
{
    NSArray * _arr1;
    NSArray * _arr2;
    NSArray * _arr3;
    NSArray * _arr4;
    NSArray * _imageArr;
    BOOL isBack;
    
    NSString *_balance;
}
@end

@implementation MyWalletActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    self.title = @"我的钱包";
    _arr1 = [NSArray array];
    _arr2 = [NSArray array];
    _arr3 = [NSArray array];
    _arr4 = [NSArray array];
    _arr1 = @[@"账户余额", @"账单明细"];
    _arr2 = @[@"账户充值", @"充值记录"];
    _arr3 = @[@"账户提现", @"提现记录"];
//    _arr4 = @[@"支付宝"];
    _imageArr = @[@"qb_ye.png", @"qb_mx.png", @"qb_cz.png", @"qb_cj.png", @"qb_tx.png", @"qb_tj.png"];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.scrollEnabled = NO;
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    _tableView.tableFooterView = [[UIView alloc]init];
//    _tableView.tableFooterView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_tableView];
    
//    [self urlRequestPost];
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

//cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        MyWalletCell * cell = [[MyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        if (indexPath.row == 0) {
            cell.label.text = [NSString stringWithFormat:@"%@：￥ %@", _arr1[indexPath.row], _balance];
        }else {
            cell.label.text = _arr1[indexPath.row];
        }
        
        [cell.image  setImage:[UIImage imageNamed:_imageArr[indexPath.row]]];
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 17, 5, 10)];
        detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
        [accessoryView addSubview:detailImg];
        cell.accessoryView = accessoryView;
        return cell;
    }
    if (indexPath.section == 1) {
        MyWalletCell * cell = [[MyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.label.text = _arr2[indexPath.row];
        [cell.image  setImage:[UIImage imageNamed:_imageArr[indexPath.row + 2]]];
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 17, 5, 10)];
        detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
        [accessoryView addSubview:detailImg];
        cell.accessoryView = accessoryView;
        return cell;
    }
    if (indexPath.section == 2) {
        MyWalletCell * cell = [[MyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.label.text = _arr3[indexPath.row];
        [cell.image  setImage:[UIImage imageNamed:_imageArr[indexPath.row + 4]]];
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 17, 5, 10)];
        detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
        [accessoryView addSubview:detailImg];
        cell.accessoryView = accessoryView;
        return cell;
    }
//    if (indexPath.section == 3) {
//        MyWalletCell * cell = [[MyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
//        cell.label.text = _arr4[indexPath.row];
//        [cell.image  setImage:[UIImage imageNamed:_imageArr[indexPath.row + 6]]];
//        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(35, 17, 5, 10)];
//        detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
//        [accessoryView addSubview:detailImg];
//        cell.accessoryView = accessoryView;
//        return cell;
//    }
    return nil;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 2;
    }
    return 0;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//section数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

//header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.01;
}

//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BalanceActivityViewController * vc = [[BalanceActivityViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            AccountDetailActivityViewController * vc = [[AccountDetailActivityViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            RechargeViewController * vc = [[RechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            RechargeListViewController * vc = [[RechargeListViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            WithdrawActivityViewController * vc = [[WithdrawActivityViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            DrawRecordsViewController * vc = [[DrawRecordsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
//    if (indexPath.section == 3) {
//        if (indexPath.row == 0) {
//            
//            if([self.aliPayAccount isEqualToString:@""]){
//                MyAliPayViewController *myAliPayVC = [[MyAliPayViewController alloc] init];
//                [self.navigationController pushViewController:myAliPayVC animated:YES];
//            }else
//            {
//                HadAliPayViewController * vc = [[HadAliPayViewController alloc]init];
//                vc.aliPayAccount = self.aliPayAccount;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }
//    }
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic;
    dic = [self parametersForDic:@"accountGetInfo" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        self.aliPayAccount = [dataDic objectForKey:@"zhifubao"];
        _balance = [dataDic objectForKey:@"balance"];
        [self.tableView reloadData];
        NSLog(@"self.aliPayAccount = %@",self.aliPayAccount);
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
