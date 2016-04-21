//
//  BrowsingHistoryCell.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "BrowsingHistoryModel.h"


@interface BrowsingHistoryCell : ZZTableViewCell
@property (nonatomic,strong)UIImageView * imageview;
@property (nonatomic,strong)UILabel * goodsTitleLabel;  //商品名称
@property (nonatomic,strong)UILabel * descriptionLabel; //商品描述
@property (nonatomic,strong)UILabel * priceLabel;       //商品价格

@property (nonatomic,strong)BrowsingHistoryModel * browsingHistoryModel;

+ (id)browsingHeistoryCellWithTableView:(UITableView *)tableView;
@end
