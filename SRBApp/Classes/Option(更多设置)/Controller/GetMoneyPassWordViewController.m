//
//  GetMoneyPassWordViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GetMoneyPassWordViewController.h"
#import "GetMoneyPasswordCell.h"
#import "RenewPasswordViewController.h"
#import "QuestionOptionViewController.h"
#import "AnswerQuestionViewController.h"

@interface GetMoneyPassWordViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation GetMoneyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付密码";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64)];
    tableView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65 - 115)];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 100 - 15, SCREEN_WIDTH, 15)];
//    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"客服电话: 180-1234-5678";
//    [view addSubview:label];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GetMoneyPasswordCell * cell = [[GetMoneyPasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        cell.label.text = @"重置支付密码";
        cell.imgview.image = [UIImage imageNamed:@"pw_pay_renew"];
    }
    if (indexPath.row == 1) {
        cell.label.text = @"重设密保问题";
        cell.imgview.image = [UIImage imageNamed:@"pw_pay_question"];
    }
//    if (indexPath.row == 2) {
//        cell.label.text = @"设置密保问题";
//        cell.imgview.image = [UIImage imageNamed:@"pw_pay_question"];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        AnswerQuestionViewController * vc = [[AnswerQuestionViewController alloc]init];
        vc.sign = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AnswerQuestionViewController * vc = [[AnswerQuestionViewController alloc]init];
        vc.sign = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
