//
//  DetailCommentCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DetailCommentCell.h"

@implementation DetailCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImage = [[MyImgView alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
        _headImage.userInteractionEnabled = YES;
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 15;
        _headImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.frame.origin.x + +_headImage.frame.size.width + 10, 5, SCREEN_WIDTH - 150, 19)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_titleLabel];
        
        _huifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 2, 30, 17)];
        _huifuLabel.text = @"回复 ";
        _huifuLabel.font = SIZE_FOR_14;
        [self.contentView addSubview:_huifuLabel];
        
        _sayToWhoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_huifuLabel.frame.origin.x + _huifuLabel.frame.size.width,_huifuLabel.frame.origin.y, 200, 17)];
        _sayToWhoLabel.font = SIZE_FOR_14;
        _sayToWhoLabel.hidden = NO;
        _sayToWhoLabel.textAlignment = NSTextAlignmentLeft;
        _sayToWhoLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self.contentView addSubview:_sayToWhoLabel];
        
        _sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_huifuLabel.frame.origin.x,_huifuLabel.frame.origin.y + _huifuLabel.frame.size.height + 5, SCREEN_WIDTH - 80, 17)];
        [_sayLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"] ];
        _sayLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_sayLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, _titleLabel.frame.origin.y, 155, 12)];
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
