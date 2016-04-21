//
//  ShopCircleViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "LoginViewController.h"
@class ShoppingViewController;

@interface ShopCircleViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)UIButton * toTopBtn;
@property (nonatomic,strong)NSString * saleAndBuyType;
@property (nonatomic,strong)NSString * categoryID;
@property (nonatomic,strong)NSString * order;
@property (nonatomic,strong)LoginViewController *loginVC;
@property (nonatomic,strong)ZZNavigationController *nav;
@property (nonatomic,strong)ShoppingViewController * shoppingVC;

- (void)urlRequestPost;

@end
