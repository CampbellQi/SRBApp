//
//  DrawRecordsViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "DrawRecordsViewController.h"
#import "DrawRecordModel.h"
#import "MJRefresh.h"
#import "DrawRecordCell.h"
#import "MyWalletActivityViewController.h"
#import "GetMoneyDetailViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface DrawRecordsViewController ()
{
    NSMutableArray * _modelArr;
    UITableView * _tableView;
    int _start;
    NoDataView * imageview;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation DrawRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _start = 0;
    _modelArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.title = @"提现记录";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    

    imageview = [[NoDataView alloc]initWithFrame:_tableView.frame];
    imageview.hidden = YES;
    [_tableView addSubview:imageview];
    
    [self setupRefresh];
}

- (void)backBtn:(id)sender
{
//    MyWalletActivityViewController * vc = [[MyWalletActivityViewController alloc]init];
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:vc.class]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

//post请求
- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetWithdrawRecords" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_modelArr removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < arr.count; i++) {
                DrawRecordModel * model = [[DrawRecordModel alloc]init];
                [model setValuesForKeysWithDictionary:arr[i]];
                [_modelArr addObject:model];
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }
        else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        page = 0;
    } andFailureBlock:^{
        page = 0;
        imageview.hidden = NO;
        [_modelArr removeAllObjects];
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
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

}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self post];
    });
    
}

- (void)footerRereshing
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self footPost];
        
    });
}

//post请求
- (void)footPost
{
    page += NumOfItemsForZuji;
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetWithdrawRecords" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < arr.count; i++) {
                DrawRecordModel * model = [[DrawRecordModel alloc]init];
                [model setValuesForKeysWithDictionary:arr[i]];
                [_modelArr addObject:model];
                if (_modelArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_modelArr removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [_tableView reloadData];
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [_tableView footerEndRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrawRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DrawRecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.memoLabel.text = [NSString stringWithFormat:@"提现号：%@",[_modelArr[indexPath.row] num]];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@", [_modelArr[indexPath.row] withdrawCash]];
    cell.updatetimeLabel.text = [_modelArr[indexPath.row] updatetime];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetMoneyDetailViewController * getMoneyVC = [[GetMoneyDetailViewController alloc]init];
    getMoneyVC.drawRecordModel = _modelArr[indexPath.row];
    [self.navigationController pushViewController:getMoneyVC animated:YES];
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
