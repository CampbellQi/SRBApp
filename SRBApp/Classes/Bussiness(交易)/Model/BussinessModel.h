//
//  BussinessModel.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessCell.h"

@interface BussinessModel : NSObject
@property (nonatomic, strong)NSString * account;
@property (nonatomic, strong)NSString * avatar;
@property (nonatomic, strong)NSString * bangPrice;
@property (nonatomic, strong)NSString * birthday;
@property (nonatomic, strong)NSString * city;
@property (nonatomic, strong)NSString * cityName;
@property (nonatomic, strong)NSString * commentCount;
@property (nonatomic, strong)NSString * consultCount;
@property (nonatomic, strong)NSString * content;
@property (nonatomic, strong)NSString * country;
@property (nonatomic, strong)NSString * cover;
@property (nonatomic, strong)NSString * dealName;
@property (nonatomic, strong)NSString * dealType;
@property (nonatomic, strong)NSString * model_description;
@property (nonatomic, strong)NSString * evaluation;
@property (nonatomic, strong)NSString * evaluationgrade;
@property (nonatomic, strong)NSString * evaluationper;
@property (nonatomic, strong)NSString * fakegrade;
@property (nonatomic, strong)NSString * fakeper;
@property (nonatomic, strong)NSString * freeShipment;
@property (nonatomic, strong)NSString * friendId;
@property (nonatomic, strong)NSString * guaranteeAllow;
@property (nonatomic, strong)NSString * guaranteePrice;
@property (nonatomic, strong)NSString * hitCount;
@property (nonatomic, strong)NSString * model_id;
@property (nonatomic, strong)NSString * isCollected;
@property (nonatomic, strong)NSString * isFriended;
@property (nonatomic, strong)NSString * isGuarantee;
@property (nonatomic, strong)NSString * likeCount;
@property (nonatomic, strong)NSString * location;
@property (nonatomic, strong)NSString * locationxyz;
@property (nonatomic, strong)NSString * memo;
@property (nonatomic, strong)NSString * nickname;
@property (nonatomic, strong)NSString * originalPrice;
@property (nonatomic, strong)NSString * photo;
@property (nonatomic, strong)NSString * photos;
@property (nonatomic, strong)NSString * model_position;
@property (nonatomic, strong)NSString * positionView;
@property (nonatomic, strong)NSString * positionxyz;
@property (nonatomic, strong)NSString * province;
@property (nonatomic, strong)NSString * rongCloud;
@property (nonatomic, strong)NSString * salesCount;
@property (nonatomic, strong)NSString * sex;
@property (nonatomic, strong)NSString * shareUrl;
@property (nonatomic, strong)NSString * sign;
@property (nonatomic, strong)NSString * sortName;
@property (nonatomic, strong)NSString * storage;
@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * transportPrice;
@property (nonatomic, strong)NSString * type;
@property (nonatomic, strong)NSString * updatetime;
@property (nonatomic, strong)NSString * statusName;//订单状态
@property (nonatomic, strong)NSString * buyernick;//买家昵称
@property (nonatomic, strong)NSString * buyername;//买家昵称
@property (nonatomic, strong)NSString * sellernick;//卖家
@property (nonatomic, strong)NSString * guarantornick;//担保人
@property (nonatomic, strong)NSString * guarantorname;//担保人账号
@property (nonatomic, strong)NSString * guaranteeNote;//担保理由
@property (nonatomic, strong)NSString * guarantorcontent;//担保理由
@property (nonatomic, strong)NSString * guaranteeTime;//担保时间
@property (nonatomic, strong)NSString * orderId;//商品
@property (nonatomic, strong)NSString * orderNum;//订单id
@property (nonatomic, strong)NSString * isGuaranteeOrder;//是否担保
@property (nonatomic, strong)NSString * guaranteeAmount;
@property (nonatomic, strong)NSString * goodsAmount;
@property (nonatomic, strong)NSString * orderAmount;
@property (nonatomic, strong)NSString * remark;
@property (nonatomic, strong)NSString * guarantortime;
@property (nonatomic, strong)NSString * discountPrice;
@property (nonatomic ,strong)NSString * marketPrice;
@property (nonatomic, assign)double updatetimeLong;
@property (nonatomic,strong)NSString * isStick;
@property (nonatomic, strong)NSString * touser;

@property (nonatomic, strong)NSDictionary * user;
@property (nonatomic, strong)NSString * tags;

@property (nonatomic, strong)NSArray * goods;
@property (nonatomic, strong)NSString * isLike;

@property(nonatomic, strong) NSAttributedString* attr_content;
@property(nonatomic, strong) NSAttributedString* attr_title;

@property (nonatomic, strong)NSString * url;
@property (nonatomic ,strong)NSString * shortUrl;
//求购单
//品牌
@property (nonatomic, strong)NSString * brand;
//原产地
@property (nonatomic, strong)NSString *birthland;
//希望代购地点
@property (nonatomic, strong)NSString *shopland;
//规格
@property (nonatomic, strong)NSString * size;
//留言
@property (nonatomic, strong)NSString * say;

@property (nonatomic, assign)float sayHeight;
//截止日期
@property (nonatomic, strong)NSString * endday;
//@property(nonatomic, assign) float attrContentHeight;
//标签
@property (nonatomic, strong)NSArray * labels;
//话题id
@property (nonatomic, strong)NSString * parentId;
//求购单id
@property (nonatomic, strong)NSString * causeId;
//长草次数
@property (nonatomic, strong)NSString * favCount;
//同求次数
@property (nonatomic, strong)NSString * quotes;
//接单数量
@property (nonatomic, strong)NSString *taskcount;
//接单用户数组
@property (nonatomic, strong)NSArray *taskuser;
//推荐现货数
@property (nonatomic, strong)NSString *handcount;
//推荐现货用户数组对象
@property (nonatomic, strong)NSArray *handuser;
//报价
@property (nonatomic, strong)NSString *quote;
//押金
@property (nonatomic, strong)NSString *money;
//预计代购地点
@property (nonatomic, strong)NSString *area;
//预计发货时间
@property (nonatomic, strong)NSString *sendtime;

@property (nonatomic, strong)NSString *taskStatus;
@property (nonatomic, strong)NSString *taskStatusName;
@property (nonatomic, strong)NSString *taskStatusNote;

@property (nonatomic, strong)NSDictionary *bid;

@property (nonatomic, strong)NSString *taskBid;
//卖家对象
@property (nonatomic, strong)NSDictionary * seller;
//求购单商品id
@property (nonatomic, strong)NSString * taskDealPostId;

@property (nonatomic, strong)NSString * message;
//求购单-订单id
@property (nonatomic, strong)NSString *taskOrderFormId;
//订单名称
@property (nonatomic, strong)NSString *invoiceName;
//订单编号
@property (nonatomic, strong)NSString *invoiceNo;
//剩余天数
@property (nonatomic, strong)NSString *taskLostNote;
@property (nonatomic, strong)NSString *taskCashCost;
@property (nonatomic, strong)NSString *address;
@end
