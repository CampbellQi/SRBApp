//
//  SellerManagementTablView.h
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "SellerManagementViewController.h"
/**
 *  @brief  卖家订单列表
 */
@interface SellerManagementTablView : ZZViewController
@property (nonatomic,copy)NSString * orderType;         //订单状态
@property (nonatomic,strong)SellerManagementViewController * sellerManagementVC;//卖家管理
- (void)urlRequest; //网络请求
- (void)backBtn:(UIButton *)sender; //返回按钮


@end
