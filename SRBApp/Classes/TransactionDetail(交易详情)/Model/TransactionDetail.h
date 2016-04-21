//
//  TransactionDetail.h
//  SRBApp
//
//  Created by zxk on 15/6/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface TransactionDetail : ZZBaseObject
/** 用户帐户金币余额 */
@property (nonatomic,strong)NSString * balance;
/** 商品总额 */
@property (nonatomic,strong)NSString * goodsAmount;
/** 担保费总额 */
@property (nonatomic,strong)NSString * guaranteeAmount;
/** 每件担保费 */
@property (nonatomic,strong)NSString * guaranteePrice;
/** 应付款总额 */
@property (nonatomic,strong)NSString * orderAmount;
/** 订单ID */
@property (nonatomic,strong)NSString * orderId;
/** 订单编号 */
@property (nonatomic,strong)NSString * orderNum;
/** 订单状态 */
@property (nonatomic,strong)NSString * status;
/** 订单状态名称 */
@property (nonatomic,strong)NSString * statusName;
/** 运费 */
@property (nonatomic,strong)NSString * transportPrice;
@end
