//
//  MineEvaluateViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define BUYER_TYPE 0
#define SELLER_TYPE 1

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "MyLabel.h"
#import "BuyerWaitCommentViewController.h"

typedef void (^BackBlock) (void);
@interface MineEvaluateViewController : ZZViewController
{
    NSString * orderGrade;  //评分
    NSString * danBRGrade;  //担保人评分
    MBProgressHUD * HUD;
}
@property (nonatomic,strong)TosellerModel * toSellerModel;
@property (nonatomic,assign)int orderType;
@property (nonatomic,strong)NSString * orderID;
@property (strong, nonatomic) UIView *topBgView;
@property (strong, nonatomic) UIImageView *logoImg;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *kaopuZhishuLabel;
@property (strong, nonatomic) UILabel *huyouZhishuLabel;
@property (strong, nonatomic) UIView *kaopuBgView;
@property (strong, nonatomic) UIView *huyouBgView;
@property (strong, nonatomic) UILabel *kaopuBaiLabel;
@property (strong, nonatomic) UILabel *huyouBaiLabel;
@property (strong, nonatomic) UIImageView *goodsImg;
@property (strong, nonatomic) UILabel *goodsTitleLabel;
@property (strong, nonatomic) MyLabel *goodsDescriptionLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *toHeLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (nonatomic, copy)BackBlock backBlock;


@end
