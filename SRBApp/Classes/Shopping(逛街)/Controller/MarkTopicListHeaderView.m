//
//  MarkTopicListHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkTopicListHeaderView.h"
#import "UIColor+Dice.h"
#import "MarkView.h"

@implementation MarkTopicListHeaderView
{
    MarkView *_markView;
}
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[[NSBundle mainBundle] loadNibNamed:@"MarkTopicListHeaderView" owner:self options:nil] objectAtIndex:0];
        self.topView.clipsToBounds = YES;
        self.topView.frame = self.bounds;
        [self addSubview:self.topView];
        self.clipsToBounds = YES;
        
        self.attentionBtn.layer.masksToBounds = YES;
        self.attentionBtn.layer.cornerRadius = 3.0f;
        
        MarkView *view = [[MarkView alloc] initWithFrame:self.coverIV.bounds MarkName:nil];
        [self.coverIV addSubview:view];
        view.nameLbl.hidden = YES;
        _markView = view;
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


-(void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    _markView.markDict = dataDict;
    self.nameLbl.text = dataDict[@"name"];
    if ([dataDict[@"isLike"] isEqualToString:@"0"]) {
        [self.attentionBtn setBackgroundColor:[UIColor diceColorWithRed:227 green:66 blue:134 alpha:1]];
        self.attentionBtn.selected = NO;
    }else {
        [self.attentionBtn setBackgroundColor:[UIColor diceColorWithRed:175 green:174 blue:180 alpha:1]];
        self.attentionBtn.selected = YES;
    }
    //self.attentionCountLbl.text = [NSString stringWithFormat:@"关注%@   话题%@", dataDict[@"likeCount"], dataDict[@"likeCount"]];
}
@end
