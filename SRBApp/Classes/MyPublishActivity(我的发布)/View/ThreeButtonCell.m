//
//  ThreeButtonCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ThreeButtonCell.h"

@implementation ThreeButtonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _saleButton = [[UIButton alloc]init];
        [_saleButton setTitle:@"我要卖" forState:UIControlStateNormal];
        [self.contentView addSubview:_saleButton];
        
        _buyButton = [[UIButton alloc]init];
        [_buyButton setTitle:@"我要买" forState:UIControlStateNormal];
        [self.contentView addSubview:_buyButton];
        
        _wayButton = [[UIButton alloc]init];
        [_wayButton setTitle:@"足迹" forState:UIControlStateNormal];
        [self.contentView addSubview:_wayButton];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
