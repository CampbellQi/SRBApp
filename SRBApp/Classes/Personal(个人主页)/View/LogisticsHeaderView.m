//
//  LogisticsHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "LogisticsHeaderView.h"

@implementation LogisticsHeaderView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"LogisticsHeaderView" owner:self options:nil][0];
        self.topView.frame = self.bounds;
        [self addSubview:self.topView];
        self.topView.clipsToBounds = YES;
        self.clipsToBounds = YES;
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
