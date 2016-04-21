//
//  FriendSearchModel.h
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface FriendSearchModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;  //用户总数
@property (nonatomic,copy)NSString * account;  //用户账号
@property (nonatomic,copy)NSString * nickname;  //账户显示名称
@property (nonatomic,copy)NSString * avatar;  //用户头像URL地址
@property (nonatomic,copy)NSString * location;  //最新位置
@property (nonatomic,copy)NSString * locationxyz;  //坐标
@property (nonatomic,copy)NSString * isFriended;  //是否是朋友
@property (nonatomic,copy)NSString * friendId;  //朋友id
@property (nonatomic,copy)NSString * commonCount;  //共同好友


@end
