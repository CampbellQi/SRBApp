//
//  AccountDetailActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "AccountDetailActivityViewController.h"
#import "AccountDetailModel.h"
#import "AccountDetailCell.h"
#import "MJRefresh.h"

@interface AccountDetailActivityViewController ()
{
    AccountDetailModel * _model;
    NSMutableArray * _modelArr;
    UITableView * _tableView;
    int _start;
    NoDataView * imageview;
}
@end

@implementation AccountDetailActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _start = 0;
    _modelArr = [[NSMutableArray alloc]init];
    self.title = @"账单明细";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    imageview = [[NoDataView alloc]initWithFrame:_tableView.frame];
    imageview.hidden = YES;
    imageview.center = _tableView.center;
    [_tableView addSubview:imageview];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self setupRefresh];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//post请求
- (void)post
{
    NSString * start = [NSString stringWithFormat:@"%d", _start];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetConsumptionRecords" parameters:@{ACCOUNT_PASSWORD, @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        [_modelArr removeAllObjects];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < arr.count; i++) {
                AccountDetailModel * model = [[AccountDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:arr[i]];
                [_modelArr addObject:model];
            }
            [_tableView reloadData];
            imageview.hidden = YES;
        }else if (result == 4){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

//post请求
- (void)postfooter
{
    NSString * start = [NSString stringWithFormat:@"%d", _start];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetConsumptionRecords" parameters:@{ACCOUNT_PASSWORD, @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < arr.count; i++) {
                AccountDetailModel * model = [[AccountDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:arr[i]];
                [_modelArr addObject:model];
                if (_modelArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_modelArr removeLastObject];
                    break;
                }
            }
            [_tableView reloadData];
            _start += 10;
            imageview.hidden = YES;
        }else if (result == 4){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

#pragma mark -
#pragma mark 刷新
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [_tableView footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"正在刷新中";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (_modelArr.count == 0) {
            [self post];
        } else
        {
            [_tableView reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}
- (void)footerRereshing
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self postfooter];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AccountDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.memoLabel.text = [_modelArr[indexPath.row] memo];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@", [_modelArr[indexPath.row] price]];
    cell.updatetimeLabel.text = [_modelArr[indexPath.row] updatetime];
    cell.typeLabel.text = @"交易成功";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

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
