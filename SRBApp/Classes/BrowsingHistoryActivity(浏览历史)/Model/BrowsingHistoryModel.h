//
//  BrowsingHistoryModel.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface BrowsingHistoryModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;      //总条目数
@property (nonatomic,copy)NSString * ID;      //信息id
@property (nonatomic,copy)NSString * cover;      //封面图片URL
@property (nonatomic,copy)NSString * title;      //名称
@property (nonatomic,copy)NSString * avatar;      //发布人头像URL
@property (nonatomic,copy)NSString * account;      //发布人账号
@property (nonatomic,copy)NSString * nickname;      //发布人昵称
@property (nonatomic,copy)NSString * descriptions;      //描述
@property (nonatomic,copy)NSString * originalPrice;      //原价
@property (nonatomic,copy)NSString * discountPrice;      //折扣价格
@property (nonatomic,copy)NSString * updatetime;      //上架时间
@property (nonatomic,copy)NSString * dealType;      //信息类型(0或””全部，1我能，2我要)
@property (nonatomic,copy)NSString * likeCount;      //点赞数量
@property (nonatomic,strong)NSArray * cityName;      //信息地区
@property (nonatomic,copy)NSString * dealName;     //信息类型名称
@property (nonatomic,copy)NSString * xyz;     //坐标
@property (nonatomic,copy)NSString * position;     //位置
@property (nonatomic,copy)NSString * photos;     //照片

@property (nonatomic,copy)NSString * bangPrice;

@end
