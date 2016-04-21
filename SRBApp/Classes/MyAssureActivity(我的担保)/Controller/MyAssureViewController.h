//
//  MyAssureViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MyAssureGoodsViewController.h"
#import "MyAssureOrdersViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MyAssureViewController : ZZViewController<UIScrollViewDelegate>
{
    UIView * lineView;
    UIButton * goodsBtn;
    UIButton * ordersBtn;
    BOOL isBack;
}
@property (nonatomic, strong) MyAssureGoodsViewController *myAssureGoodsTVC;
@property (nonatomic, strong) MyAssureOrdersViewController *myAssureOrdersTVC;

@property (nonatomic, strong) UIScrollView *sv;
- (void)backBtn:(UIButton *)sender;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)customInit;

- (void)goodsBtn:(UIButton *)sender;
- (void)circleBtn:(UIButton *)sender;


@end
