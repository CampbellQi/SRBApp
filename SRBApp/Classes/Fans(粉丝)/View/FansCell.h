//
//  FansCell.h
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "FansAndImpressionBaseCell.h"
#import "FansModel.h"

@interface FansCell : FansAndImpressionBaseCell
@property (nonatomic,strong)FansModel * fansModel;
+ (id)fansCellWithTaableView:(UITableView *)tableView;
@end
