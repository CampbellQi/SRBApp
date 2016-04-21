//
//  SellerOrderCommentViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "TosellerModel.h"

@interface SellerEvaluateActivity : ZZViewController
{
    NSString * orderGrade;
}
@property (nonatomic,strong)TosellerModel * toSellerModel;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIView *goodView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *badView;
@property (weak, nonatomic) IBOutlet UIView *fakeView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
@property (weak, nonatomic) IBOutlet UIImageView *middleImg;
@property (weak, nonatomic) IBOutlet UIImageView *badImg;
@property (weak, nonatomic) IBOutlet UIImageView *fakeImg;

@end
