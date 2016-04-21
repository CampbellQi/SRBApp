//
//  PublishCell.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "MyImgView.h"

@interface PublishCell : ZZTableViewCell
@property (nonatomic, strong)MyImgView * picIV;
@property (nonatomic, strong)UILabel * titleLb;
@property (nonatomic, strong)UILabel * priceLb;
@property (nonatomic, strong)UIImageView * smallIV;
@property (nonatomic, strong)UILabel * addLb;
@property (nonatomic, strong)UILabel * dateLb;
@end
