//
//  WaitCommentTableViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WaitCommentTableViewController.h"

#import "SellerEvaluateViewController.h"

@interface WaitCommentTableViewController ()

@end

@implementation WaitCommentTableViewController
{
    NoDataView * noData;
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.title = @"卖家评价管理";
    dataArray = [NSMutableArray array];
    totalArray = [NSMutableArray array];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    noData = [[NoDataView alloc]initWithFrame:self.tableView.frame];
    noData.hidden = YES;
    [self.tableView addSubview:noData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    WaitCommentCell * cell = [WaitCommentCell waitCommentCellWithTableView:tableView];
    TosellerModel * sellerModel = dataArray[indexPath.row];
    cell.toSellerModel = sellerModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goCommentBtn.indexpath = indexPath;
    [cell.goCommentBtn addTarget:self action:@selector(goCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)goCommentBtn:(ZZGoPayBtn *)sender
{
    SellerEvaluateViewController * sellerEvaluateVC = [[SellerEvaluateViewController alloc]init];
    sellerEvaluateVC.toSellerModel = dataArray[sender.indexpath.row];
    [self.navigationController pushViewController:sellerEvaluateVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139;
}

- (void)urlRequestPost
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderCommentList" parameters:@{@"account":name,@"password":pass,@"start":@"0",@"count":@"20"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [dataArray removeAllObjects];
        [totalArray removeAllObjects];
        if (result == 0) {
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
//                if ([commentModel.isCommented isEqualToString:@"0"]) {
//                    [dataArray addObject:commentModel];
//                }
//                [totalArray addObject:commentModel];
                [dataArray addObject:commentModel];
                noData.hidden = YES;
            }
            [self.tableView reloadData];
        }else if(result == 4){
            noData.hidden = NO;
            [self.tableView reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
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
    static int page = 0;
    //每次加载20条数据
    page += 20;
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderCommentList" parameters:@{@"account":name,@"password":pass,@"start":[NSString stringWithFormat:@"%d",page],@"count":@"20"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //0是成功
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commentModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    break;
                }
//                if ([commentModel.isCommented isEqualToString:@"0"]) {
//                    [dataArray addObject:commentModel];
//                }
            }
            [self.tableView reloadData];
        }else if(result == 4){
            [self.tableView reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

@end
