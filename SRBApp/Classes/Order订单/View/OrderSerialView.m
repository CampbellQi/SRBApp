//
//  OrderSerialView.m
//  SRBApp
//  订单流水
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "OrderSerialView.h"

@implementation OrderSerialView
-(id)initWithData:(NSArray *)data Frame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        float h_margin = 10, v_margin = 10,height = 20;
        float width = (CGRectGetWidth(frame) - 3 * h_margin)/2;
        for (int i=0; i<data.count; i++) {
            NSDictionary *dict = data[i];
            UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(h_margin, (v_margin + height) * i + v_margin, width, height)];
            lbl1.font = [UIFont systemFontOfSize:12.0];
            lbl1.textColor = [UIColor lightGrayColor];
            lbl1.text = dict[@"title"];
            
            UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - width - h_margin, CGRectGetMinY(lbl1.frame), width, height)];
            lbl2.font = [UIFont systemFontOfSize:12.0];
            lbl2.textColor = [UIColor lightGrayColor];
            lbl2.text = dict[@"time"];
            lbl2.textAlignment = NSTextAlignmentRight;
            
            [self addSubview:lbl1];
            [self addSubview:lbl2];
        }
        
        float vHeight = data.count * (height + v_margin) + v_margin;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, vHeight);
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
