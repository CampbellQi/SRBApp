//
//  PublishTopicHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicHeaderView.h"

@implementation PublishTopicHeaderView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"PublishTopicHeaderView" owner:self options:nil][0];
        self.topView.frame = self.bounds;
        [self addSubview:self.topView];
        self.clipsToBounds = YES;
        self.topView.clipsToBounds = YES;
        
        
        self.addTagBtn.layer.cornerRadius = CGRectGetHeight(self.addTagBtn.frame) * 0.5;
        self.addTagBtn.layer.masksToBounds = YES;
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
