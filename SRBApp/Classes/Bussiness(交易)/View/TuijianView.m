//
//  TuijianView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TuijianView.h"

@implementation TuijianView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 110, 110)];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        [self addSubview:_imageV];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.frame.origin.x, _imageV.frame.size.height + _imageV.frame.origin.y + 6, _imageV.frame.size.width, 35)];
        _title.numberOfLines = 0;
        _title.textColor = [GetColor16 hexStringToColor:@"#434343"];
        _title.font = [UIFont systemFontOfSize:12];
        [self addSubview:_title];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(_title.frame.origin.x, _title.frame.size.height + _title.frame.origin.y + 7,_imageV.frame.size.width , 15)];
        _price.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        _price.font = [UIFont systemFontOfSize:15];
        [self addSubview:_price];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(_price.frame.origin.x, _price.frame.size.height + _price.frame.origin.y + 7, _imageV.frame.size.width, 14)];
        _content.textColor = [GetColor16 hexStringToColor:@"#434343"];
        _content.font = [UIFont systemFontOfSize:12];
        [self addSubview:_content];
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
