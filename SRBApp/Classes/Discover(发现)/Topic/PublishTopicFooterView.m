//
//  PublishTopicFooterView.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicFooterView.h"

@implementation PublishTopicFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"PublishTopicFooterView" owner:self options:nil][0];
        self.topView.frame = self.bounds;
        [self addSubview:self.topView];
        self.clipsToBounds = YES;
        self.topView.clipsToBounds = YES;
        
        self.locationHideBtn.layer.cornerRadius = 4.0f;
        self.locationHideBtn.layer.borderColor = DICECOLOR(214, 214, 214, 1).CGColor;
        self.locationHideBtn.layer.borderWidth = 1.0f;
        self.locationHideBtn.layer.cornerRadius = CGRectGetHeight(self.locationHideBtn.frame) * 0.5;
    }
    return self;
}
- (IBAction)locationHideBtnClicked:(UIButton *)sender {
    if (self.locationLbl.hidden) {
        self.locationLbl.hidden = NO;
        [sender setTitle:@"隐藏位置" forState:UIControlStateNormal];
    }else {
        self.locationLbl.hidden = YES;
        [sender setTitle:@"显示位置" forState:UIControlStateNormal];
    }
}
@end
