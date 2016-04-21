//
//  DrawRecordCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DrawRecordCell.h"

@implementation DrawRecordCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 15)];
        _memoLabel.numberOfLines = 0;
        _memoLabel.font = SIZE_FOR_12;
        [_memoLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_memoLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 -  120, _memoLabel.frame.origin.y, 100, 16)];
        [_priceLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        _priceLabel.font = SIZE_FOR_14;
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        _updatetimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_memoLabel.frame.origin.x, _memoLabel.frame.origin.y + _memoLabel.frame.size.height + 7, 150, 15)];
        _updatetimeLabel.font = SIZE_FOR_12;
        [_updatetimeLabel setTextColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:1]];
        [self.contentView addSubview:_updatetimeLabel];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 -  60, _updatetimeLabel.frame.origin.y, 40, 12)];
        [_typeLabel setTextColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1]];
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textAlignment = NSTextAlignmentRight;
        _typeLabel.text = @"已申请";
        [self.contentView addSubview:_typeLabel];
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
