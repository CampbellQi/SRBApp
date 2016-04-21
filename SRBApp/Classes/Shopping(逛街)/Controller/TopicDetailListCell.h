//
//  TopicDetailListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define CONTENT_LBL_XMARGIN 8

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"


@interface TopicDetailListCell : UITableViewCell

@property (nonatomic, strong)TopicDetailModel *sourceData;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end
