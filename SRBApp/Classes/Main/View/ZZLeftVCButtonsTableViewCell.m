//
//  ZZLeftVCButtonsTableViewCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZLeftVCButtonsTableViewCell.h"
#import "Constant.h"

@implementation ZZLeftVCButtonsTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _protectButton = [[UIButton alloc]initWithFrame:CGRectMake(0,20, (SCREEN_WIDTH - 60) / 3 , 25)];
        [_protectButton setTitle:@"我的担保" forState:UIControlStateNormal];
        _protectButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        _protectButton.font = [UIFont systemFontOfSize:12];
        [self addSubview:_protectButton];
        
        _picProtectButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, (SCREEN_WIDTH - 60) / 3 , 25)];
//        [_picProtectButton setBackgroundImage:[UIImage imageNamed:@"wd_db.png"] forState:UIControlStateNormal];
        _picProtectButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_picProtectButton];
        
        _nopicProtectButton = [[UIButton alloc]initWithFrame:CGRectMake(_picProtectButton.frame.origin.x + _picProtectButton.frame.size.width / 2 - 8,5, 15 , 15)];
        [_nopicProtectButton setBackgroundImage:[UIImage imageNamed:@"wd_db.png"] forState:UIControlStateNormal];
        _nopicProtectButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_nopicProtectButton];
        
        
        _attentButton = [[UIButton alloc]initWithFrame:CGRectMake(_protectButton.frame.origin.x + (SCREEN_WIDTH - 60) / 3 , 20, (SCREEN_WIDTH - 60) / 3, 25)];
        _attentButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [_attentButton setTitle:@"关注收藏" forState:UIControlStateNormal];
        _attentButton.font = [UIFont systemFontOfSize:12];
        [self addSubview:_attentButton];
        
        _picAttentButton = [[UIButton alloc]initWithFrame:CGRectMake(_attentButton.frame.origin.x,0, (SCREEN_WIDTH - 60) / 3 , 25)];
//        [_picAttentButton setBackgroundImage:[UIImage imageNamed:@"wd_gz.png"] forState:UIControlStateNormal];
        _picAttentButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_picAttentButton];
        
        _nopicAttentButton = [[UIButton alloc]initWithFrame:CGRectMake(_picAttentButton.frame.origin.x + _picAttentButton.frame.size.width / 2 - 8,5, 15 , 15)];
        [_nopicAttentButton setBackgroundImage:[UIImage imageNamed:@"wd_gz.png"] forState:UIControlStateNormal];
        _nopicAttentButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_nopicAttentButton];
        

        _historyButton = [[UIButton alloc]initWithFrame:CGRectMake(_attentButton.frame.origin.x + (SCREEN_WIDTH - 60) / 3 , 20, (SCREEN_WIDTH - 60) / 3, 25)];
        _historyButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [_historyButton setTitle:@"我的历史" forState:UIControlStateNormal];
        _historyButton.font = [UIFont systemFontOfSize:12];
        [self addSubview:_historyButton];
        
        _picHtoryButton = [[UIButton alloc]initWithFrame:CGRectMake(_historyButton.frame.origin.x,0, (SCREEN_WIDTH - 60) / 3 , 25)];
//        [_picHtoryButton setBackgroundImage:[UIImage imageNamed:@"wd_ls.png"] forState:UIControlStateNormal];
        _picHtoryButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_picHtoryButton];
        
        _nopicHtoryButton = [[UIButton alloc]initWithFrame:CGRectMake(_picHtoryButton.frame.origin.x + _picHtoryButton.frame.size.width / 2 - 8,5, 15 , 15)];
        [_nopicHtoryButton setBackgroundImage:[UIImage imageNamed:@"wd_ls.png"] forState:UIControlStateNormal];
        _nopicHtoryButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
        [self addSubview:_nopicHtoryButton];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
