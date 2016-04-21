//
//  SellerEvaluateViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"
#import "MyLabel.h"

@interface SellerEvaluateViewController : ZZViewController
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

@end
