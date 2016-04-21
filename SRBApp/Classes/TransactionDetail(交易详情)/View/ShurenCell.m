//
//  ShurenCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShurenCell.h"

@implementation ShurenCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10.75, 19, 18.5)];
        [self.contentView addSubview:_chooseImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_chooseImage.frame.origin.x + _chooseImage.frame.size.width + 30, 12, 140, 16)];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self.contentView addSubview:_nameLabel];
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
