//
//  WantAssureCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WantAssureCell.h"

@implementation WantAssureCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _danbaoButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 70, 130 - 15 - 20, 70, 25)];
        [_danbaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_danbaoButton setTitle:@"我要担保" forState:UIControlStateNormal];
        _danbaoButton.titleLabel.font = SIZE_FOR_14;
        _danbaoButton.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [self.contentView addSubview:_danbaoButton];
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
