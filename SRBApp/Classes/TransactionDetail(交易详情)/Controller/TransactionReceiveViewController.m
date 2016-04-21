//
//  TransactionReceiveViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TransactionReceiveViewController.h"


@interface TransactionReceiveViewController ()

@end

@implementation TransactionReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(UIButton *)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.transactionVC getAddressUrlRequest];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveModel * model = [self.receiveAddrArray objectAtIndex:indexPath.row];
    NSDictionary * loginParam = @{@"method":@"accountDefaultAddress",@"parameters":@{ACCOUNT_PASSWORD,@"id":[NSString stringWithFormat:@"%d",model.iD.intValue]}};
    [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.transactionVC getAddressUrlRequest];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
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
