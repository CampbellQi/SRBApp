//
//  WaitPublishCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "WaitPublishCell.h"

@implementation WaitPublishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _button = [[PublishButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 31, 30 + 16, 31, 35)];
        [_button setBackgroundImage:[UIImage imageNamed:@"editdelete"]  forState:UIControlStateNormal];
        //        [_button setBackgroundColor: [UIColor blackColor]];
        
        [self.contentView addSubview:_button];
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
