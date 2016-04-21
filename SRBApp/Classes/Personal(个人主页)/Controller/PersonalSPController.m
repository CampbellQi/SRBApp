//
//  PersonalSPController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalSPController.h"
#import "CommonView.h"
#import "AppDelegate.h"
#import "PersonalBaseSPListController.h"
#import "MJRefresh.h"
#import "WQGuideView.h"

@interface PersonalSPController ()
{
    NSArray *_titleArray;
    NavSliderScrollView *_navSliderScrollView;
}
@end

@implementation PersonalSPController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavSliderSV];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navScrollToCalculate) name:@"SPNavScrollToCalculateNF" object:nil];
    
    //代付款-付款成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spOrderPaySuccessNF) name:@"SPOrderPaySuccessNF" object:nil];
    //代收货-收货成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spOrderContirmReceiptNF) name:@"SPOrderContirmReceiptNF" object:nil];
    //代评论-评论成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spOrderBuyerCommentNF) name:@"SPOrderBuyerCommentNF" object:nil];
    
    self.title = @"我的求购";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    
    [[WQGuideView share] showAtIndex:3 GuideViewRemoveBlock:^{
        
    }];

}
//刷新当前所在栏目数据
-(void)reloadCurrentViewData {
    UIView *view = _navSliderScrollView.currentView;
    UIResponder *nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        PersonalBaseSPListController *vc = (PersonalBaseSPListController *)nextResponder;
        [vc.tableView headerBeginRefreshing];
    }
}
#pragma mark- 页面
-(void)setUpNavSliderSV {
    _titleArray = @[@{@"name": @"待接单", @"status": @"S100"}, @{@"name": @"待报价", @"status": @"D10010"}, @{@"name": @"待付款", @"status": @"D10020"}, @{@"name": @"待采购", @"status": @"D10030"}, @{@"name": @"待发货", @"status": @"F10010"}, @{@"name": @"待收货", @"status": @"F10020"}, @{@"name": @"待评价", @"status": @"P100"}, @{@"name": @"已完成", @"status": @"W100"}, @{@"name": @"已取消", @"status": @"Q100"}];
    
    NavSliderScrollView *navSliderSV = [[NavSliderScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAIN_NAV_HEIGHT) TitlesArray:_titleArray FirstView:[self getPersonalBaseSPListControllerWithIndex:0].view];
    navSliderSV.navSliderScrollViewDelegate = self;
    [self.view addSubview:navSliderSV];
    _navSliderScrollView = navSliderSV;
}
#pragma mark-  NavSliderScrollViewDelegate method
-(UIView *)getShowItemViewWithIndex:(int)index {
    return [self getPersonalBaseSPListControllerWithIndex:index].view;
}
-(PersonalBaseSPListController *)getPersonalBaseSPListControllerWithIndex:(int)index {
    PersonalBaseSPListController *baseSp = [[PersonalBaseSPListController alloc] initBySP];
    if (index == 0) {
        baseSp.isFillings = YES;
    }
    baseSp.orderStatus = _titleArray[index][@"status"];
    baseSp.currentNC = self.navigationController;
    baseSp.reloadNavTitle = ^(void) {
        [self loadTitlesRequest];
    };
    [self addChildViewController:baseSp];
    return baseSp;
}
#pragma mark- notification center method
-(void)spOrderPaySuccessNF {
    if ([_navSliderScrollView.contentViewArray[2] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[2];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[3] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[3];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:3];
}
-(void)spOrderContirmReceiptNF {
    if ([_navSliderScrollView.contentViewArray[5] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[5];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[6] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[6];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:6];
}
-(void)spOrderBuyerCommentNF {
    if ([_navSliderScrollView.contentViewArray[6] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[6];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[7] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[7];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:7];
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
//滚动到待报价
-(void)navScrollToCalculate {
    UIView *view1 = _navSliderScrollView.contentViewArray[0];
    UIResponder *nextResponder = [view1 nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
        [vc1.tableView headerBeginRefreshing];
    }
    
    if ([_navSliderScrollView.contentViewArray[1] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[1];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:1];
}

#pragma mark- 网络请求
//获取每个标题对应的内容数量
-(void)loadTitlesRequest {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"刷新中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
    
    NSDictionary * param = [self parametersForDic:@"accountGetBuyPostCount" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        //[hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (_navSliderScrollView) {
                [_navSliderScrollView reloadTitle:dic[@"data"]];
            }else {
            }
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
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
