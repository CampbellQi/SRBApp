//
//  RightLookCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "RightLookCell.h"

@implementation RightLookCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _button = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 90, 90)];
        [self.contentView addSubview:_button];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(15, _button.frame.origin.y + _button.frame.size.height + 12, 90, 16)];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self.contentView addSubview:_label];
        
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _label.frame.origin.y + _label.frame.size.height + 6, 90, 16)];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self.contentView addSubview:_priceLabel];
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
