//
//  SellerEvaluateVC.h
//  SRBApp
//
//  Created by zxk on 15/1/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "MyLabel.h"
#import "WaitCommentViewController.h"

@interface SellerEvaluateVC : ZZViewController
{
    NSString * orderGrade;  //评分
    MBProgressHUD * HUD;
}
@property (nonatomic,strong)TosellerModel * toSellerModel;
@property (strong, nonatomic) UIView *topBgView;
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UILabel *buyerNameLabel;
@property (strong, nonatomic) UIImageView *goodsImg;
@property (strong, nonatomic) UILabel *goodsTitleLabel;
@property (strong, nonatomic) MyLabel *goodsDescriptionLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *toHeLabel;
@property (nonatomic,strong)WaitCommentViewController * waitCommentVC;

@end
