//
//  OrderSPView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "OrderSPView.h"

@implementation OrderSPView
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"OrderSPView" owner:self options:nil][0];
        [self addSubview:self.topView];
        
        self.topView.frame = self.bounds;
        self.topView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        self.avater1.layer.masksToBounds = YES;
        self.avater1.layer.cornerRadius = CGRectGetHeight(self.avater1.frame) * 0.5;
        self.avater2.layer.masksToBounds = YES;
        self.avater2.layer.cornerRadius = CGRectGetHeight(self.avater2.frame) * 0.5;
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
