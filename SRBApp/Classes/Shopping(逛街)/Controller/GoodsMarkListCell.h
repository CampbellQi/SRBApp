//
//  GoodsMarkListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define MARK_SPAE 12
#define MARK_WIDTH (SCREEN_WIDTH - 5 * MARK_SPAE)/4
#define CELL_HEIGTH MARK_WIDTH + MARK_SPAE
#define ROW_MARKCOUNT 4

#import <UIKit/UIKit.h>
#import "MarkView.h"

@interface GoodsMarkListCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *marksArray;
@property (nonatomic, copy)MarkViewTapBlock markViewTapBlock;
@end
