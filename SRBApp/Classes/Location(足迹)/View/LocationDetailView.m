//
//  LocationDetailView.m
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationDetailView.h"

@implementation LocationDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [self addSubview:lineView];
        
        UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        logoImg.layer.masksToBounds = YES;
        logoImg.layer.cornerRadius = 15;
        self.logoImg = logoImg;
        [self addSubview:logoImg];
        
        NameTextView * nameLabel = [[NameTextView alloc]initWithFrame:CGRectMake(55, 10, 100, 17)];
        nameLabel.font = SIZE_FOR_14;
        nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.userInteractionEnabled = YES;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel * timeLabel = [[UILabel alloc]init];
        timeLabel.font = SIZE_FOR_12;
        timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        
        LocationMyLabel * contentLabel = [[LocationMyLabel alloc]init];
        contentLabel.font = SIZE_FOR_14;
        contentLabel.userInteractionEnabled = YES;
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
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
