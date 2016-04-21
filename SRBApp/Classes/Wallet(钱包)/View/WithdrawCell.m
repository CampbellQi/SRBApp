//
//  WithdrawCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "WithdrawCell.h"

@implementation WithdrawCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _image.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_image];
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
