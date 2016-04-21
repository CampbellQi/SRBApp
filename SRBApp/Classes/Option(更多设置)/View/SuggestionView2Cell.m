//
//  SuggestionView2Cell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SuggestionView2Cell.h"

@implementation SuggestionView2Cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(25, 17, 70, 16)];
        _label.text = @"意见反馈";
        [self.contentView addSubview:_label];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_label.frame.origin.x + _label.frame.size.width + 5, 10, 1, 30)];
        label.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        [self addSubview:label];
        
//        _button = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width , 20, 70, 16)];
//        [_button setTitle:@"UI建议" forState:UIControlStateNormal];
//        [_button setTitleColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] forState:UIControlStateNormal];
//        [self.contentView addSubview:_button];
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
