//
//  GuaranteeCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeCell.h"

@implementation GuaranteeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 35, 35)];
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 17.5;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.frame.origin.x + +_headImage.frame.size.width + 10, _headImage.frame.origin.y + 5, 200, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_titleLabel];
        
//        _starlabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, 80, 16)];
//        _starlabel.text = @"信心指数:";
//        [_starlabel setTextColor:[UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1]];
//        _starlabel.font = [UIFont systemFontOfSize:16];
//        [self.contentView addSubview:_starlabel];
//        
//        _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(_starlabel.frame.origin.x + _starlabel.frame.size.width, _starlabel.frame.origin.y, 16, 12)];
//        [self.contentView addSubview:_image1];
//        
//        _image2 = [[UIImageView alloc]initWithFrame:CGRectMake(_image1.frame.origin.x + _image1.frame.size.width, _image1.frame.origin.y, 16, 12)];
//        [self.contentView addSubview:_image2];
//        
//        _image3 = [[UIImageView alloc]initWithFrame:CGRectMake(_image2.frame.origin.x + _image2.frame.size.width, _image2.frame.origin.y, 16, 12)];
//        [self.contentView addSubview:_image3];
//        
//        _image4 = [[UIImageView alloc]initWithFrame:CGRectMake(_image3.frame.origin.x + _image3.frame.size.width, _image3.frame.origin.y, 16, 12)];
//        [self.contentView addSubview:_image4];
//        
//        _image5 = [[UIImageView alloc]initWithFrame:CGRectMake(_image4.frame.origin.x + _image4.frame.size.width, _image4.frame.origin.y, 16, 12)];
//        [self.contentView addSubview:_image5];
        
        _sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 5, SCREEN_WIDTH - _titleLabel.frame.origin.x - 15, 16)];
        _sayLabel.font = [UIFont systemFontOfSize:14];
        _sayLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _sayLabel.numberOfLines = 0;
        _sayLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_sayLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, _titleLabel.frame.origin.y, 60, 12)];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_dateLabel];
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
