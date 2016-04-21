//
//  ShaiXuanEvaluateViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShaiXuanEvaluateViewController.h"
#import "ShaiXuanView.h"
#import "MyEvaluateListViewController.h"
#import "AllEvaluationsViewController.h"

@interface ShaiXuanEvaluateViewController ()<shaiXuanViewDelegate>

@end

@implementation ShaiXuanEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ShaiXuanView * shaiXuanView = [[ShaiXuanView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shaiXuanView.imgArr = self.imgArr;
    shaiXuanView.array = self.dataArr;
    shaiXuanView.delegate = self;
    self.view = shaiXuanView;
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

- (void)shaiXuanView:(ShaiXuanView *)shaiXuanView didSelectRow:(NSInteger)row
{
    if ([_sign isEqualToString:@"1"]) {
        AllEvaluationsViewController * vc = (AllEvaluationsViewController *)[self parentViewController];
        if (row == 0) {
            vc.signOfEvaluation = @"";
            vc.titleLabel.frame = CGRectMake(0, 0, 75, 18);
            vc.titleLabel.text = @"全部评价";
            vc.imgview.frame = CGRectMake(vc.titleLabel.frame.origin.x + vc.titleLabel.frame.size.width, 7, 15, 7);
            [vc urlRequestPost];
        }else if (row == 1) {
            vc.signOfEvaluation = @"frombuyer";
            vc.titleLabel.text = @"求购方评价";
            vc.titleLabel.frame = CGRectMake(0, 0, 90, 18);
            vc.imgview.frame = CGRectMake(vc.titleLabel.frame.origin.x + vc.titleLabel.frame.size.width, 7, 15, 7);
            [vc urlRequestPost];
        }else if (row == 2){
            vc.signOfEvaluation = @"fromseller";
            vc.titleLabel.text = @"代购方评价";
            vc.titleLabel.frame = CGRectMake(0, 0, 90, 18);
            vc.imgview.frame = CGRectMake(vc.titleLabel.frame.origin.x + vc.titleLabel.frame.size.width, 7, 15, 7);
            [vc urlRequestPost];
        }
    }else{
    MyEvaluateListViewController * myEvaVC = (MyEvaluateListViewController *)[self parentViewController];
    //1 0 -1 -5
    if (row == 0) {
        myEvaVC.fromSellerVC.evaGrade = @"";
        [myEvaVC.fromSellerVC urlRequestPost];
    }else if (row == 1) {
        myEvaVC.fromSellerVC.evaGrade = @"1";
        [myEvaVC.fromSellerVC urlRequestPost];
    }else if (row == 2){
        myEvaVC.fromSellerVC.evaGrade = @"0";
        [myEvaVC.fromSellerVC urlRequestPost];
    }else if (row == 3){
        myEvaVC.fromSellerVC.evaGrade = @"-1";
        [myEvaVC.fromSellerVC urlRequestPost];
    }else if (row == 4){
        myEvaVC.fromSellerVC.evaGrade = @"-5";
        [myEvaVC.fromSellerVC urlRequestPost];
    }
    }
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
