//
//  PersonalLocationListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalLocationListController.h"

//上拉加载的起始页
static int page = 0;
//请求数据的条数
static int count = NumOfItemsForZuji;

@interface PersonalLocationListController ()

@end

@implementation PersonalLocationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.tableview.height += 20;
    // Do any additional setup after loading the view.
    [self.tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableview headerBeginRefreshing];
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
    [self.tableview headerBeginRefreshing];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self urlRequestPost];
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
//    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByFancy" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    NSString *account = ACCOUNT_SELF;
    if (self.account) {
        account = self.account;
    }
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{ACCOUNT_PASSWORD,@"user":account,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                [dataArray addObject:locationModel];
                CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                if (locationModel.content.length == 0) {
                    rect.size.height = 0.0;
                }
                locationModel.contentFrame = rect;
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
            //toTopBtn.hidden = YES;
        }else{
            noData.hidden = NO;
            //toTopBtn.hidden = YES;
            //[AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView reloadData];
        page = 0;
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        //toTopBtn.hidden = YES;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        noData.hidden = NO;
    }];
}
#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSString *account = ACCOUNT_SELF;
    if (self.account) {
        account = self.account;
    }
//    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByFancy"
//                                     parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{@"user":account,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                if (locationModel.content.length == 0) {
                    rect.size.height = 0.0;
                }
                locationModel.contentFrame = rect;
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
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
