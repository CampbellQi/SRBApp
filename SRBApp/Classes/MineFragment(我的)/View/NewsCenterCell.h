//
//  NewsCenterCell.h
//  SRBApp
//
//  Created by zxk on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "NewsCenterModel.h"

@interface NewsCenterCell : ZZTableViewCell
@property (nonatomic,strong)MyImgView * stateImgView;
@property (nonatomic,strong)MyImgView * isNewImgView;
@property (nonatomic,strong)MyLabel * titleLabel;
@property (nonatomic,strong)MyLabel * contentLabel;
@property (nonatomic,strong)MyLabel * timeLabel;
@property (nonatomic,strong)MyLabel * detailLabel;
@property (nonatomic,strong)NewsCenterModel * newsCenterModel;
+ (id)newsCenterCellWithTableView:(UITableView *)tableView;
@end
