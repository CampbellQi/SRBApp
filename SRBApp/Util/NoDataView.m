//
//  NoDataView.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "NoDataView.h"
#import "GetColor16.h"

@implementation NoDataView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
        
        //UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 197)/2, 75, 70, 100)];
         UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 75, 80, 80)];
        self.imageV = imageV;
//        imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        [imageV setImage:[UIImage imageNamed:@"empty"]];
        [self addSubview:imageV];
        
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.size.width + imageV.frame.origin.x + 12, 125, 115, 16)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 170, 115, 16)];
        label.text = @"还没有相关数据...";
        label.textColor = [GetColor16 hexStringToColor:@"#d7d5d5"];
        label.textAlignment = NSTextAlignmentLeft;
        self.label = label;
        label.font = SIZE_FOR_14;
        [self addSubview:label];
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
