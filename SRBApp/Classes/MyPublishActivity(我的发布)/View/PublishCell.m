//
//  PublishCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PublishCell.h"

@implementation PublishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _picIV = [[MyImgView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _picIV.contentMode = UIViewContentModeScaleAspectFill;
        _picIV.userInteractionEnabled = YES;
        _picIV.clipsToBounds = YES;
        [self.contentView addSubview:_picIV];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(_picIV.frame.origin.x + _picIV.frame.size.width + 12, _picIV.frame.origin.y, SCREEN_WIDTH - 75 - 12 - 5 - 35 - 15, 16)];
        _titleLb.font = SIZE_FOR_14;
        [_titleLb setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_titleLb];
        
        _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(_titleLb.frame.origin.x, _titleLb.frame.origin.y + _titleLb.frame.size.height + 8, 100, 17)];
        _priceLb.font = SIZE_FOR_14;
        [_priceLb setTextColor:[GetColor16 hexStringToColor:@"#e5005d"]];
        [self.contentView addSubview:_priceLb];
        
        _smallIV = [[UIImageView alloc]initWithFrame:CGRectMake(_priceLb.frame.origin.x, _priceLb.frame.origin.y + _priceLb.frame.size.height + 7, 11, 17)];
        _smallIV.image = [UIImage imageNamed:@"fb_wz.png"];
        [self.contentView addSubview:_smallIV];
        
        _addLb = [[UILabel alloc]initWithFrame:CGRectMake(_smallIV.frame.origin.x + _smallIV.frame.size.width, _smallIV.frame.origin.y, SCREEN_WIDTH - 185, 14)];
        _addLb.font = SIZE_FOR_12;
        [_addLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_addLb];
        
        _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 35, _titleLb.frame.origin.y, 35, 12)];
        _dateLb.textAlignment = NSTextAlignmentRight;
        _dateLb.textColor = [GetColor16 hexStringToColor:@"#959595"];
        _dateLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateLb];
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
