//
//  AddressBookListCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AddressBookListCell.h"

@implementation AddressBookListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImage = [[MyImgView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        _headImage.backgroundColor = [UIColor clearColor];
        _headImage.layer.cornerRadius = 20;
        _headImage.layer.masksToBounds = YES;
        _headImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImage.frame.origin.x +_headImage.frame.size.width + 15, _headImage.frame.origin.y , SCREEN_WIDTH - 49 - 15 - 15 - 15 - 50, 18)];
        _titleLabel.font = SIZE_FOR_IPHONE;
        [_titleLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_titleLabel];
        
        self.sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y + _titleLabel.frame.size.height + 6, 200, 14)];
        [self.sourceLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"] ];
        self.sourceLabel.font = SIZE_FOR_12;
        [self.contentView addSubview:self.sourceLabel];

        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signButton.frame = CGRectMake(SCREEN_WIDTH - 65, 18, 50, 25);
        _signButton.layer.masksToBounds = YES;
        _signButton.layer.cornerRadius = 2;
        _signButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_signButton];
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
