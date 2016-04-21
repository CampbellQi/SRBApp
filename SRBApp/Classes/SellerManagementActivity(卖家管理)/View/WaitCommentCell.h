//
//  WaitCommentCell.h
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZGoPayBtn.h"
#import "TosellerModel.h"

@interface WaitCommentCell : ZZTableViewCell
@property (nonatomic,strong)TosellerModel * toSellerModel;
@property (nonatomic,strong)UIImageView * goodsImg;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * sendPriceLabel;
@property (nonatomic,strong)ZZGoPayBtn * goCommentBtn;
+ (id)waitCommentCellWithTableView:(UITableView *)tableView;
@end
