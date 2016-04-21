//
//  ImpressionCell.h
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FansAndImpressionBaseCell.h"
#import "RemarkModel.h"

@interface ImpressionCell : FansAndImpressionBaseCell
@property (nonatomic,strong)RemarkModel * impressionModel;
+ (id)impressionCellWithTaableView:(UITableView *)tableView;
@end
