//
//  HomeTopicMainController.m
//  SRBApp
//  首页
//  Created by fengwanqi on 16/1/29.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "HomeTopicMainController.h"
#import "HomeTopicHeaderView.h"
#import "HomeNavSliderScrollView.h"
#import "HomeTopicListController2.h"

@interface HomeTopicMainController ()<NavSliderScrollViewDelegate, HomeTopicListController2Delegate>
{
    NSArray *_carouselArray;
    NSArray *_toolbarArray;
    NSArray *_titleArray;
    UIScrollView *_mainSV;
    HomeTopicHeaderView *_headerView;
}
@end

@implementation HomeTopicMainController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    
    [self loadCarouselRequest];
}
#pragma mark- 页面
-(void)setUpView {
    UIScrollView *mainSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    [self.view addSubview:mainSV];
    _mainSV = mainSV;
    _mainSV.bounces = NO;
    _mainSV.alwaysBounceVertical = NO;
    _mainSV.showsVerticalScrollIndicator = NO;
}
-(void)setUpHeaderView {
    //页头
    HomeTopicHeaderView *headerView = [[HomeTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10) CarouselArray:_carouselArray ToolbarArray:_toolbarArray];
    headerView.height = headerView.totalHeight;
    [_mainSV addSubview:headerView];
    _mainSV.contentSize = CGSizeMake(0, MAIN_NAV_HEIGHT + headerView.totalHeight +20);
    _headerView = headerView;
}
-(void)setUpNavView {
    //主页
    HomeNavSliderScrollView *navView = [[HomeNavSliderScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), SCREEN_WIDTH, _mainSV.contentSize.height - CGRectGetMaxY(_headerView.frame)) TitlesArray:_titleArray FirstView:[self getShowItemViewWithIndex:0]];
    navView.navSliderScrollViewDelegate = self;
    //navView.backgroundColor = [UIColor redColor];
    [_mainSV addSubview:navView];
}
#pragma mark- scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
#pragma mark-  NavSliderScrollViewDelegate method
-(UIView *)getShowItemViewWithIndex:(int)index {
    HomeTopicListController2 *vc = [[HomeTopicListController2 alloc] init];
    vc.categoryID = _titleArray[index][@"categoryID"];
    vc.delegate = self;
    [self addChildViewController:vc];
    return vc.view;
}
#pragma mark-  HomeTopicListController2 method
-(void)scrollWithContentOffset:(CGPoint)contentOffset {
//    NSLog(@"%@", NSStringFromCGPoint(contentOffset));
//    if (contentOffset.y > 0) {
//        if (_mainSV.contentOffset.y < CGRectGetHeight(_headerView.frame)) {
//            [_mainSV setContentOffset:CGPointMake(0, contentOffset.y)];
//        }
//    }else {
//        //if (_mainSV.contentOffset.y > 0) {
//            [_mainSV setContentOffset:CGPointMake(0, contentOffset.y)];
//        //}
//    }
    
}
#pragma mark- 网络请求
//轮播图
- (void)loadCarouselRequest
{
    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _carouselArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        }
        [self loadToolbarRequest];
    } andFailureBlock:^{
        
    }];
    
}
//标签分类
- (void)loadToolbarRequest
{
    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"4", @"id": @"20"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _toolbarArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [self setUpHeaderView];
        }
        [self loadTopicTitleRequest];
    } andFailureBlock:^{
        
    }];
}
//话题分类标题
- (void)loadTopicTitleRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"1047"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _titleArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [self setUpNavView];
        }
        
    } andFailureBlock:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
