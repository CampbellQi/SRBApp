//
//  BuyerWaitCommentViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BuyerWaitCommentViewController.h"
#import "MineEvaluateViewController.h"
#import "NoDataView.h"
#import "BuyerWaitCommentCell.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface BuyerWaitCommentViewController ()

@end

@implementation BuyerWaitCommentViewController
//{
//    NoDataView * noData;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"待评价";
    
//    noData = [[NoDataView alloc]initWithFrame:self.tableView.frame];
//    noData.hidden = YES;
//    noData.center = self.tableView.center;
//    [self.tableView addSubview:noData];
//    dataArray = [NSMutableArray array];
//    totalArray = [NSMutableArray array];
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
//    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
//    [self.tableView headerBeginRefreshing];
//    
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    BuyerWaitCommentCell * cell = [BuyerWaitCommentCell waitCommentCellWithTableView:tableView];
    TosellerModel * sellerModel = dataArray[indexPath.row];
    cell.toSellerModel = sellerModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goCommentBtn.indexpath = indexPath;
    [cell.goCommentBtn addTarget:self action:@selector(goCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)goCommentBtn:(ZZGoPayBtn *)sender
{
    MineEvaluateViewController * myEvaluateVC = [[MineEvaluateViewController alloc]init];
    myEvaluateVC.toSellerModel = dataArray[sender.indexpath.row];
    myEvaluateVC.backBlock = ^(void) {
        [self urlRequestPost];
    };
    [self.navigationController pushViewController:myEvaluateVC animated:YES];
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commentModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        [dataArray removeAllObjects];
        noData.hidden = NO;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;

    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //0是成功
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commentModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            noData.hidden = YES;
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


#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
