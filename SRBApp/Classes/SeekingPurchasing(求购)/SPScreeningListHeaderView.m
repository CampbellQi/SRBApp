//
//  SPScreeningCollectionHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SPScreeningListHeaderView.h"

@implementation SPScreeningListHeaderView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"SPScreeningListHeaderView" owner:self options:nil][0];
        self.topView.clipsToBounds = YES;
        self.topView.frame = self.bounds;
        
        [self addSubview:self.topView];
        self.clipsToBounds = YES;
        
        for (int i=100; i<104; i++) {
            UIView *view = [self viewWithTag:i];
            view.layer.cornerRadius = view.height * 0.5;
            view.layer.borderColor = MAINCOLOR.CGColor;
            view.layer.borderWidth = 1.0f;
            
        }
    }
    return self;
}
-(void)layoutSubviews {
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)priceBtnClicked:(UIButton *)sender {
    NSString *priceA = @"0";
    NSString *priceB = @"100";
    switch (sender.tag - 100) {
        case 0:
            priceA = @"0";
            priceB = @"100";
            break;
        case 1:
            priceA = @"100";
            priceB = @"500";
            break;
        case 2:
            priceA = @"500";
            priceB = @"1000";
            break;
        case 3:
            priceA = @"1000";
            priceB = @"";
            break;
        default:
            break;
    }
    
    self.price1TF.text = priceA;
    self.price2TF.text = priceB;
}
@end
