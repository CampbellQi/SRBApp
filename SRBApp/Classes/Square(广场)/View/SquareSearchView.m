//
//  SquareSearchView.m
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SquareSearchView.h"

@implementation SquareSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        imgview.layer.masksToBounds = YES;
        imgview.layer.cornerRadius = 25;
        self.imgview = imgview;
        [self addSubview:imgview];
        
        UILabel * searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 56, 40, 16)];
        searchLabel.font = SIZE_FOR_IPHONE;
        self.searchLabel = searchLabel;
        [self addSubview:searchLabel];
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
