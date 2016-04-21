//
//  DownMineCell.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DownMineCell.h"
#import "GetColor16.h"

@implementation DownMineCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12 + 7.5, 25, 25)];
        [self.contentView addSubview:_imageview];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(_imageview.frame.size.width + _imageview.frame.origin.x + 25, 12 + 12.5, 80, 15)];
        _label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        _label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_label];
        
        //提示语
        self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 150, _label.frame.origin.y, 135, 15)];
        self.signLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.signLabel.font = SIZE_FOR_12;
        self.signLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.signLabel];
        
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
