//
//  ProtectCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ProtectCell.h"

@implementation ProtectCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 25, 75, 75)];
        _imageButton.backgroundColor = [UIColor clearColor];
        _imageButton.layer.cornerRadius = 37;
        _imageButton.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageButton];
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 + 75 + 18, 29, 200, 15)];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        [_phoneLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_phoneLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 50, _phoneLabel.frame.origin.y, 50, 14)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        
        _starLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 + 75 + 18,29 + 23, 60, 12)];
        _starLabel.text = @"信心指数:";
        [_starLabel setTextColor:[GetColor16 hexStringToColor:@"#e5005d"]];
        _starLabel.font = [UIFont systemFontOfSize:12];
        _starLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_starLabel];
        
        _label1 = [[UIImageView alloc]initWithFrame:CGRectMake(_starLabel.frame.origin.x + _starLabel.frame.size.width, _starLabel.frame.origin.y, 12, 9)];
        _label1.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        [self.contentView addSubview:_label1];
        
        _label2 = [[UIImageView alloc]initWithFrame:CGRectMake(_label1.frame.origin.x + _label1.frame.size.width, _starLabel.frame.origin.y, 12, 9)];
        _label2.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        [self.contentView addSubview:_label2];
        
        _label3 = [[UIImageView alloc]initWithFrame:CGRectMake(_label2.frame.origin.x + _label2.frame.size.width, _starLabel.frame.origin.y, 12, 9)];
        _label3.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        [self.contentView addSubview:_label3];
        
        _label4 = [[UIImageView alloc]initWithFrame:CGRectMake(_label3.frame.origin.x + _label3.frame.size.width, _starLabel.frame.origin.y, 12, 9)];
        _label4.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        [self.contentView addSubview:_label4];
        
        _label5 = [[UIImageView alloc]initWithFrame:CGRectMake(_label4.frame.origin.x + _label4.frame.size.width, _starLabel.frame.origin.y, 12, 9)];
        _label5.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        [self.contentView addSubview:_label5];
        
        _sayLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 + 75 + 18, 29 + 23 + 17, 200, 12)];
        _sayLabel.font = [UIFont systemFontOfSize:12];
        [_sayLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_sayLabel];
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
