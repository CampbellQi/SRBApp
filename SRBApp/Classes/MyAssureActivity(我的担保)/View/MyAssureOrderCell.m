//
//  MyAssureOrderCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyAssureOrderCell.h"

@implementation MyAssureOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thingImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _thingImv.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
        _thingImv.contentMode = UIViewContentModeScaleAspectFill;
        _thingImv.clipsToBounds = YES;
        [self.contentView addSubview:_thingImv];
        
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(_thingImv.frame.origin.x + _thingImv.frame.size.width + 12, _thingImv.frame.origin.y, 200, 14)];
        _titleLb.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLb];
        
        _detailLb = [[UILabel alloc]initWithFrame:CGRectMake(_titleLb.frame.origin.x, _titleLb.frame.origin.y + _titleLb.frame.size.height + 10, 190, 14)];
        _detailLb.font = [UIFont systemFontOfSize:12];
        [_detailLb setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
        [self.contentView addSubview:_detailLb];
        
        _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(_detailLb.frame.origin.x, _detailLb.frame.origin.y + _detailLb.frame.size.height + 10, 100, 14)];
        _priceLb.font = [UIFont systemFontOfSize:14];
        [_priceLb setTextColor:[GetColor16 hexStringToColor:@"#e5005d"]];
        [self.contentView addSubview:_priceLb];
        
        _salerLb = [[UILabel alloc]initWithFrame:CGRectMake(_priceLb.frame.origin.x, _priceLb.frame.origin.y + _priceLb.frame.size.height + 10, 100, 12)];
        _salerLb.font = [UIFont systemFontOfSize:12];
        [_salerLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_salerLb];
        
        _customLb = [[UILabel alloc]initWithFrame:CGRectMake(_salerLb.frame.origin.x, _salerLb.frame.origin.y + _salerLb.frame.size.height + 10, 100, 12)];
        _customLb.font = [UIFont systemFontOfSize:12];
        [_customLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_customLb];
        
        _dateLb = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, _titleLb.frame.origin.y, 40, 12)];
        _dateLb.font = [UIFont systemFontOfSize:12];
        [_dateLb setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
        [self.contentView addSubview:_dateLb];
        
        _deleteBtn = [[PublishButton alloc]initWithFrame:CGRectMake(_dateLb.frame.origin.x, _dateLb.frame.origin.y + _dateLb.frame.size.height + 18, 20, 30)];
        [self.contentView addSubview:_deleteBtn];
        
        _moveListBtn = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95, _deleteBtn.frame.origin.y + _deleteBtn.frame.size.height, 80, 14)];
        _moveListBtn.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        _moveListBtn.textAlignment = NSTextAlignmentRight;
        _moveListBtn.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_moveListBtn];
        
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
