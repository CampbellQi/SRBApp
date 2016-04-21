//
//  NewsCenterMainViewCell.m
//  SRBApp
//  消息中心一级页面
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "NewsCenterMainCell.h"

@implementation NewsCenterMainCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.countLbl.layer.masksToBounds = YES;
    self.countLbl.layer.cornerRadius = 0.5 * CGRectGetWidth(self.countLbl.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
