//
//  MyAssureOrderModel.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAssureOrderModel : NSObject
@property (nonatomic, strong)NSString * totalCount;
@property (nonatomic, strong)NSString * orderId;
@property (nonatomic, strong)NSString * orderNum;
@property (nonatomic, strong)NSString * updatetime;
@property (nonatomic, strong)NSString * mobile;
@property (nonatomic, strong)NSString * address;
@property (nonatomic, strong)NSString * contacterName;
@property (nonatomic, strong)NSString * postscript;
@property (nonatomic, strong)NSString * toBuyer;
@property (nonatomic, strong)NSString * transportPrice;
@property (nonatomic, strong)NSString * goodsAmount;
@property (nonatomic, strong)NSString * orderAmount;
@property (nonatomic, strong)NSString * statusName;
@property (nonatomic, strong)NSString * status;
@property (nonatomic, strong)NSString * buyernick;
@property (nonatomic, strong)NSString * sellernick;
@property (nonatomic, strong)NSArray * goods;
//@property (nonatomic, strong)NSString * model_orderAmount;

@end
