//
//  ZZMyAttentionVipModel.h
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZMyAttentionVipModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;//用户总数
@property (nonatomic,copy)NSString * account;//用户账号
@property (nonatomic,copy)NSString * nickname;//账户显示名称
@property (nonatomic,copy)NSString * avatar;//用户头像url地址
@property (nonatomic,copy)NSString * evaluation;//靠谱指数
@property (nonatomic,copy)NSString * location;//最新位置
@property (nonatomic,copy)NSString * locationxyz;//坐标
@property (nonatomic,copy)NSString * sign;//签名
@property (nonatomic,copy)NSString * sex;//性别
@property (nonatomic,copy)NSString * rongCloud;//融云token
@end
