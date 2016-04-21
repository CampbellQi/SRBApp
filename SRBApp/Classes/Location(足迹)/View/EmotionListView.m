//
//  EmotionListView.m
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionListView.h"
#import "EmotionPageView.h"

@interface EmotionListView ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView * scrollView;
@property (nonatomic,weak)UIPageControl * pageControl;
@end

@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITE;
        //scrollview
        UIScrollView * scrollView = [[UIScrollView alloc]init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        scrollView.pagingEnabled = YES;
        self.scrollView = scrollView;
        
        //pageControl
        UIPageControl * pageControl = [[UIPageControl alloc]init];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.enabled = NO;
        pageControl.hidesForSinglePage = YES;
        pageControl.backgroundColor = WHITE;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //设置页数
    NSUInteger count = (emotions.count + ZZEmotionPageSize - 1) / ZZEmotionPageSize;
    self.pageControl.numberOfPages = count;
    NSLog(@"%@",emotions);
    //显示表情
    for (int i = 0; i < count; i++) {
        EmotionPageView * pageView = [[EmotionPageView alloc]init];
        //设置这一页的表情
        NSRange range;
        range.location = i * ZZEmotionPageSize;
        //left:剩余的表情个数(可以截取的)
        NSUInteger left = emotions.count - range.location;
        if (left >= ZZEmotionPageSize) {
            range.length = ZZEmotionPageSize;
        }else{
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollView.x = self.scrollView.y = 0;
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    //设置scrollview内部每一页的尺寸
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        EmotionPageView * pageView = self.scrollView.subviews[i];
        pageView.backgroundColor = WHITE;
        pageView.height =  self.scrollView.height;
        pageView.width = self.scrollView.width;
        pageView.x = self.scrollView.width * i;
        pageView.y = 0;
    }
    
    //设置scrollview的contentsize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = self.scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

@end
