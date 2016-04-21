//
//  HomeTopicListHeaderView2.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/29.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#define TOOLBAR_HEIGHT 110

#import "HomeTopicHeaderView.h"
#import "PageScrollView.h"

@interface HomeTopicHeaderView()<PageScrollViewDelegate>
{
    NSArray *_carouselArray;
}
@end

@implementation HomeTopicHeaderView

-(id)initWithFrame:(CGRect)frame CarouselArray:(NSArray *)carouselArray ToolbarArray:(NSArray *)toolbarArray{
    if (self = [super initWithFrame:frame]) {
        if (carouselArray) {
            //轮播图
            _carouselArray = carouselArray;
            NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
            PageScrollView *pageScroll=[[PageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CAROUSEL_HEIGHT)];
            NSLog(@"%@", NSStringFromCGSize(pageScroll.frame.size));
            for (int i=0; i<carouselArray.count; i++) {
                NSDictionary *dict = carouselArray[i];
                UIImageView *iv=[[UIImageView alloc] init];
                //iv.image = [UIImage imageNamed:dict[@"cover"]];
                [iv sd_setImageWithURL:[NSURL URLWithString:dict[@"cover"]] placeholderImage:[UIImage imageNamed:@"hometopic_carsouel_wutu"]];
                [viewsArray addObject:iv];
                
                [iv addTapAction:@selector(linkTap:) forTarget:self];
                iv.tag = 100 + i;
            }
            
            pageScroll.autoScrollDelayTime=3.0;
            pageScroll.delegate=self;
            pageScroll.dataSource = [NSMutableArray arrayWithArray:carouselArray];
            //pageScroll.pageViewClickedBlock = homeServiceItemClickedBlock;
            [pageScroll setViewsArray:viewsArray];
            [pageScroll shouldAutoShow:YES];
            [self addSubview:pageScroll];
            self.totalHeight += pageScroll.height;
        }
    }
    if (toolbarArray) {
        //操作栏
        UIScrollView *toolbarSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.totalHeight, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        float toolbarWidth = CGRectGetWidth(frame) / 4;
        //toolbarSV.contentSize = CGSizeMake(toolbarArray.count * toolbarWidth, 0);
        for (int i=0; i<toolbarArray.count; i++) {
            NSDictionary *dict = toolbarArray[i];
            UIView *view = [self getToolbarViewWithDict:dict Frame:CGRectMake(i * toolbarWidth, 0, toolbarWidth, CGRectGetHeight(toolbarSV.frame))];
            [toolbarSV addSubview:view];
        }
        [self addSubview:toolbarSV];
        //底部线
        UIImageView *lineIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(toolbarSV.frame)-1, CGRectGetWidth(toolbarSV.frame), 1)];
        lineIV.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
        [toolbarSV addSubview:lineIV];
        self.totalHeight += toolbarSV.height;
    }
    return self;
}
//初始化操作栏单个view
-(UIView *)getToolbarViewWithDict:(NSDictionary *)dict Frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    //图片
    float ivMargin = 20;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(ivMargin, ivMargin, CGRectGetWidth(frame) - 2*ivMargin,  CGRectGetWidth(frame) - 2*ivMargin)];
    [iv sd_setImageWithURL:[NSURL URLWithString:dict[@"cover"]]];;
    [view addSubview:iv];
    
    //文字
    float lblHeight = 40;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - lblHeight, CGRectGetWidth(frame), lblHeight)];
    lbl.text = dict[@"note"];
    [view addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:14.0];
    //view.backgroundColor = [UIColor redColor];
    return view;
}
-(void)linkTap:(UIGestureRecognizer *)gr {
    UIView *view = gr.view;
    long tag = view.tag - 100;
    NSDictionary *dict = _carouselArray[tag];
    NSString *url = dict[@"url"];
    
    NSArray *tempArray = @[@"position", @"usertopic", @"userpost", @"tagindex"];
    for (NSString *str in tempArray) {
        if ([url containsString:str]) {
            NSString *ID = [url substringFromIndex:[url rangeOfString:str].location + str.length + 1];
            if (self.carouselIVTap) {
                self.carouselIVTap((int)[tempArray indexOfObject:str], ID);
            }
            break;
        }
    }
}
@end
