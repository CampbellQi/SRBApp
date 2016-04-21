//
//  LocationModel.h
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface LocationModel : ZZBaseObject
@property (nonatomic,copy)NSString * totalCount;    //总数
@property (nonatomic,copy)NSString * account;       //用户账号
@property (nonatomic,copy)NSString * avatar;        //用户头像url
@property (nonatomic,copy)NSString * nickname;      //用户昵称
@property (nonatomic,copy)NSString * ID;            //位置ID
@property (nonatomic,copy)NSString * title;         //位置
@property (nonatomic,copy)NSString * content;       //描述
@property (nonatomic,copy)NSString * updatetime;    //更新时间
@property (nonatomic,copy)NSString * url;           //图片URL
@property (nonatomic,copy)NSString * photos;        //多图URL
@property (nonatomic,copy)NSString * xyz;           //坐标点
@property (nonatomic,strong)NSString * likeCount;   //赞数
@property (nonatomic,assign)BOOL isClick;           //是否点击
@property (nonatomic,copy)NSString * zanCount;      //点赞的数量
@property (nonatomic,assign)double updatetimeLong;
@property (nonatomic,strong)NSMutableArray * comments;  //评论
@property (nonatomic,strong)NSMutableArray * likes;     //赞
@property (nonatomic,copy)NSString * isLike;            //是否点赞
@property (nonatomic,strong)NSString * width;           //图片宽度
@property (nonatomic,strong)NSString * height;          //图片高度
@property (nonatomic,copy)NSString * tags;              //标签
@property (nonatomic,copy)NSAttributedString *attributedText;//标签属性文字
@property (nonatomic,copy)NSAttributedString *nameAttributedText;//评论属性文字
@property (nonatomic,copy)NSString * sourcemodule;      //来源模块
@property (nonatomic,strong)NSString * sourcevalue;     //来源模块值
@property (nonatomic,strong)NSString *sourcetitle;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic, assign)CGRect contentFrame;

@property (nonatomic,strong)NSString *shortUrl;
- (void)setAttributedStrWith:(NSString *)content andFont:(UIFont *)font;
- (void)setNameAttributedStrWith:(NSString *)content andFont:(UIFont *)font;
@end
