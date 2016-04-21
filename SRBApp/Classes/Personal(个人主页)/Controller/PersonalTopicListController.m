//
//  PersonalTopicListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalTopicListController.h"
#import "NoDataView.h"

@interface PersonalTopicListController ()
{
    NoDataView * _noDataView;
}
@end

@implementation PersonalTopicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"reloadVC" object:nil];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollwithVelocity:)]) {
        [self.delegate scrollwithVelocity:velocity];
    }
}
- (void)refresh
{
    [self.tableView headerBeginRefreshing];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self loadNewDataListRequest];
}
- (void)footerRefresh
{
    [self loadMoreDataListRequest];
}
#pragma mark- 网络请求
//最新话题列表
- (void)loadNewDataListRequest
{
    page = 0;
//    NSString *categoryID = @"250";
//    if (_type == Users_Type) {
//        categoryID = @"251";
//    }
//    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    NSString *account = ACCOUNT_SELF;
    if (self.account) {
        account = self.account;
    }
    NSDictionary * param = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":account, @"type":@"1042",@"dealType":@"0", @"status":@"1", @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
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
                 _noDataView.hidden = YES;
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
//更多话题列表
- (void)loadMoreDataListRequest
{
    
    
    page += NumOfItemsForZuji;
//    NSString *categoryID = @"250";
//    if (_type == Users_Type) {
//        categoryID = @"251";
//    }
    NSString *account = ACCOUNT_SELF;
    if (self.account) {
        account = self.account;
    }
    NSDictionary * param = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":account, @"type":@"1042",@"dealType":@"0", @"order": @"postid", @"status":@"1",@"start":[NSString stringWithFormat:@"%d", page], @"count":[NSString stringWithFormat:@"%d",count]}];
    
//    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
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
