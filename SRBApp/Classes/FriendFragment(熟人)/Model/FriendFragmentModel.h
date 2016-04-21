//
//  FriendFragmentModel.h
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface FriendFragmentModel : ZZBaseObject
@property (nonatomic,copy)NSString * friendId;  //好友关系ID
@property (nonatomic,copy)NSString * account;  //好友账号
@property (nonatomic,copy)NSString * avatar;  //好友头像URl
@property (nonatomic,copy)NSString * nickname;  //好友昵称
@property (nonatomic, strong)NSString * memo;   //好友备注
@property (nonatomic,copy)NSString * groupId;  //好友所属分组
@property (nonatomic,copy)NSString * groupName;  //好友所属分组名称
@property (nonatomic,copy)NSString * grade;  //亲密指数得分
@property (nonatomic,copy)NSString * remark;  //一句话点评
@property (nonatomic,copy)NSString * relation;  //关系
@property (nonatomic,copy)NSString * commonCount;  //共同好友
@property (nonatomic,copy)NSString * location;  //地址
@property (nonatomic,copy)NSString * sign;  //签名
@property (nonatomic,copy)NSString * rongCloud; //荣云
@property (nonatomic,copy)NSString * sex;
@property (nonatomic,copy)NSString * source;    //来源
@property (nonatomic,copy)NSString * say;       //
@property (nonatomic,strong)NSString * isFriended;
@property (nonatomic,copy)NSString * updatetime;
@end
