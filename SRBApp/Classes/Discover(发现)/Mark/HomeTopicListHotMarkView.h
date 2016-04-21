//
//  DiscoverHotMarkView.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"
#import "MarkView.h"

@interface HomeTopicListHotMarkView : UIView<PageScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentSV;
@property (weak, nonatomic) IBOutlet UIView *markMoreBgView;
@property (weak, nonatomic) IBOutlet UIView *topicMoreBgView;

@property (nonatomic, copy)MarkViewTapBlock markViewTapBlock;
-(id)initWithFrame:(CGRect)frame MarksArray:(NSArray *)marksArray;
@end
