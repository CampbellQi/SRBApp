//
//  FansAndImpressionBaseCell.h
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "QinMiZhiShuImg.h"
#import <UIImageView+WebCache.h>

@interface FansAndImpressionBaseCell : ZZTableViewCell
@property (nonatomic,strong)UIImageView * logoImg;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * descriptionLabel;
@property (nonatomic,strong)UILabel * relationLabel;
@property (nonatomic,strong)UILabel * qinmiZhiShu;
@property (nonatomic,strong)QinMiZhiShuImg * qinMiZhiShuImg;
@end
