//
//  SPListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SPListController.h"
#import "SPScreeningListController.h"
#import "AppDelegate.h"
#import "NSString+CalculateSize.h"
#import "LayoutFrame.h"
#import "LoginViewController.h"
#import "WQGuideView.h"

#define SELECTED_COLOR [UIColor colorWithRed:199/255.0 green:0.0 blue:72/255.0 alpha:1]
#define NORMAL_COLOR [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]

@interface SPListController ()
{
    SPScreeningListController *_sp;
    NSDictionary *_param;
    
    NSString *_priceDesc;
    NSString *_minPrice;
    NSString *_maxPrice;
    NSString *_shopLand;
    
    UIButton *toTopBtn;
    
    BOOL _isNavBarHidden;
}
@end

@implementation SPListController
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
            }else{
                //                    [self setNoLoginState];
                [self presentViewController:loginNC animated:NO completion:nil];
            }
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //用户登录成功发出通知加载数据
    self.title = @"求 购";
    
    _isNavBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(headerBeginRefreshing) name:@"reloadVC" object:nil];
    //求购发布完成刷新
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(headerBeginRefreshing) name:@"publishSPComletedNF" object:nil];
    //判断用户是否登录
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if (dic != nil) {
        [self.tableView headerBeginRefreshing];
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    SPScreeningListController *sp = [sb instantiateViewControllerWithIdentifier:@"SPScreeningListController"];
    sp.completeBlock = ^(NSString *minMoney, NSString *maxMoney, NSString *shopLand) {
        _minPrice = minMoney;
        _maxPrice = maxMoney;
        _shopLand = shopLand;
        _param = [self parametersForDic:@"getPostListByTask" parameters:@{ACCOUNT_PASSWORD,@"type":@"1044", @"order": _priceDesc, @"minMoney": _minPrice, @"maxMoney": _maxPrice, @"shopland": _shopLand, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count]}];
        [self.tableView headerBeginRefreshing];
        _sp.view.hidden = YES;
        //_screeningBtn.selected = NO;
        [self changeScreeningBtnState];
    };
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[app.window addSubview:sp.view];
    [self.view addSubview:sp.view];
    sp.view.frame = app.window.bounds;
    sp.view.y = 40;
    sp.view.height = SCREEN_HEIGHT - 40;
    
    [sp.view addTapAction:@selector(removeSPView:) forTarget:self];
    _sp = sp;
    _sp.view.hidden = YES;
    
    _priceDesc = @"";
    _minPrice = @"";
    _maxPrice = @"";
    _shopLand = @"";
    //默认请求参数
    _param = [self parametersForDic:@"getPostListByTask" parameters:@{ACCOUNT_PASSWORD,@"type":@"1044", @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count]}];
    
    //设置向上按钮
    [self toTop];
    
    [[WQGuideView share] showAtIndex:5 GuideViewRemoveBlock:nil];
}


#pragma mark- 事件
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
- (void)clickToTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self huanYuan];
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
    //atScrollPosition:UITableViewScrollPositionTop
    // animated:YES];
}
- (void)huanYuan
{
    _isNavBarHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        //self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 49);
        
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
- (IBAction)latestBtnClicked:(UIButton *)sender {
    if (_sp.view.hidden == NO) {
        _sp.view.hidden = YES;
        
    }
    _priceDesc = @"";
    _minPrice = @"";
    _maxPrice = @"";
    _shopLand = @"";
    
    [self changeScreeningBtnState];
    //self.screeningBtn.selected = NO;
    //self.priceBtn.selected = NO;
    self.latestBtn.selected = YES;
    [self.priceBtn setImage:[UIImage imageNamed:@"sp_screening_arrowdown"] forState:UIControlStateNormal];
    [self.priceBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
    
    
    
    
    _param = [self parametersForDic:@"getPostListByTask" parameters:@{ACCOUNT_PASSWORD,@"type":@"1044", @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count]}];
    
    [self.tableView headerBeginRefreshing];
}
- (IBAction)priceBtnClicked:(UIButton *)sender {
    if (_sp.view.hidden == NO) {
        _sp.view.hidden = YES;
    }
    
    self.latestBtn.selected = NO;
    //self.screeningBtn.selected = NO;
    //self.priceBtn.selected = YES;
    
    if ([_priceDesc isEqualToString:@""]) {
        _priceDesc = @"price-desc";
        [self.priceBtn setImage:[UIImage imageNamed:@"sp_screening_red_arrowdown"] forState:UIControlStateNormal];
    }else if ([_priceDesc isEqualToString:@"price-desc"]) {
        [self.priceBtn setImage:[UIImage imageNamed:@"sp_screening_red_arrowup"] forState:UIControlStateNormal];
        _priceDesc = @"price-asc";
    }else if ([_priceDesc isEqualToString:@"price-asc"]) {
        [self.priceBtn setImage:[UIImage imageNamed:@"sp_screening_red_arrowdown"] forState:UIControlStateNormal];
        _priceDesc = @"price-desc";
    }
    [self.priceBtn setTitleColor:SELECTED_COLOR forState:UIControlStateNormal];
    
    _param = [self parametersForDic:@"getPostListByTask" parameters:@{ACCOUNT_PASSWORD,@"type":@"1044", @"order": _priceDesc, @"minMoney": _minPrice, @"maxMoney": _maxPrice, @"shopland": _shopLand, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count]}];
    
    [self.tableView headerBeginRefreshing];
}
- (IBAction)screeningBtnClicked:(UIButton *)sender {
    self.latestBtn.selected = NO;
    //数据还没有加载
    if (_sp.dataArray.count == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"数据还没加载完成，稍等哦..."];
        return;
    }
    if (_sp.view.hidden) {
        _sp.view.hidden = NO;
        
    }else {
        _sp.view.hidden = YES;
    }
    
    [self changeScreeningBtnState];
    //sender.selected = !sender.selected;
}
-(void)changeScreeningBtnState {
    if (_minPrice.length || _minPrice.length || _shopLand.length) {
        //有筛选条件
        if (_sp.view.hidden) {
            [_screeningBtn setTitleColor:SELECTED_COLOR forState:UIControlStateNormal];
            [_screeningBtn setImage:[UIImage imageNamed:@"sp_screening_red_arrowdown"] forState:UIControlStateNormal];
        }else {
            [_screeningBtn setTitleColor:SELECTED_COLOR forState:UIControlStateNormal];
            [_screeningBtn setImage:[UIImage imageNamed:@"sp_screening_red_arrowup"] forState:UIControlStateNormal];
            
        }
        
    }else {
        //没有筛选条件
        if (_sp.view.hidden) {
            [_screeningBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
            [_screeningBtn setImage:[UIImage imageNamed:@"sp_screening_arrowdown"] forState:UIControlStateNormal];
        }else {
            [_screeningBtn setTitleColor:NORMAL_COLOR forState:UIControlStateNormal];
            [_screeningBtn setImage:[UIImage imageNamed:@"sp_screening_arrowup"] forState:UIControlStateNormal];
            
        }
    }
}
-(void)removeSPView:(UIGestureRecognizer *)gr {
    _sp.view.hidden = YES;
    //_screeningBtn.selected = NO;
    
    [self changeScreeningBtnState];
}
#pragma mark- scrollview delegate
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    if (velocity.y > 0) {
//        _isNavBarHidden = YES;
//        [LayoutFrame showViewConstraint:self.tableView AttributeHeight:CGRectGetHeight(self.tableView.frame) + 49];
//        //self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
//        
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//        AppDelegate * app = APPDELEGATE;
//        [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        
//    }else if(velocity.y < 0){
//        [self huanYuan];
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        toTopBtn.hidden = YES;
    }
}
#pragma mark- 网络请求
//最新话题列表
-(void)loadNewDataListRequest {
    _page = 0;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:_param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        _noDataView.hidden = YES;
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [self addData:tempdic];
            }
        }else if([result isEqualToString:@"4"]){
            _noDataView.hidden = NO;
        }else{
            _noDataView.hidden = NO;
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
}
-(void)addData:(NSDictionary *)data {
    BussinessModel * bussinessModel = [[BussinessModel alloc]init];
    [bussinessModel setValuesForKeysWithDictionary:data];
    bussinessModel.sayHeight = [bussinessModel.say calculateSize:CGSizeMake(_propertyCell.memoLbl.frame.size.width + (SCREEN_WIDTH - 320), FLT_MAX) font:_propertyCell.memoLbl.font].height;
    [self.dataArray addObject:bussinessModel];
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    _page += NumOfItemsForZuji;
    //NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1044",@"categoryID":@"256", @"start":[NSString stringWithFormat:@"%d",_page], @"count":[NSString stringWithFormat:@"%d",_count]}];
    NSString *method = _param[@"method"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_param[@"parameters"]];
    [parameters setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"start"];
    
    NSDictionary *tempParam = [self parametersForDic:method parameters:parameters];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempParam andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [self addData:tempdic];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    _page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            _page -= NumOfItemsForZuji;
        }else{
            _page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        _page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
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
