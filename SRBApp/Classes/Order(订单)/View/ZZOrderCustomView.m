//
//  ZZOrderCustomView.m
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZOrderCustomView.h"

@implementation ZZOrderCustomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIFont * fonts = SIZE_FOR_12;
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 14)];
        titleLabel.font = fonts;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.titleLabel = titleLabel;
        titleLabel.text = @"订单号";
        [self addSubview:titleLabel];
        
        UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.size.width + titleLabel.frame.origin.x + 5, 0, frame.size.width - 15 - 70 - 5 - 15, 14)];
        //contentLabel.enabled = NO;
        contentLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        contentLabel.font = fonts;
        self.contentLabel = contentLabel;
        [self addSubview:contentLabel];
        
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
