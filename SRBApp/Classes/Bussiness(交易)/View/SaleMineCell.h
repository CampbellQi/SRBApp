//
//  SaleMineCell.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "PublishButton.h"

@interface SaleMineCell : ZZTableViewCell
@property (nonatomic, strong)UIImageView * thingimage;
@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic ,strong)UILabel * nameLabel;
@property (nonatomic ,strong)UILabel * priceLabel;
@property (nonatomic ,strong)UILabel * postLabel;
@property (nonatomic ,strong)UILabel * commentLabel;
@property (nonatomic ,strong)PublishButton * signLabelDown;
@end
