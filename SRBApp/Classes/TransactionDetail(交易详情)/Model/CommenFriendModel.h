//
//  CommenFriendModel.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface CommenFriendModel : ZZBaseObject
@property (nonatomic,strong)NSString * account;         //好友账号
@property (nonatomic,strong)NSString * avatar;          //好友头像url
@property (nonatomic,strong)NSString * nickname;        //好友昵称
@property (nonatomic,strong)NSString * groupName;       //好友所属分组
@property (nonatomic,strong)NSString * grade;           //好友所属分组名称
@property (nonatomic,strong)NSString * groupId;         //亲密指数打分
@property (nonatomic,strong)NSString * remark;          //一句话点名
@property (nonatomic,strong)NSString * relation;        //关系
@property (nonatomic,strong)NSString * sign;        //
@property (nonatomic,strong)NSString * rongCloud;        //
@end
