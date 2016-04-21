//
//  RechargeListCell.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZGoPayBtn.h"
#import "RechargeListModel.h"

@interface RechargeListCell : ZZTableViewCell
@property (nonatomic,strong)UILabel * orderNum;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)ZZGoPayBtn * goPayBtn;
@property (nonatomic,strong)UILabel * stateLabel;
@property (nonatomic,strong)RechargeListModel * rechargeModel;

+ (id)rechargeListCellWithTableView:(UITableView *)tableView;
@end
