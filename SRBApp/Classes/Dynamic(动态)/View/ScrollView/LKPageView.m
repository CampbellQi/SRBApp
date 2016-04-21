//
//  MyPageView.m
//  Love7Ke
//
//  Created by mac on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LKPageView.h"
//#import "UIImageView+WebCache.h" 用到SDWebImage 
#import "LKViewUtils.h"
@interface LKPageView ()

@end

@implementation LKPageView
@synthesize page_scroll;
@synthesize page_control;
@synthesize width;
@synthesize count;
@synthesize dataSource;
@synthesize m_action;
@synthesize m_object;
-(id)initWithURLStringArray:(NSArray *)array andFrame:(CGRect)newframe
{
    self = [self initWithFrame:newframe];
    if(self)
    {
        pageType = MyPageTypeUrlImage;
        _frame = newframe;
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction)  userInfo:nil repeats:YES];
        isPageTouched = NO;
        self.dataSource = array;
        
        [self loadView];
    }
    return self;    
}
-(id)initWithPathStringArray:(NSArray *)array andFrame:(CGRect)newframe
{
     self = [self initWithFrame:newframe];
    if(self)
    {
        pageType = MyPageTypePath;
        _frame = newframe;
        //计时器
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction)  userInfo:nil repeats:YES];
        isPageTouched = NO;
        self.dataSource = array;
        
                [self loadView];
    }
    return self;    
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        scrollView.showsHorizontalScrollIndicator =NO;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        self.page_scroll = scrollView;
        [scrollView release];
        
        UIPageControl* pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,frame.size.height - 36,frame.size.width,36)];
        [self addSubview:pageControl];
        self.page_control = pageControl;
        [pageControl release];
    }
    return self;
}
-(id)initWithViewArray:(NSArray *)array andFrame:(CGRect)newframe
{
    self = [self initWithFrame:newframe];
    if(self)
    {
        pageType = MyPageTypeView;
        _frame = newframe;
        self.dataSource = array;
        
        [self loadView];
    }
    return self;    
}
-(void)loadView
{
    if(dataSource != nil)
    {
        switch (pageType) {
            case MyPageTypeUrlImage:
            {
                [self updateWithURLStringArray:dataSource];
            }
                break;
            case MyPageTypePath:
            {
                [self updateWithPathStringArray:dataSource];
            }
                break;
            case MyPageTypeView:
            {
                [self updateWithViewArray:dataSource];
            }
                break;
        }
        
    }
    page_scroll.delegate = self;
    [self startPlay];
}
#pragma mark -
#pragma mark 绑定数据 
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if(m_object != nil)
    {
         NSNumber* index = [NSNumber numberWithInt:sender.view.tag];
        [m_object performSelector:m_action withObject:index];
    }
}
-(void)updateWithPathStringArray:(NSArray*)array
{
    [self updateWithStringArray:array andType:NO];
}
-(void)updateWithURLStringArray:(NSArray *)array
{
    [self updateWithStringArray:array andType:YES];
}
- (void)setImageView:(UIImageView *)imageview info:(NSString *)str isUrl:(BOOL)isUrl
{
    if(isUrl)
    {
        //如果传进来的是URL 就调用 SDWebImage   有需要的同学可以自己把SDWebImage 包含进来 
//        [imageview setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"loading.png"]];
    }
    else {
        imageview.image = [UIImage imageNamed:str];
    }
}

-(void)updateWithStringArray:(NSArray*)array andType:(BOOL)isUrl
{
    count = array.count;
    page_control.numberOfPages = count;
    width = _frame.size.width;
    int height = _frame.size.height;
    
    UIImageView* firstImageView = nil,*lastImageView = nil;
   
    for (int i=0;i<count;i++) {
        
        NSString* str = [array objectAtIndex:i];
        UIImageView* imageview = [[UIImageView alloc] init];
        imageview.userInteractionEnabled = YES;

        [self addTapEvent:imageview];
        
        imageview.frame = CGRectMake((i+1)*width, 0, width, height);
        [self setImageView:imageview info:str isUrl:isUrl];
        
        imageview.tag = i;
        [page_scroll addSubview:imageview];
        [imageview release];  
        
        if(i==0)
        {
            firstImageView = [[UIImageView alloc] init];
            firstImageView.userInteractionEnabled = YES;

            [self setImageView:firstImageView info:str isUrl:isUrl];
            firstImageView.tag = 0;
            
            [self addTapEvent:firstImageView];
        }
        else if(i==count -1)
        {
            lastImageView =  [[UIImageView alloc] init];
            lastImageView.userInteractionEnabled = YES;
            [self setImageView:lastImageView info:str isUrl:isUrl];
            lastImageView.tag = count -1;
            
            [self addTapEvent:lastImageView];
        }
          
    }
    firstImageView.frame = CGRectMake((count+1)*width, 0, width, height);
    [page_scroll addSubview:firstImageView];
    [firstImageView release];
    
    lastImageView.frame = CGRectMake(0, 0, width, height);
    [page_scroll addSubview:lastImageView];
    [lastImageView release];
    
    
    self.frame = _frame;
    page_scroll.contentSize  = CGSizeMake((count + 2)*width,height);
    page_scroll.contentOffset  = CGPointMake(width, 0);
    self.dataSource = array;
    
    //    [self performSelector:@selector(nextPage) withObject:nil afterDelay:3];
}
-(void)addTapEvent:(UIView*)view
{
    UITapGestureRecognizer* tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:tapClick];
    [tapClick release];
}
-(void)updateWithViewArray:(NSArray *)array
{
    count = array.count;
    page_control.numberOfPages = count;
    width = _frame.size.width;
    int height = _frame.size.height;
    
    UIImageView* firstView,*lastView;
    
    for (int i=0;i<count;i++) {
        
        UIView* view = [array objectAtIndex:i];
        view.userInteractionEnabled = YES;
        view.frame = CGRectMake((i+1)*width, 0, width, height);
        view.tag = i;
        [page_scroll addSubview:view];
        [self addTapEvent:view];
        if(i==0)
        {
            firstView = [[UIImageView alloc] initWithImage:[LKViewUtils getImageFromView:view]];
        }
        if(i==count -1)
        {
            lastView = [[UIImageView alloc] initWithImage:[LKViewUtils getImageFromView:view]];
        }  
    }
    firstView.frame = CGRectMake((count+1)*width, 0, width, height);
    [page_scroll addSubview:firstView];
    [firstView release];
    
    lastView.frame = CGRectMake(0, 0, width, height);
    [page_scroll addSubview:lastView];
    [lastView release];
    
    self.frame = _frame;
    page_scroll.contentSize  = CGSizeMake((count + 2)*width,height);
    page_scroll.contentOffset  = CGPointMake(width, 0);
    self.dataSource = array;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _frame = frame;
    width = frame.size.width; 
}
-(CGRect)frame
{
    return _frame;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark-
#pragma mark 事件
-(void)setPressedEvent:(id)object action:(SEL)action
{
    self.m_object = object;
    self.m_action = action;
}
#pragma mark-
#pragma mark 轮播效果
-(int)currentIndex
{
    return page_control.currentPage;
}
-(void)setCurrentIndex:(int)currentIndex
{
    page_control.currentPage = currentIndex;
}
-(void)nextPage
{
    int pageindex = page_control.currentPage + 2;
    int offsetX =  pageindex* width;
    [page_scroll setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    if(pageindex == count + 1)
    {
        pageindex  = 1;
        [self performSelector:@selector(page_scrolltofirst) withObject:nil afterDelay:0.5];
    }
    if(pageindex == 0)
    {
        pageindex = count;
        [self performSelector:@selector(page_scrolltolast) withObject:nil afterDelay:0.5];
    }
    page_control.currentPage = pageindex-1;
}

- (IBAction)page_changed:(UIPageControl *)sender {
    
    NSLog(@"pagechanged");
    int offsetX =  (sender.currentPage + 1) * width;
    [page_scroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    //    if(sender.currentPage == count + 1)
    //    {
    //        sender.currentPage = 1;
    //        [self performSelector:@selector(page_scrolltofirst) withObject:nil afterDelay:0.2];
    //    }
    //    if(offsetX == 0)
    //    {
    //        sender.currentPage = count;
    //        [self performSelector:@selector(page_scrolltolast) withObject:nil afterDelay:0.2];
    //    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollchanged");
    int offsetX = scrollView.contentOffset.x;
    int pageindex = offsetX / width;
    if(pageindex == count + 1)
    {
        pageindex  = 1;
        [self performSelector:@selector(page_scrolltofirst) withObject:nil afterDelay:0.2];
    }
    if(pageindex == 0)
    {
        pageindex = count;
        [self performSelector:@selector(page_scrolltolast) withObject:nil afterDelay:0.2];
    }
    page_control.currentPage = pageindex -1;
    isPageTouched = YES;
}
-(void) page_scrolltofirst
{
    [page_scroll setContentOffset:CGPointMake(width, 0)];
}
-(void)page_scrolltolast
{
    [page_scroll setContentOffset:CGPointMake(count*width, 0)];
}
-(void)startPlay
{
    [timer fire];
}
-(void)endPlay
{
    [timer invalidate];
}
-(void)timerAction
{
    if(isPageTouched)
    {
        isPageTouched = NO;
    }
    else {
        [self nextPage];        
    }
}

#pragma mark-
#pragma mark dealloc
- (void)dealloc {
    [m_object release];
    [page_scroll release];
    [page_control release];
    [dataSource release];
    dataSource = nil;
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
    [super dealloc];
    NSLog(@"page view released");
}
//- (void)viewDidUnload
//{
//    [self setPage_scroll:nil];
//    [self setPage_control:nil];
//    [self setDataSource:nil];
//    [self setM_action:nil];
//    [self setM_object:nil];
//    if(timer != nil)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
@end
