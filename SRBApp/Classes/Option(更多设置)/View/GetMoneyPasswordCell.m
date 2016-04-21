//
//  GetMoneyPasswordCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GetMoneyPasswordCell.h"

@implementation GetMoneyPasswordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
        [self.contentView addSubview:self.imgview];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.imgview.frame.origin.x + self.imgview.frame.size.width + 15, self.imgview.frame.origin.y + 5, 200, 15)];
        self.label.font = [UIFont systemFontOfSize:15];
        self.label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [self.contentView addSubview:self.label];
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
