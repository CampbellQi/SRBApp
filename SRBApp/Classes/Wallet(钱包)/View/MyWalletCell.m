//
//  MyWalletCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyWalletCell.h"

@implementation MyWalletCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 19)];
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x + _image.frame.size.width + 25, _image.frame.origin.y, 200, 20)];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [GetColor16 hexStringToColor:@"2b2b2b"];
        [self.contentView addSubview:_label];
        
//        _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x + _image.frame.size.width + 25, _image.frame.origin.y, 80, 20)];
//        _balanceLabel.font = [UIFont systemFontOfSize:15];
//        _balanceLabel.textColor = [GetColor16 hexStringToColor:@"2b2b2b"];
//        [self.contentView addSubview:_balanceLabel];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
