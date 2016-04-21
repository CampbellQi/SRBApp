//
//  DanBaoMenuViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DanBaoMenuViewController.h"
#import "DanBaoMenuView.h"
#import "DanBaoRenModel.h"
#import "TransactionDetailViewController.h"

@interface DanBaoMenuViewController ()<moreDanbaoDelegate>

@end

@implementation DanBaoMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DanBaoMenuView * danbaoMenuView = [[DanBaoMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    danbaoMenuView.array = self.dataArray;
    danbaoMenuView.delegate = self;
    self.view = danbaoMenuView;
}

- (void)moreDanbaoView:(DanBaoMenuView *)danBaoMenuView didSelectRow:(NSInteger)row
{
    TransactionDetailViewController * transactionVC = (TransactionDetailViewController *)self.parentViewController;
    DanBaoRenModel * danBaoRenModel = self.dataArray[row];
    transactionVC.guaranTeeView.danbaoNameLabel.text = danBaoRenModel.nickname;
    transactionVC.guaranTeeView.danbaoPriceLabel.text = danBaoRenModel.bangPrice;
    [transactionVC.guaranTeeView setImage:[danBaoRenModel.grade intValue]];

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
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
