//
//  GuaranteeNumImageView.h
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@interface GuaranteeNumImageView : ZZView
@property (nonatomic,assign)int num;
@property (nonatomic,strong)UIImageView * imgOne;
@property (nonatomic,strong)UIImageView * imgTwo;
@property (nonatomic,strong)UIImageView * imgThree;
@property (nonatomic,strong)UIImageView * imgFour;
@property (nonatomic,strong)UIImageView * imgFive;
@property (nonatomic,strong)UILabel * danbaoNameLabel;  //担保人
@property (nonatomic,strong)UILabel * danbaoPriceLabel; //担保价格
- (void)setImage:(int)num;
@end
