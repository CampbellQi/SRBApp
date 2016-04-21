//
//  SaytoCommentViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/4/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MarkModel.h"
#import "TapImageView.h"
#import "LocationModel.h"
#import "LeftImgAndRightTitleBtn.h"
#import "MyImgView.h"
#import "MyLabel.h"
#import "CopyLabel.h"
#import "ZZGoPayBtn.h"
#import "LocationDetailView.h"
#import "HPGrowingTextView.h"
#import "SubViewController.h"
#import "NSString+CXHyperlinkParserSecond.h"
#import "SubViewController.h"
#import "MapViewController.h"

@interface SaytoCommentViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic,strong)MarkModel * model;
@property (nonatomic,strong)UIImageView * logoImg;  //头像
@property (nonatomic,strong)UILabel * nameLabel;    //标题
@property (nonatomic,strong)UILabel * timeLabel;    //时间
@property (nonatomic,strong)CopyLabel * descriptionLabel;     //详情
@property (nonatomic,strong)TapImageView * photoImg1;  //照片1
@property (nonatomic,strong)TapImageView * photoImg2;  //照片2
@property (nonatomic,strong)TapImageView * photoImg3;  //照片3
@property (nonatomic,strong)TapImageView * photoImg4;  //照片4
@property (nonatomic,strong)TapImageView * photoImg5;  //照片5
@property (nonatomic,strong)TapImageView * photoImg6;  //照片6
@property (nonatomic,strong)TapImageView * photoImg;   //大图
@property (nonatomic,strong)UIImageView * locationImg;  //定位
@property (nonatomic,strong)MyLabel * addressLabel;    //地址
@property (nonatomic,strong)ZZGoPayBtn * moreBtn;         //分享和点赞
@property (nonatomic,strong)UIImageView * sanjiaoImg;   //三角图片
@property (nonatomic,strong)UIView * zanNumBgView;      //赞的背景view
@property (nonatomic,strong)UIView * zanLineView;          //赞分割线
@property (nonatomic,strong)UIView * tempViewForComment;
@property (nonatomic,strong)UIView * tempViewForZanPerson;

@property (nonatomic,strong)UILabel * numPerLabel;      //多少人赞
@property (nonatomic,strong)UIView * twoButtonView;     //两个button的背景view

@property (nonatomic,strong)UIView * lineView;        //时间
@property (nonatomic,copy)LocationModel * locationModel;
@property (nonatomic,strong)UILabel * alertLabel;   //+1
@property (nonatomic,strong)LeftImgAndRightTitleBtn * zanBtn;
@property (nonatomic,strong)LeftImgAndRightTitleBtn * shareBtn;
@property (nonatomic,strong)HPGrowingTextView * hpTextView;

@property (nonatomic,copy)NSString * markID;
@property (nonatomic,copy)NSString * locationID;
@property (nonatomic, strong)UILabel * pageLabel;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@end
