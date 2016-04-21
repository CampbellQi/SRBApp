//
//  CarouselDiagram.m
//  CoolCar
//
//  Created by winter on 14-10-19.
//  Copyright (c) 2014年 winter. All rights reserved.
//

#import "CarouselDiagram.h"

@implementation CarouselDiagram

- (id)initWithFrame:(CGRect)frame andimgArray:(NSMutableArray *)imgArray
{
    self = [super initWithFrame:frame];
    if (self) {

        self.imageArray = imgArray;
        
    }
    return self;
}

- (void)start
{

    UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.imageArray .count*SCREEN_WIDTH , 130);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self ;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    for (int i = 0; i < self.imageArray .count; i ++) {
        UIImageView *imageView = [self.imageArray  objectAtIndex:i];
        [_scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 110, 100, 10)];
    pageControl.numberOfPages = self.imageArray .count;
    [pageControl addTarget:self action:@selector(changeCurrentView) forControlEvents:UIControlEventValueChanged];
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    
    //        CADisplayLink * gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(viewChange)];
    //        gameTimer.frameInterval = 3;
    //        [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(viewChange) userInfo:nil repeats:YES];
}

-(void)changeCurrentView
{
    int pageNumber = (int)_pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(pageNumber * SCREEN_WIDTH, 0) animated:YES];
    //[_scrollView setContentOffset:CGPointMake(pageNumber * 320, 0)];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int number = _scrollView.contentOffset.x/SCREEN_WIDTH;
    _pageControl.currentPage = number;
}
-(void)viewChange
{
    int pageNumber = (int)_pageControl.currentPage;
    pageNumber ++;
    pageNumber = pageNumber > (_imageArray.count - 1)  ? 0 : pageNumber;
    _pageControl.currentPage = pageNumber;
    [self changeCurrentView];
}
@end
