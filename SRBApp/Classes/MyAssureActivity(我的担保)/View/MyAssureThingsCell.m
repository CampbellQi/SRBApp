//
//  MyAssureThingsCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyAssureThingsCell.h"

@implementation MyAssureThingsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thingImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _thingImv.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
        _thingImv.contentMode = UIViewContentModeScaleAspectFill;
        _thingImv.clipsToBounds = YES;
        [self.contentView addSubview:_thingImv];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(_thingImv.frame.origin.x + _thingImv.frame.size.width + 12, _thingImv.frame.origin.y, SCREEN_WIDTH - 60 - 12 - 50 - 10,17)];
        _titleLb.textColor = [GetColor16 hexStringToColor:@"#434343"];
        _titleLb.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLb];
        
        _detailLb = [[UILabel alloc]init];
//                     WithFrame:CGRectMake(_titleLb.frame.origin.x, _titleLb.frame.origin.y + _titleLb.frame.size.height + 6, SCREEN_WIDTH - 30 - 12 - 80, 45)];
        _detailLb.font = [UIFont systemFontOfSize:14];
        [_detailLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        _detailLb.numberOfLines = 0;
        [self.contentView addSubview:_detailLb];
        
        _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 48, _titleLb.frame.origin.y, 40, 14)];
        _dateLb.font = [UIFont systemFontOfSize:14];
        [_dateLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_dateLb];
        
        _deleteBtn = [[PublishButton alloc]init];
//                      WithFrame:CGRectMake(SCREEN_WIDTH - 95, _detailLb.frame.origin.y + _detailLb.frame.size.height + 6, 80, 25)];
        _deleteBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [_deleteBtn setTitle:@"取消担保" forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 2;
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
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
