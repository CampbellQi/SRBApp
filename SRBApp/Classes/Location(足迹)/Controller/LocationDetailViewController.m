//
//  LocationDetailViewController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/30.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "AppDelegate.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController
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
    // Do any additional setup after loading the view.
    self.title = @"足迹详情";
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    //toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60 - 64, 45, 45);
    [self setUpView];
    //[self.tableview removeHeader];
    //[self.tableview removeFooter];
    //[self loadDataReqeust];
}
#pragma mark- 页面
-(void)setUpView {
    self.navigationItem.rightBarButtonItem = nil;
    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
}
#pragma mark- 事件
-(void)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getLocationDetail" parameters:@{ACCOUNT_PASSWORD,@"id":self.ID}];
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            LocationModel * locationModel = [[LocationModel alloc]init];
            [locationModel setValuesForKeysWithDictionary:dic[@"data"]];
            locationModel.zanCount = locationModel.likeCount;
            [dataArray removeAllObjects];
            [dataArray addObject:locationModel];
            CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            if (locationModel.content.length == 0) {
                rect.size.height = 0.0;
            }
            locationModel.contentFrame = rect;
        }else if ([result isEqualToString:@"4"]){
            [self backBtnClicked:nil];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        //[self.tableview removeHeader];
        //[self.tableview removeFooter];
        //[HUD removeFromSuperview];
    } andFailureBlock:^{
        //[HUD removeFromSuperview];
        [self.tableview headerEndRefreshing];
    }];
}
- (void)footerRefresh {
    [self.tableview footerEndRefreshing];
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
