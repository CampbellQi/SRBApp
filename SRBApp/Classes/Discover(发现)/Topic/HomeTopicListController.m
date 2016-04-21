//
//  GoodsOrderListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//


#define HEADERVIEW_HEIGHT CAROUSEL_HEIGHT + CELL_HEIGHT + 23 + 10
#define HEADERSECTIONVIEW_HEIGHT 119

#import "HomeTopicListController.h"

#import "HomeTopicListHeaderView.h"
#import "HomeTopicListHotMarkView.h"
#import "GoodsMarkListController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DailyTopicListController.h"
#import "PublishTopicController.h"
#import "RunViewController2.h"
#import "WQGuideView.h"
#import "LocationDetailViewController.h"
#import "MessageCenterToSubClassViewController.h"
#import "MarkTopicListController.h"

@class AppDelegate;
@interface HomeTopicListController ()
{
    //轮播图
    NSArray *_carsouselArray;
    //每日话题
    BussinessModel *_dailyTopicBussinessModel;
    //标签列表
    NSMutableArray *_markArray;
    BOOL _isNavBarHidden;
    
    UIButton *toTopBtn;                 //返回顶部
    
}

@end

@implementation HomeTopicListController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    
    if (dic == nil) {
        NSDictionary * versionDic = [[NSBundle mainBundle] infoDictionary];
        dic = [NSMutableDictionary dictionary];
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        [dic setObject:[versionDic objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    }else{
        
        NSString * oldYear = [dic objectForKey:@"year"];
        NSString * oldMonth = [dic objectForKey:@"month"];
        NSString * oldDay = [dic objectForKey:@"day"];
        
        NSDate *  senddate=[NSDate date];
        NSCalendar  * cal=[NSCalendar  currentCalendar];
        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
        
        NSString * year = [NSString stringWithFormat:@"%ld",(long)[conponent year]];
        NSString * month = [NSString stringWithFormat:@"%ld",(long)[conponent month]];
        NSString * day = [NSString stringWithFormat:@"%ld",(long)[conponent day]];
        
        [dic setObject:year forKey:@"year"];
        [dic setObject:month forKey:@"month"];
        [dic setObject:day forKey:@"day"];
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
        //将登录状态写入配置文件
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        if (([year intValue] - [oldYear intValue]) * 365 + ([month intValue] - [oldMonth intValue])* 30 + [day intValue] - [oldDay intValue] > 7 && oldYear > 0) {
            [AutoDismissAlert autoDismissAlert:@"账号已过期,请重新登录!"];
            [dic setObject:@"0" forKey:@"isLogin"];
            [dic writeToFile:USER_CONFIG_PATH atomically:YES];
            [self presentViewController:loginNC animated:NO completion:nil];
            //                [self setNoLoginState];
        }else{
            if ([[dic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
                //显示引导页
                [[WQGuideView share] showAtIndex:0 GuideViewRemoveBlock:nil];
            }else{
                //                    [self setNoLoginState];
                [self presentViewController:loginNC animated:NO completion:nil];
            }
        }
    }
    
//    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
//    if ([dataDic objectForKey:@"shopping"]== nil) {
//        [dataDic setObject:@"1" forKey:@"shopping"];
//        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
//        static dispatch_once_t token;
//        dispatch_once(&token, ^{
//            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(seeFinished) userInfo:nil repeats:YES];
//        });
//        
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发 现";
    _isNavBarHidden = NO;
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(publishClicked)];
    // Do any additional setup after loading the view from its nib.
    //设置向上按钮
    [self toTop];
    
    //self.tableView.sectionHeaderHeight = HEADERVIEW_HEIGHT;
    //用户登录成功发出通知加载数据
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(headerBeginRefreshing) name:@"reloadVC" object:nil];
    //判断用户是否登录
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    
    if (dic != nil) {
        [self.tableView headerBeginRefreshing];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isNavBarHidden) {
        [self huanYuan];
    }
    

}
#pragma mark- 页面
//返回顶部
- (void)toTop
{
    toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, MAIN_NAV_HEIGHT - 49 - 60, 45, 45);
    //    toTopBtn.backgroundColor = [UIColor redColor];
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    toTopBtn.hidden = YES;
    [self.view addSubview:toTopBtn];
    [self.view bringSubviewToFront:toTopBtn];
}
-(void)addTableHeaderView {
    HomeTopicListHeaderView *header = [[HomeTopicListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) CarouselArray:_carsouselArray BussinessModel:_dailyTopicBussinessModel MarksArray:_markArray];
    //标签点击
    __block typeof(self) unself = self;
    header.cv.tagClickedBlock = ^(NSString *aTag) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = aTag;
        [unself.navigationController pushViewController:vc animated:YES];
    };
    //热门标签
    [header.markView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMarkListController)]];
    //[view.topicMoreBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTopicListController)]];
    header.markView.markViewTapBlock = ^(NSDictionary *dataDict) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = dataDict[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    //头像点击
    header.cv.avaterClickedBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [unself.navigationController pushViewController:personVC animated:YES];
    };
    header.carouselIVTap = ^(enum CarsouselType carsouselType, NSString *ID) {
        switch (carsouselType) {
            case Topic:
            {
                //话题
                TopicDetailListController *detail = [[TopicDetailListController alloc] init];
                detail.modelId = ID;
                [self.navigationController pushViewController:detail animated:YES];
                break;
            }
            case Position:
            {
                //足迹详情
                LocationDetailViewController * vc = [[LocationDetailViewController alloc]init];
                vc.ID = ID;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case Userpost:
            {
                //商品详情
                MessageCenterToSubClassViewController * sellerManagementVC = [[MessageCenterToSubClassViewController alloc]init];
                sellerManagementVC.idNumber = ID;
                [self.navigationController pushViewController:sellerManagementVC animated:YES];
                break;
            }
            case Tagindex:
            {
                //标签列表
                MarkTopicListController * vc = [[MarkTopicListController alloc]init];
                vc.tagName = ID;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    };
    header.height = header.totalHeight;
    
    [header.dailyTopicMoreView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goDailyTopicListVC)]];
    header.cv.coverIV.userInteractionEnabled = YES;
    [header.cv.coverIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTopicDetailVC)]];
    self.tableView.tableHeaderView = header;
}
#pragma mark- 事件
- (void)clickToTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self huanYuan];
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                          //atScrollPosition:UITableViewScrollPositionTop
                                 // animated:YES];
}
-(void)publishClicked {
    RunViewController2 *run2 = [[RunViewController2 alloc] init];
    //PublishTopicController *publish = [[PublishTopicController alloc] init];
    [self.navigationController pushViewController:run2 animated:YES];
}
#pragma mark- 跳转
//标签话题列表
-(void)goMarkListController {
    GoodsMarkListController *goodsMarkVC = [[GoodsMarkListController alloc] init];
    
    [self.navigationController pushViewController:goodsMarkVC animated:YES];
}
//更多每日话题
-(void)goDailyTopicListVC {
    DailyTopicListController *daily = [[DailyTopicListController alloc] initWithService];
    [self.navigationController pushViewController:daily animated:YES];
}
//话题详情
-(void)goTopicDetailVC {
    TopicDetailListController *detail = [[TopicDetailListController alloc] init];
    detail.backBlock = ^(void) {
        //重新设置点赞数量
        [self addTableHeaderView];
    };
    detail.sourceModel = _dailyTopicBussinessModel;
    [self.navigationController pushViewController:detail animated:YES];
}
//更多用户话题
-(void)goTopicListController {
    DailyTopicListController *daily = [[DailyTopicListController alloc] initWithUsers];
    [self.navigationController pushViewController:daily animated:YES];
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_markArray) {
//        return 2;
//    }
//    return 1;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (_markArray && section == 1) {
//        HomeTopicListHotMarkView *view = [[HomeTopicListHotMarkView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84) MarksArray:_markArray];
//        [view.markMoreBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMarkListController)]];
//        //[view.topicMoreBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTopicListController)]];
//        view.markViewTapBlock = ^(NSDictionary *dataDict) {
//            MarkTopicListController *vc = [[MarkTopicListController alloc] init];
//            vc.tagName = dataDict[@"name"];
//            [self.navigationController pushViewController:vc animated:YES];
//        };
//        return view;
//    }else {
//        return [UIView new];
//    }
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (_markArray && section == 1) {
//        return HEADERSECTIONVIEW_HEIGHT;
//    }else {
//        return 1;
//    }
//    
//}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        _isNavBarHidden = YES;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);

        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        AppDelegate * app = APPDELEGATE;
        [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    }else if(velocity.y < 0){
        [self huanYuan];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        toTopBtn.hidden = YES;
    }
    
    {
        CGFloat sectionHeaderHeight = 120;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }  
    }
}


- (void)huanYuan
{
    _isNavBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 49);

    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
#pragma mark- 网络请求
//下拉刷新获取数据
- (void)loadNewDataListRequest
{
    if (ACCOUNT_SELF == nil || PASSWORD_SELF == nil) {
        return;
    }
    
    [self loadCarouselRequest];
    
}
//轮播图
- (void)loadCarouselRequest
{
    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _carsouselArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        }
        [self loadDailyTopicRequest];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//每日话题
- (void)loadDailyTopicRequest {
    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":@"250", @"start":@"0", @"count":@"1"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            if (temparrs.count > 0) {
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:temparrs[0]];
                _dailyTopicBussinessModel = bussinessModel;
                
                
            }
            
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
        [self loadTagListRequest];
    } andFailureBlock:^{

    }];
}
//标签
- (void)loadTagListRequest {
    NSDictionary * dic = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"10", @"categoryID": @"0"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _markArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            
        }
        //标签加载完成再刷新数据
        [self addTableHeaderView];
        [self loadTopicNewDataListRequest];
    } andFailureBlock:^{
        
    }];
}
//最新话题列表
-(void)loadTopicNewDataListRequest {
    page = 0;
    NSDictionary * param = [self parametersForDic:@"getPostListByCollectedTags" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":@"251",@"order": @"best", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    page += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"getPostListByCollectedTags" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":@"251",@"order": @"best", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
}
//点赞
-(void)praiseRequest:(BussinessModel *)model {
    NSString *url = @"accountLikePost";
    if ([model.isLike isEqualToString:@"1"]) {
        //已经点过赞，取消点赞
        url = @"accountDeleteLikedPost";
    }
    NSDictionary * param = [self parametersForDic:url parameters:@{ACCOUNT_PASSWORD,@"id":model.model_id}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            if ([model.isLike isEqualToString:@"1"]) {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] > 0 ? [model.likeCount intValue] - 1 : 0];
                
            }else {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] + 1];
            }
            
            if (model == _dailyTopicBussinessModel) {
                HomeTopicListHeaderView *header = (HomeTopicListHeaderView *)self.tableView.tableHeaderView;
                header.sourceModel = model;
            }else {
                [self.tableView reloadData];
            }
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
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
