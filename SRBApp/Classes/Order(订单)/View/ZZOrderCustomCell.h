//
//  ZZOrderCustomCell.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZOrderModel.h"
#import "ZZOrderCustomBtn.h"
#import "ZZGoPayBtn.h"

@interface ZZOrderCustomCell : ZZTableViewCell
@property (nonatomic,strong)UIImageView * imageview;
@property (nonatomic,strong)UILabel * orderIDLabel;     //订单ID
@property (nonatomic,strong)UILabel * numLabel;
@property (nonatomic,strong)UILabel * sendPriceLabel;
@property (nonatomic,strong)UILabel * orderTitleLabel;  //订单标题
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * sellerNameLabel;
@property (nonatomic,strong)UILabel * buyerNameLabel;
@property (nonatomic,strong)UILabel * statusLabel;      //订单状态
@property (nonatomic,strong)ZZGoPayBtn * delBtn;             //删除按钮
@property (nonatomic,strong)ZZGoPayBtn * goPayBtn;           //付款按钮
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)ZZOrderModel * orderModel;

+ (id)settingCellWithTaableView:(UITableView *)tableView;
@end
