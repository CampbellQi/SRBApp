//
//  GoodsOrderHeaderView.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "HomeTopicListHeaderView.h"
#import "LayoutFrame.h"

@interface HomeTopicListHeaderView()
{
    NSArray *_carouselArray;
}
@end
@implementation HomeTopicListHeaderView
//-(id)initWithFrame:(CGRect)frame CarouselArray:(NSArray *)carouselArray{
//    if (self = [super initWithFrame:frame]) {
//        self.topView = [[[NSBundle mainBundle] loadNibNamed:@"HomeTopicListHeaderView" owner:self options:nil] objectAtIndex:0];
//        self.topView.frame = self.bounds;
//        [self addSubview:self.topView];
//        self.clipsToBounds = YES;
//        self.topView.clipsToBounds = YES;
//        //话题
//        TopicListCell *cv = [[[NSBundle mainBundle] loadNibNamed:@"TopicListCell" owner:self options:nil] objectAtIndex:0];
//        //cv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 402 + SCREEN_WIDTH / 320.0 * 228  - 228);
//        [self.topicTopView addSubview:cv];
//        self.cv = cv;
//        //cv.bussinessModel = dailyTopicModel;
//        cv.commentBtn.hidden = NO;
//        cv.praiseBtn.hidden = NO;
//        cv.contentView.backgroundColor = [UIColor whiteColor];
//        //轮播图
//        NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
//        PageScrollView *pageScroll=[[PageScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CAROUSEL_HEIGHT)];
//        NSLog(@"%@", NSStringFromCGSize(pageScroll.frame.size));
//        for (NSDictionary *dict in carouselArray) {
//            UIImageView *iv=[[UIImageView alloc] init];
//            //iv.image = [UIImage imageNamed:dict[@"cover"]];
//            [iv sd_setImageWithURL:[NSURL URLWithString:dict[@"cover"]] placeholderImage:[UIImage imageNamed:@"hometopic_carsouel_wutu"]];
//            //iv sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>
//            //        [iv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"cover"]] placeholderImage:Placeholder_Image imagesize:pageScroll.frame.size];
//            [viewsArray addObject:iv];
//        }
//        pageScroll.autoScrollDelayTime=3.0;
//        pageScroll.delegate=self;
//        pageScroll.dataSource = [NSMutableArray arrayWithArray:carouselArray];
//        //pageScroll.pageViewClickedBlock = homeServiceItemClickedBlock;
//        [pageScroll setViewsArray:viewsArray];
//        [_carouselTopView addSubview:pageScroll];
//        [pageScroll shouldAutoShow:YES];
//        _pageScrollView = pageScroll;
//    }
//    return self;
//}
//-(void)setSourceModel:(BussinessModel *)sourceModel {
//    _sourceModel = sourceModel;
//    _cv.bussinessModel = _sourceModel;
//    self.cv.frame = self.topicTopView.bounds;
//    [LayoutFrame showViewConstraint:self.cv.coverIV AttributeHeight:SCREEN_WIDTH / 320.0 * 228];
//}
-(void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    //self.cv.frame = self.topicTopView.bounds;
    [LayoutFrame showViewConstraint:self.cv.coverIV AttributeHeight:SCREEN_WIDTH / 320.0 * 228];
    [LayoutFrame showViewConstraint:_cv.markView AttributeHeight:[_cv.markView fittedSize].height];
}
-(id)initWithFrame:(CGRect)frame CarouselArray:(NSArray *)carouselArray BussinessModel:(BussinessModel *)bussinessModel MarksArray:(NSArray *)marksArray{
    if (self = [super initWithFrame:frame]) {
        _carouselArray = carouselArray;
        
        self.clipsToBounds = YES;
        self.totalHeight = 0.0;
        
        if (_carouselArray) {
            //轮播图
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
                //            for (int i=0; i<viewsArray.count; i++){
                //                iv.tag = 100 + i;
                //                 NSString *urlStr = [NSURL URLWithString:dict[@"cover"]].absoluteString;
                //                if ([urlStr rangeOfString:@"http://"].location != NSNotFound) {
                //                    NSLog(@"Yes");
                //                    //[iv addTapAction:@selector(linkTap:) forTarget:self];
                //                }else if([urlStr rangeOfString:@"srbapp://"].location != NSNotFound){
                //                //[iv addTapAction:@selector(linkTap:) forTarget:self];
                //                    if ([urlStr rangeOfString:@"usertopic"].location != NSNotFound) {
                //
                //                    }
                //
                //            }
                //            }
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
        
        if (bussinessModel) {
            //更多
            TopicMoreView *moreView = [[[NSBundle mainBundle] loadNibNamed:@"TopicMoreView" owner:self options:nil] objectAtIndex:0];
            moreView.frame = CGRectMake(0, self.totalHeight, SCREEN_WIDTH, 30);
            //TopicMoreView *moreView = [[TopicMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageScroll.frame), SCREEN_WIDTH, 23)];
            [self addSubview:moreView];
            self.totalHeight += moreView.height;
            self.dailyTopicMoreView = moreView;
            [moreView layoutIfNeeded];
            
            //话题
            TopicListCell *cv = [[[NSBundle mainBundle] loadNibNamed:@"TopicListCell" owner:self options:nil] lastObject];
            self.cv = cv;
            cv.bussinessModel = bussinessModel;
            //cv.bussinessModel = dailyTopicModel;
            cv.commentBtn.hidden = NO;
            cv.praiseBtn.hidden = NO;
            cv.lineIV.hidden = YES;
            cv.contentView.backgroundColor = [UIColor whiteColor];
            float markViewHeight = cv.markView.height;
            cv.frame = CGRectMake(0, CGRectGetMaxY(moreView.frame), SCREEN_WIDTH, CELL_HEIGHT + [cv.markView fittedSize].height - markViewHeight);
            [self addSubview:cv];
            [cv showMarksView];
            self.totalHeight += cv.height;
        }
        
        if (marksArray) {
            //标签
            HomeTopicListHotMarkView *markView = [[HomeTopicListHotMarkView alloc] initWithFrame:CGRectMake(0, self.totalHeight, SCREEN_WIDTH, 120) MarksArray:marksArray];
            self.markView = markView;
            [self addSubview:markView];
            self.totalHeight += CGRectGetHeight(markView.frame);
        }
        
    }
    return self;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
