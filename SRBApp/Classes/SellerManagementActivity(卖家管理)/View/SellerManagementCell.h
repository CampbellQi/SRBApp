//
//  SellerManagementCell.h
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZGoPayBtn.h"
#import "ZZGoPayBtn.h"
#import "SellerManagementModel.h"

@interface SellerManagementCell : ZZTableViewCell
@property (strong, nonatomic) UIImageView *logoImg;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *buyerLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (nonatomic,strong)UILabel * numLabel;
@property (nonatomic,strong)UILabel * sendPriceLabel;
@property (nonatomic,strong)UILabel * statusLabel;  //状态
@property (nonatomic,strong)ZZGoPayBtn * operationBtn;    //删除按钮
@property (nonatomic,strong)ZZGoPayBtn * goCommentBtn;      //去评价
@property (nonatomic,strong)SellerManagementModel * sellerModel;

+ (id)sellerManagementCellWithTableView:(UITableView *)tableView;

@end
