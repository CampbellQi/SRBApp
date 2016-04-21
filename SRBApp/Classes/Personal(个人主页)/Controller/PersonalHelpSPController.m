//
//  PersonalHelpSPController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalHelpSPController.h"
#import "AppDelegate.h"
#import "PersonalBaseSPListController.h"
#import "CommonView.h"
#import "MJRefresh.h"
#import "WQGuideView.h"

@interface PersonalHelpSPController ()
{
    NSArray *_titleArray;
    NavSliderScrollView *_navSliderScrollView;
}
@end

@implementation PersonalHelpSPController
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
    // Do any additional setup after loading the view from its nib.
    [self setUpNavSliderSV];
    //修改商品完成发通知刷新我的代购-待报价
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spGoodsUpdatedNF) name:@"SPGoodsUpdatedNF" object:nil];
    //采购成功-我的代购补完小票
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spPurchaseSuccessNF) name:@"SPPurchaseSuccessNF" object:nil];
    //代发货-发货完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spOrderDeliveryCompletedNF) name:@"SPOrderDeliveryCompletedNF" object:nil];
    //待评论-评论成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spOrderSellerCommentNF) name:@"SPOrderSellerCommentNF" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的接单";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    
    [[WQGuideView share] showAtIndex:4 GuideViewRemoveBlock:^{
        
    }];
    
}
#pragma mark- 页面
-(void)setUpNavSliderSV {
    _titleArray = @[@{@"name": @"申请中", @"status": @"S200"}, @{@"name": @"待报价", @"status": @"D20010"}, @{@"name": @"待付款", @"status": @"D20020"}, @{@"name": @"待采购", @"status": @"D20030"}, @{@"name": @"待发货", @"status": @"F20010"}, @{@"name": @"待收货", @"status": @"F20020"}, @{@"name": @"待评价", @"status": @"P200"}, @{@"name": @"已完成", @"status": @"W200"}, @{@"name": @"已取消", @"status": @"Q200"}];
    
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
    PersonalBaseSPListController *baseSp = [[PersonalBaseSPListController alloc] initByHelpSP];
    baseSp.orderStatus = _titleArray[index][@"status"];
    baseSp.currentNC = self.navigationController;
    baseSp.reloadNavTitle = ^(void) {
        [self loadTitlesRequest];
    };
    [self addChildViewController:baseSp];
    return baseSp;
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)spGoodsUpdatedNF {
    if ([_navSliderScrollView.contentViewArray[1] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[1];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[2] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[2];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:2];
}
-(void)spPurchaseSuccessNF{
    if ([_navSliderScrollView.contentViewArray[3] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[3];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[4] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[4];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:4];
}
-(void)spOrderDeliveryCompletedNF {
    if ([_navSliderScrollView.contentViewArray[4] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[4];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }
    
    if ([_navSliderScrollView.contentViewArray[5] isKindOfClass:[UIView class]]) {
        UIView *view2 = _navSliderScrollView.contentViewArray[5];
        UIResponder *nextResponder2 = [view2 nextResponder];
        if ([nextResponder2 isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc2 = (PersonalBaseSPListController *)nextResponder2;
            [vc2.tableView headerBeginRefreshing];
        }
    }
    [_navSliderScrollView scrollToIndex:5];
}
-(void)spOrderSellerCommentNF {
    if ([_navSliderScrollView.contentViewArray[6] isKindOfClass:[UIView class]]) {
        UIView *view1 = _navSliderScrollView.contentViewArray[6];
        UIResponder *nextResponder = [view1 nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            PersonalBaseSPListController *vc1 = (PersonalBaseSPListController *)nextResponder;
            [vc1.tableView headerBeginRefreshing];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- 网络请求
//获取每个标题对应的内容数量
-(void)loadTitlesRequest {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"刷新中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
    
    NSDictionary * param = [self parametersForDic:@"accountGetBidPostCount" parameters:@{ACCOUNT_PASSWORD}];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
