//
//  MyEvaluateViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "MyLabel.h"

@interface MyEvaluateViewController : ZZViewController
{
    NSString * orderGrade;  //评分
    MBProgressHUD * HUD;
}
@property (nonatomic,strong)TosellerModel * toSellerModel;
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

@end
