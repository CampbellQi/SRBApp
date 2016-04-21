//
//  SaleListCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SaleListCell.h"

@implementation SaleListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _theimage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 50, 50)];
        [self.contentView addSubview:_theimage];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(_theimage.frame.origin.x + _theimage.frame.size.width + 21, 29.5, 40, 16)];
        _label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
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
