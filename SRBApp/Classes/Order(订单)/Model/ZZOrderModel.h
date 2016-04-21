//
//  ZZOrderModel.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZOrderModel : ZZBaseObject
@property (nonatomic,copy)NSString * address; //地址
@property (nonatomic,copy)NSString * backnote;//申请退款理由
@property (nonatomic,copy)NSString * backtime;//申请退款时间
@property (nonatomic,copy)NSString * buyernick;//买家昵称
@property (nonatomic,copy)NSString * buyername;//买家用户名
@property (nonatomic,copy)NSString * sellernick;//卖家昵称
@property (nonatomic,copy)NSString * sellername;//卖家用户名
@property (nonatomic,copy)NSString * guarantorname;//担保人用户名
@property (nonatomic,copy)NSString * cancelnote;//取消理由
@property (nonatomic,copy)NSString * canceltime;//取消时间
@property (nonatomic,copy)NSString * guarantornick;//担保人昵称
@property (nonatomic,copy)NSString * invoiceNo;//发货单号
@property (nonatomic,copy)NSString * invoiceName;//发货物流名称
@property (nonatomic,copy)NSString * status;//支付状态
@property (nonatomic,copy)NSString * statusName;//订单状态名称
@property (nonatomic,copy)NSString * orderAmount;//应付款总额
@property (nonatomic,copy)NSString * goodsAmount;//商品总额
@property (nonatomic,copy)NSString * transportPrice;//运费
@property (nonatomic,copy)NSString * guaranteePrice;//担保费
@property (nonatomic,copy)NSString * confirmTime;//商家确认时间
@property (nonatomic,copy)NSString * confirm;//商家确认(0,1)
@property (nonatomic,copy)NSString * toBuyer;//商家留言
@property (nonatomic,copy)NSString * postscript;//订单附言
@property (nonatomic,copy)NSString * contacterName;//收件人
@property (nonatomic,copy)NSString * mobile;//手机
@property (nonatomic,copy)NSString * updatetime;//创建时间
@property (nonatomic,copy)NSString * orderNum;//订单编号
@property (nonatomic,copy)NSString * orderId;//订单号
@property (nonatomic,copy)NSString * totalCount;//服务器总条目数
@property (nonatomic,strong)NSArray * goods;//商品数组


@end
