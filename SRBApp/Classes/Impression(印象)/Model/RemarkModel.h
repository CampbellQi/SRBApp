//
//  RemarkModel.h
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface RemarkModel : ZZBaseObject
@property (nonatomic,strong)NSString * totalCount;  //印象总数
@property (nonatomic,strong)NSString * account;  //用户账号
@property (nonatomic,strong)NSString * nickname;  //账户显示名称
@property (nonatomic,strong)NSString * avatar;  //头像url
@property (nonatomic,strong)NSString * remark;  //一句话点评
@property (nonatomic,strong)NSString * grade;  //打分
@property (nonatomic,strong)NSString * relation;  //关系
@property (nonatomic,strong)NSString * updatetime;  //动作时间
@property (nonatomic,strong)NSString * sign;
@end
