//
//  ZZLeftVCmyButtonTableViewCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZLeftVCmyButtonTableViewCell.h"

@implementation ZZLeftVCmyButtonTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(45, 25, 25, 25)];
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(45 + 25 + 21, 28, 100, 15)];
        [_label setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_label];
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
