//
//  DanBaoRenModel.h
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface DanBaoRenModel : ZZBaseObject
@property (nonatomic,strong)NSString * totalCount;  //担保总数
@property (nonatomic,strong)NSString * ID;          //信息id
@property (nonatomic,strong)NSString * account;     //担保人账号
@property (nonatomic,strong)NSString * avatar;      //担保人头像发URL
@property (nonatomic,strong)NSString * nickname;    //担保人昵称
@property (nonatomic,strong)NSString * updatetime;  //担保时间
@property (nonatomic,strong)NSString * bangPrice;   //熟人帮成交价
@property (nonatomic,strong)NSString * title;       //担保标题
@property (nonatomic,strong)NSString * content;     //担保内容
@property (nonatomic,strong)NSString * grade;       //担保评级
@end
