//
//  WQScrollView.h
//  DocumentaryChina
//
//  Created by fengwanqi on 14-7-24.
//  Copyright (c) 2014年 com.uwny. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageScrollView;
@protocol PageScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(PageScrollView *)view atIndex:(NSInteger)index;

@end

typedef void (^PageViewClickedBlock) (UIViewController *vc);

@interface PageScrollView : UIView<UIScrollViewDelegate>
{
    UIView *firstView;
    UIView *middleView;
    UIView *lastView;
    
    UIGestureRecognizer     *tap;
    __unsafe_unretained id <PageScrollViewDelegate>  _delegate;
    NSTimer         *autoScrollTimer;
}
@property (nonatomic,copy)PageViewClickedBlock pageViewClickedBlock;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,readonly)    UIScrollView *scrollView;
@property (nonatomic,readonly)  UIPageControl *pageControl;
@property (nonatomic,assign)    NSInteger currentPage;
@property (nonatomic,strong)    NSMutableArray *viewsArray;
@property (nonatomic,assign)    NSTimeInterval    autoScrollDelayTime;

@property (nonatomic,assign) id<PageScrollViewDelegate> delegate;


-(void)shouldAutoShow:(BOOL)shouldStart;//自动滚动，界面不在的时候请调用这个停止timer

@end

