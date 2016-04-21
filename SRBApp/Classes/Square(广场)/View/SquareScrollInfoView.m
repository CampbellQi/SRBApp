//
//  SquareScrollInfoView.m
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "SquareScrollInfoView.h"
#import "ZZGoPayBtn.h"

@implementation SquareScrollInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 122, 182)];
        bgView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
        bgView.layer.borderColor = [GetColor16 hexStringToColor:@"#eeeeee"].CGColor;
        bgView.layer.borderWidth = 1;
        [self addSubview:bgView];
        UIImageView * goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 110, 110)];
        self.goodsImg = goodsImg;
        [bgView addSubview:goodsImg];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 122, 110, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        self.titleLabel = titleLabel;
        [bgView addSubview:titleLabel];
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 161, 110, 15)];
        self.priceLabel = priceLabel;
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
        [bgView addSubview:priceLabel];
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
