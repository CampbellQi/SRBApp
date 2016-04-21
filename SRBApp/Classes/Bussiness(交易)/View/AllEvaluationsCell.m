//
//  AllEvaluationsCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AllEvaluationsCell.h"

@implementation AllEvaluationsCell
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
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.frame.origin.x + +_headImage.frame.size.width + 10, 5, SCREEN_WIDTH - 160, 17)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_titleLabel];
        
        _sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y + _titleLabel.frame.size.height + 20, SCREEN_WIDTH - 80, 14)];
        [_sayLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"] ];
        _sayLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_sayLabel];
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170, _titleLabel.frame.origin.y, 155, 17)];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.sayLabel.text = text;
    //设置label的最大行数
    self.sayLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(SCREEN_WIDTH - _titleLabel.frame.origin.x - 15, 1000);
    CGSize labelSize = [self.sayLabel.text sizeWithFont:self.sayLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.sayLabel.frame = CGRectMake(self.sayLabel.frame.origin.x, self.sayLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    //计算出自适应的高度
    frame.size.height = labelSize.height + _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 20 + 26;
    
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
