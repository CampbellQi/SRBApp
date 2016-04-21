//
//  WQNavSliderScrollView.h
//  DocumentaryChina
//
//  Created by fengwanqi on 14-7-24.
//  Copyright (c) 2014年 com.uwny. All rights reserved.
//
typedef void (^SlideBtnClickedBlock) (id sender);

@protocol SliderScrollViewDelegate <NSObject>

-(UIView *)getShowItemViewWithIndex:(int)index;

@end
#import <UIKit/UIKit.h>

@interface MineFragmentSliderScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic,copy)SlideBtnClickedBlock slideBtnClickedBlock;

@property (nonatomic, strong)NSMutableArray *contentViewArray;
@property (nonatomic, strong)UIView *currentView;
@property (nonatomic ,assign)id <SliderScrollViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame TitlesArray:(NSArray *)titlesArray FirstView:(UIView *)firstView;

-(void)scrollToIndex:(int)index;

@end
