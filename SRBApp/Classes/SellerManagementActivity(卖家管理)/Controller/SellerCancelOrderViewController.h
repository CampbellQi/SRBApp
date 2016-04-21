//
//  SellerCancelOrderViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZCancelOrderViewController.h"
#import "SellerManagementModel.h"
#import "SellerOrderDetailViewController.h"

@interface SellerCancelOrderViewController : ZZCancelOrderViewController
//@property (nonatomic,strong)SellerManagementModel * sellerModel;
@property (nonatomic,strong)NSString * orderID;
@property (nonatomic,strong)SellerOrderDetailViewController * sellerOrderVC;
@property (nonatomic,strong)NSDictionary * dataDic;
@end
