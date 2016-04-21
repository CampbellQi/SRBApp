//
//  PublishPhotoCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PublishPhotoCell.h"

@implementation PublishPhotoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1];
        
        _button1 = [[UIButton alloc]init];
        _button1.backgroundColor = [UIColor clearColor];
        [_button1 setBackgroundImage:[UIImage imageNamed:@"fb_xy.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_button1];
        
        _button2 = [[UIButton alloc]init];
        _button2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_button2];
        
        _button3 = [[UIButton alloc]init];
        _button3.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_button3];
        
        _button4 = [[UIButton alloc]init];
        _button4.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_button4];
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
