//
//  OptionTableViewCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "OptionTableViewCell.h"

@implementation OptionTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 40, 7.5, 40, 25)];
        _mySwitch.onTintColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
        [self.contentView addSubview:_mySwitch];
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
