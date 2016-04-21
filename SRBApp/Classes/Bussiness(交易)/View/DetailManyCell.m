//
//  DetailManyCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/28.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "DetailManyCell.h"

@implementation DetailManyCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(_image.frame.origin.x + _image.frame.size.width + 25, _image.frame.origin.y, 80, 20)];
        _label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label];
        
        self.detailTextLabel.text = @"更多";
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
