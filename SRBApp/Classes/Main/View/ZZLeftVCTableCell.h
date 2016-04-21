//
//  ZZLeftVCTableCell.h
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewCell.h"
#import "ZZLeftVCModel.h"
@interface ZZLeftVCTableCell : ZZTableViewCell
@property (nonatomic,strong)ZZLeftVCModel * leftModel;

+ (id)settingCellWithTaableView:(UITableView *)tableView;
@end
