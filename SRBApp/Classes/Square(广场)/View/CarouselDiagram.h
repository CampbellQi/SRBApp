//
//  CarouselDiagram.h
//  CoolCar
//
//  Created by winter on 14-10-19.
//  Copyright (c) 2014年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselDiagram : UIView<UIScrollViewDelegate>

@property (nonatomic,retain)NSMutableArray *imageArray ;
@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,retain)UIPageControl *pageControl;

-(id)initWithFrame:(CGRect)frame
          andimgArray:(NSMutableArray *)imgArray;
- (void)start;
@end
