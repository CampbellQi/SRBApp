//
//  RechargeListModel.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface RechargeListModel : ZZBaseObject
@property (nonatomic,strong)NSString * totalCount;  //总条目数
@property (nonatomic,strong)NSString * orderId;     //充值订单ID
@property (nonatomic,strong)NSString * orderNum;    //充值编号
@property (nonatomic,strong)NSString * orderType;   //充值订单类型
@property (nonatomic,strong)NSString * price;       //充值金额
@property (nonatomic,strong)NSString * money;       //获得的虚拟币
@property (nonatomic,strong)NSString * remark;      //备注
@property (nonatomic,strong)NSString * updatetime;  //充值时间
@property (nonatomic,strong)NSString * status;      //0已支付,1未支付
@property (nonatomic,strong)NSString * statusName;  //状态名称
@end
