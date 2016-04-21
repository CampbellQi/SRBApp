//
//  PersonalModel.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface PersonalModel : ZZBaseObject
@property (nonatomic,copy)NSString * account;   //用户账号
@property (nonatomic,copy)NSString * nickname;   //账户显示名称
@property (nonatomic,copy)NSString * avatar;   //用户头像url
@property (nonatomic,copy)NSString * sex;   //性别0女 1男
@property (nonatomic,copy)NSString * sign;   //个性签名
@property (nonatomic,copy)NSString * birthday;   //生日
@property (nonatomic,copy)NSString * evaluation;   //靠谱指数打分
@property (nonatomic,copy)NSString * evaluationgrade;   //靠谱指数打分
@property (nonatomic,copy)NSString * evaluationper;   //靠谱指数百分比
@property (nonatomic,copy)NSString * fakegrade;   //忽悠指数打分
@property (nonatomic,copy)NSString * fakeper;   //忽悠指数百分比
@property (nonatomic,copy)NSString * location;   //位置
@property (nonatomic,copy)NSString * locationxyz;   //坐标
@property (nonatomic,copy)NSString * guaranteeCount;   //担保数量
@property (nonatomic,copy)NSString * remarkCount;   //印象数量
@property (nonatomic,copy)NSString * fansCount;   //粉丝数量
@property (nonatomic,copy)NSString * locationCount;   //位置数量
@property (nonatomic,copy)NSString * postCount;   //信息数量
@property (nonatomic,copy)NSString * topicCount;   //话题数量
@property (nonatomic,copy)NSString * friendCount;   //好友数量
@property (nonatomic,copy)NSString * orderCount;   //交易数量
@property (nonatomic,copy)NSString * isFriend;   //1已是好友,0不是
@property (nonatomic,copy)NSString * isCollected;   //1已关注,0未关注
@property (nonatomic,copy)NSString * rongCloud;   //融云token
@property (nonatomic,copy)NSString * buyerGoodNum;   //买家好评次数
@property (nonatomic,copy)NSString * buyerBadNum;   //买家差评次数
@property (nonatomic,copy)NSString * buyerTotalNum;   //买家评价总次数
@property (nonatomic,copy)NSString * sellerGoodNum;   //卖家好评次数
@property (nonatomic,copy)NSString * sellerBadNum;   //卖家差评次数
@property (nonatomic,copy)NSString * sellerTotalNum;   //卖家评价总次数
@property (nonatomic,copy)NSString * guarantorGoodNum;   //担保人好评次数
@property (nonatomic,copy)NSString * guarantorBadNum;   //担保人差评次数
@property (nonatomic,copy)NSString * guarantorTotalNum;   //担保人评价总次数
@property (nonatomic,copy)NSString * userqrcode;   //二维码
@property (nonatomic,copy)NSString * invitecode;   //邀请码


@end
