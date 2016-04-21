//
//  SaleMineCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SaleMineCell.h"

@implementation SaleMineCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thingimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _thingimage.contentMode = UIViewContentModeScaleAspectFill;
        _thingimage.clipsToBounds = YES;
        [self.contentView addSubview:_thingimage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_thingimage.frame.origin.x + _thingimage.frame.size.width + 15, 15, SCREEN_WIDTH - 45 - 60, 17)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _thingimage.center.y - 8,200,16)];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self.contentView addSubview:_priceLabel];
        
        _postLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width + 10, _priceLabel.frame.origin.y , 30, 16)];
        _postLabel.font = [UIFont systemFontOfSize:12];
        _postLabel.textAlignment = NSTextAlignmentCenter;
        _postLabel.layer.cornerRadius = 2;
        _postLabel.layer.masksToBounds = YES;
        _postLabel.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
        _postLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_postLabel];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x, _thingimage.frame.size.height + _thingimage.frame.origin.y - 14, SCREEN_WIDTH - 120 - 80, 17)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_nameLabel];
        
        //我要担保
        self.signLabelDown = [PublishButton buttonWithType:UIButtonTypeCustom];
        self.signLabelDown.frame = CGRectMake(SCREEN_WIDTH - 15 - 80, _thingimage.frame.origin.y + _thingimage.frame.size.height - 25, 80, 25);
        self.signLabelDown.layer.masksToBounds = YES;
        self.signLabelDown.layer.cornerRadius = 2;
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [self.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        self.signLabelDown.titleLabel.font = [UIFont systemFontOfSize:15];
        self.signLabelDown.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [self addSubview:self.signLabelDown];
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
