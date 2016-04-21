//
//  MessagePushTableViewCell.m
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MessagePushTableViewCell.h"

@implementation MessagePushTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.messageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 40, 7.5, 40, 25)];
        self.messageSwitch.onTintColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
        [self.contentView addSubview:self.messageSwitch];
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
