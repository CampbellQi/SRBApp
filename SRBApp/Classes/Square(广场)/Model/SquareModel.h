//
//  SquareModel.h
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareModel : NSObject
@property (nonatomic,copy)NSString * totalCount;    //总信息条目
@property (nonatomic,copy)NSString * ID;    //信息id
@property (nonatomic,copy)NSString * cover;    //封面图片url
@property (nonatomic,copy)NSString * title;    //名称
@property (nonatomic,copy)NSString * account;    //发布人账号
@property (nonatomic,copy)NSString * avatar;    //发布人头像URL
@property (nonatomic,copy)NSString * nickname;    //发布人昵称
@property (nonatomic,copy)NSString * descriptions;    //描述
@property (nonatomic,copy)NSString * originalPrice;    //原价
@property (nonatomic,copy)NSString * discountPrice;    //折扣价格
@property (nonatomic,copy)NSString * updatetime;    //上架时间
@property (nonatomic,copy)NSString * dealType;    //信息类型(0或""全部,1我能,2我要)
@property (nonatomic,copy)NSString * likeCount;    //点赞数量
@property (nonatomic,copy)NSString * cityName;    //信息地区
@property (nonatomic,copy)NSString * dealName;    //信息类型名称
@end
