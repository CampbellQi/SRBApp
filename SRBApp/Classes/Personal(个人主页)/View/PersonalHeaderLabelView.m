//
//  PersonalHeaderLabelView.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PersonalHeaderLabelView.h"

@implementation PersonalHeaderLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 10)/2, 0, 10, 12)];
        self.numLabel = numLabel;
        numLabel.font = SIZE_FOR_12;
        numLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 10)/2, numLabel.frame.size.height + numLabel.frame.origin.y + 5, 25, 12)];
        titleLabel.font = SIZE_FOR_12;
        self.titleLabel = titleLabel;
        titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
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
