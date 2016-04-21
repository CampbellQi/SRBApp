//
//  ImpressionViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ImpressionViewController.h"
#import "MJRefresh.h"
#import "RemarkModel.h"
#import "ImpressionCell.h"
#import "NoDataView.h"
static int page = 0;

@interface ImpressionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ImpressionViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;
    NoDataView * imageview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customInit];
}

#pragma mark - 控件初始化
- (void)customInit
{
    
    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview: tableview];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];

    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    imageview.center = tableview.center;
    [tableview addSubview:imageview];
}

#pragma mark = tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 99;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImpressionCell * cell = [ImpressionCell impressionCellWithTaableView:tableView];
    cell.impressionModel = dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"getRemarkUserList" parameters:@{@"user":name,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                RemarkModel * impressionModel = [[RemarkModel alloc]init];
                [impressionModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:impressionModel];
            }
            [tableview reloadData];
            [tableview headerEndRefreshing];
            imageview.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [tableview reloadData];
            [tableview headerEndRefreshing];
            imageview.hidden = NO;

        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
            [tableview headerEndRefreshing];
        }
        page = 0;
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
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"getRemarkUserList" parameters:@{@"user":name,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                RemarkModel * impressionModel = [[RemarkModel alloc]init];
                [impressionModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:impressionModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [tableview reloadData];
            [tableview footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [tableview reloadData];
            [tableview footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
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
