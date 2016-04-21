//
//  BussinessCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessCell.h"

@implementation BussinessCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thingimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 100, 100)];
        _thingimage.contentMode = UIViewContentModeScaleAspectFill;
        _thingimage.clipsToBounds = YES;
        [self.contentView addSubview:_thingimage];
        
        _signImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 32.5, 32.5)];
        _signImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_signImage];
        
        _titleLabel = [[MyLabel alloc]initWithFrame:CGRectMake(_thingimage.frame.origin.x + _thingimage.frame.size.width + 15, 15, SCREEN_WIDTH - 45 - 100, 40)];
        _titleLabel.font = SIZE_FOR_IPHONE;
        _titleLabel.verticalAlignment = VerticalAlignmentTop;
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, 130 - 15 - 16, SCREEN_WIDTH - 120 - 80, 17)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
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
