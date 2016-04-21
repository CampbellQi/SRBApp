//
//  GoodsOrderHeaderView.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define CAROUSEL_HEIGHT SCREEN_WIDTH / 320 * 160.0

#import <UIKit/UIKit.h>
#import "PageScrollView.h"
#import "BussinessModel.h"
#import "TopicListCell.h"
#import "TopicMoreView.h"

@interface HomeTopicListHeaderView : UIView<PageScrollViewDelegate>
@property (nonatomic, strong)TopicListCell *cv;
@property (nonatomic, assign)float totalHeight;
@property (nonatomic, strong)TopicMoreView *dailyTopicMoreView;

@property (nonatomic, strong)BussinessModel *sourceModel;
-(id)initWithFrame:(CGRect)frame CarouselArray:(NSArray *)carouselArray BussinessModel:(BussinessModel *)sourceModel;
@end
