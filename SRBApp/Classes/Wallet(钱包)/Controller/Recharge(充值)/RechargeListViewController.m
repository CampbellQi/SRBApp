//
//  RechargeListViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "RechargeListViewController.h"
#import "RechargeListModel.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "RechargeListCell.h"
#import "ZZGoPayBtn.h"
#import "AlipayWrapper.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface RechargeListViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RechargeListViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;
    NoDataView * imageview;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值记录";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self customInit];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview: tableview];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    imageview.center = tableview.center;
    [tableview addSubview:imageview];
}

#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RechargeListCell * cell = [RechargeListCell rechargeListCellWithTableView:tableView];
    RechargeListModel * rechargeModel = dataArray[indexPath.row];
    cell.rechargeModel = rechargeModel;
    cell.goPayBtn.indexpath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.goPayBtn addTarget:self action:@selector(goPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)goPayBtn:(ZZGoPayBtn *)goPay
{
    RechargeListModel * rechargeModel = dataArray[goPay.indexpath.row];
    [AlipayWrapper alipaySyncRecharge:rechargeModel.orderNum orderID:rechargeModel.orderId amount:[rechargeModel.price floatValue] success:^(NSDictionary *resultDic) {
        [self urlRequestPost];
        [AutoDismissAlert autoDismissAlert:@"充值成功"];
    } failure:^(NSDictionary *resultDic) {
        [AutoDismissAlert autoDismissAlert:@"充值失败"];
    } ];
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetRechargeRecords" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                RechargeListModel * rechargeModel = [[RechargeListModel alloc]init];
                [rechargeModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:rechargeModel];
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            imageview.hidden = NO;
        }
        page = 0;
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        [dataArray removeAllObjects];
        page = 0;
        imageview.hidden = NO;
        [tableview reloadData];
        [tableview headerEndRefreshing];
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"accountGetRechargeRecords" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                RechargeListModel * rechargeModel = [[RechargeListModel alloc]init];
                [rechargeModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:rechargeModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [tableview reloadData];
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [tableview footerEndRefreshing];
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
