//
//  SquareSearchCell.m
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SquareSearchCell.h"

@implementation SquareSearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 50, 50)];
        [self addSubview:_logoImg];
        
        _categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(96, 30, 100, 16)];
        _categoryLabel.font = SIZE_FOR_IPHONE;
        [self addSubview:_categoryLabel];
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
