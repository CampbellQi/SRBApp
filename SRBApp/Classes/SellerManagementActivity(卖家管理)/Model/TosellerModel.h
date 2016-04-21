//
//  TosellerModel.h
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface TosellerModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;        //总条目数
@property (nonatomic,copy)NSString * orderId;           //订单号
@property (nonatomic,copy)NSString * itemId;            //明细ID
@property (nonatomic,copy)NSString * title;             //商品名称
@property (nonatomic,copy)NSString * cover;             //封面名称
@property (nonatomic,copy)NSString * ID;                //商品ID
@property (nonatomic,copy)NSString * isCommented;       //是否评价
@property (nonatomic,copy)NSString * updatetime;        //评价时间
@property (nonatomic,copy)NSString * content;           //评价内容
@property (nonatomic,copy)NSString * grade;             //打分
@property (nonatomic,strong)NSDictionary * buyer;       //买家信息
@property (nonatomic,strong)NSDictionary * guarantor;   //担保人信息
@property (nonatomic,strong)NSDictionary * seller;      //卖家信息
@property (nonatomic,copy)NSString * bangPrice;         //商品价格
@property (nonatomic,strong)NSString * descriptions;    //商品描述
@property (nonatomic,strong)NSString * transportPrice;    //运费
@property (nonatomic, strong)NSString * orderAmount;   //订单价格
@property (nonatomic, strong)NSString * photos; //照片

@property (nonatomic, strong)NSArray *goods;

@property (nonatomic, strong)NSString * buyername; //照片
@property (nonatomic, strong)NSString * buyernick; //照片
@property (nonatomic, strong)NSString * buyeravatar; //照片
@property (nonatomic, strong)NSString * sellername; //照片
@property (nonatomic, strong)NSString * sellernick; //照片
@property (nonatomic, strong)NSString * selleravatar; //照片

@end
