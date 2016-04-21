//
//  MyPageView.h
//  Love7Ke
//
//  Created by mac on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    MyPageTypeUrlImage =0,
    MyPageTypePath,
    MyPageTypeView
}MyPageViewType;

@interface LKPageView : UIView<UIScrollViewDelegate>
{
    CGRect _frame;
    NSTimer* timer;
    BOOL isPageTouched;
    MyPageViewType pageType;
}
-(id)initWithURLStringArray:(NSArray*)array andFrame:(CGRect)newframe; //可以传网络上的URL地址 需要SDWebImage
-(id)initWithViewArray:(NSArray*)array andFrame:(CGRect)newframe;       //直接传UIView 数组进来
-(id)initWithPathStringArray:(NSArray*)array andFrame:(CGRect)newframe; //图片的绝对地址

-(void)setPressedEvent:(id)object action:(SEL)action; //点击事件   -(void)method:(int)clickIndex;
@property(retain,nonatomic) id m_object;
@property SEL m_action;
//更改数据源
-(void)updateWithURLStringArray:(NSArray*)array;
@property (retain, nonatomic) IBOutlet UIScrollView *page_scroll;
@property (retain, nonatomic) IBOutlet UIPageControl *page_control;
- (IBAction)page_changed:(UIPageControl *)sender;
//获取加载时的宽度 如果后面改变了大小 要手动赋值
@property int width;
//图片数量
@property int count;
//当前索引
@property int currentIndex;
//数据源
@property(retain,nonatomic)NSArray* dataSource;
@property CGRect frame;
-(void) startPlay; //开始自动滚动
-(void)endPlay;   //停止自动滚动
@end
