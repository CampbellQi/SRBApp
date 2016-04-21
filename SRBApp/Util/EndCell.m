//
//  EndCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "EndCell.h"

@implementation EndCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        label.text = @"暂时没有更多内容了";
        label.font = [UIFont systemFontOfSize:16];
        [label setTextColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1]];
        [self.contentView addSubview:label];
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
