//
//  OrderStatusView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "OrderStatusView.h"

@implementation OrderStatusView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"OrderStatusView" owner:self options:nil][0];
        [self addSubview:self.topView];
        
        self.topView.frame = self.bounds;
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
