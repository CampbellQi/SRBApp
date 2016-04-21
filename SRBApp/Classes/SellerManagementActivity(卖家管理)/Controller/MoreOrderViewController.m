//
//  MoreOrderViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MoreOrderViewController.h"
#import "ShaiXuanView.h"
#import "SellerEvaluateListActivityViewController.h"

@interface MoreOrderViewController ()<shaiXuanViewDelegate>

@end

@implementation MoreOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ShaiXuanView * shaiXuanView = [[ShaiXuanView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shaiXuanView.array = self.array;
    shaiXuanView.imgArr = self.imgArr;
    shaiXuanView.delegate = self;
    self.view = shaiXuanView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
}

- (void)shaiXuanView:(ShaiXuanView *)shaiXuanView didSelectRow:(NSInteger)row
{
    SellerEvaluateListActivityViewController * parentVC = (SellerEvaluateListActivityViewController *)[self parentViewController];
    if (row == 0) {
        parentVC.fromBuyerTVC.evaGrade = @"";
        [parentVC.fromBuyerTVC urlRequestPost];
    }else if (row == 1) {
        parentVC.fromBuyerTVC.evaGrade = @"1";
        [parentVC.fromBuyerTVC urlRequestPost];
    }else if (row == 2){
        parentVC.fromBuyerTVC.evaGrade = @"0";
        [parentVC.fromBuyerTVC urlRequestPost];
    }else if (row == 3){
        parentVC.fromBuyerTVC.evaGrade = @"-1";
        [parentVC.fromBuyerTVC urlRequestPost];
    }else if (row == 4){
        parentVC.fromBuyerTVC.evaGrade = @"-5";
        [parentVC.fromBuyerTVC urlRequestPost];
    }
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
