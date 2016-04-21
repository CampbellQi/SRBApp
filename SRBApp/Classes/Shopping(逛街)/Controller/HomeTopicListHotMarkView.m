//
//  DiscoverHotMarkView.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define MARKVIEW_WIDTH_SCALE 0.8

#import "HomeTopicListHotMarkView.h"

@implementation HomeTopicListHotMarkView
{
    NSArray *_marksArray;
}
-(id)initWithFrame:(CGRect)frame MarksArray:(NSArray *)marksArray{
    if (self = [super initWithFrame:frame]) {
        _marksArray = marksArray;
        self.topView = [[[NSBundle mainBundle] loadNibNamed:@"HomeTopicListHotMarkView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:self.topView];
        self.topView.frame = self.bounds;
        self.clipsToBounds = YES;
        self.topView.clipsToBounds = YES;
        
        float width = self.contentSV.size.height * MARKVIEW_WIDTH_SCALE;
        float space = self.contentSV.size.height * (1 - MARKVIEW_WIDTH_SCALE);
        for (int i=0; i<marksArray.count; i++) {
            CGRect frame = CGRectMake(space/2 + (space/2 + width) * i, space/2, width, width);
            NSDictionary *marksDict = marksArray[i];
            
            MarkView *markView = [[MarkView alloc] initWithFrame:frame MarkName:marksDict];
            [self.contentSV addSubview:markView];
            markView.tag = 100 + i;
        }
        self.contentSV.contentSize = CGSizeMake(marksArray.count * (width + space/2) + space/2, 0);
    }
    return self;
}
-(void)setMarkViewTapBlock:(MarkViewTapBlock)markViewTapBlock {
    for (int i=0; i<_marksArray.count; i++) {
        MarkView *view = (MarkView *)[self viewWithTag:100 + i];
        view.markViewTapBlock = markViewTapBlock;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
