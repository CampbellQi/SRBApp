//
//  SellerManagementModel.h
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface SellerManagementModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;        //总条目数
@property (nonatomic,copy)NSString * orderId;           //
@property (nonatomic,copy)NSString * orderNum;          //
@property (nonatomic,copy)NSString * updatetime;        //
@property (nonatomic,copy)NSString * mobile;            //
@property (nonatomic,copy)NSString * address;           //
@property (nonatomic,copy)NSString * contacterName;     //
@property (nonatomic,copy)NSString * postscript;        //订单附言
@property (nonatomic,copy)NSString * toBuyer;           //商家留言
@property (nonatomic,copy)NSString * transportPrice;    //运费
@property (nonatomic,copy)NSString * orderAmount;       //应付款总额
@property (nonatomic,copy)NSString * goodsAmount;       //商品总额
@property (nonatomic,copy)NSString * statusName;        //
@property (nonatomic,copy)NSString * status;            //
@property (nonatomic,strong)NSArray * goods;            //商品数组
@property (nonatomic,copy)NSString * buyernick;         //买家昵称

@end
