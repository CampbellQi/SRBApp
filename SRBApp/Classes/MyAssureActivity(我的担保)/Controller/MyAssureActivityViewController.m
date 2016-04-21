//
//  MyAssureActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyAssureActivityViewController.h"
#import "MyAssureThingsCell.h"
#import "MyAssureOrderCell.h"
#import "MJRefresh.h"
#import "MyAssureThingModel.h"
#import "MyAssureOrderModel.h"
#import "NoDataView.h"
#import <UIImageView+WebCache.h>

@interface MyAssureActivityViewController ()
{
    UIButton * thingsBtn;
    UIButton * orderBtn;
    UIView * view1;
    UIView * view2;
    UITableView * tableView1;
    UITableView * tableView2;
    NSMutableArray * thingsArr;
    NSMutableArray * orderArr;
    int _start1;
    int _start2;
    NoDataView * imageview;
}
@end

@implementation MyAssureActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的担保";
    _start1 = 0;
    _start2 = 0;
    thingsArr = [NSMutableArray array];
    orderArr = [NSMutableArray array];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    theView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:theView];
    
    thingsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 38)];
    [thingsBtn setTitle:@"我担保的商品" forState:UIControlStateNormal];
    thingsBtn.font = [UIFont systemFontOfSize:15];
    [thingsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [thingsBtn addTarget:self action:@selector(thingsAction) forControlEvents:UIControlEventTouchUpInside];
    [thingsBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [theView addSubview:thingsBtn];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(thingsBtn.frame.origin.x, thingsBtn.frame.origin.y + thingsBtn.frame.size.height, thingsBtn.frame.size.width, 2)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    [theView addSubview:view1];
    
    orderBtn = [[UIButton alloc]initWithFrame:CGRectMake(thingsBtn.frame.origin.x + thingsBtn.frame.size.width, 0, SCREEN_WIDTH / 2, 38)];
    [orderBtn setTitle:@"我担保的订单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    orderBtn.font = [UIFont systemFontOfSize:15];
    [orderBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:orderBtn];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(orderBtn.frame.origin.x, orderBtn.frame.origin.y + orderBtn.frame.size.height, orderBtn.frame.size.width, 2)];
    view2.backgroundColor = [UIColor clearColor];
    [theView addSubview:view2];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, theView.frame.origin.y + theView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView1];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 20
                                                              , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView2];
    
    imageview = [[NoDataView alloc]initWithFrame:tableView2.frame];
//    imageview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageview];
    
//    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 + 20, SCREEN_HEIGHT / 4, 160, 200)];
//    [imageV setImage:[UIImage imageNamed:@"empty_view.png"]];
//    [imageview addSubview:imageV];
//    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
//    label.center = CGPointMake(SCREEN_WIDTH / 2, imageV.frame.origin.y + imageV.frame.size.height + 20);
//    label.text = @"暂时没有相关的内容~";
//    label.textAlignment = UITextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:16];
//    [imageview addSubview:label];
    
    [self setupRefresh1];
    [self setupRefresh2];
}

- (void)backBtn:(id)sender
{
    [self.navigationController dismissViewController];
}

- (void)thingsAction
{
//    tableView1.center= CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
//    tableView2.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT / 2 + 40);
    tableView1.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    tableView2.frame = CGRectMake(SCREEN_WIDTH, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view2.backgroundColor = [UIColor clearColor];
    [thingsBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setupRefresh1];
    imageview.center = tableView2.center;
    
}

- (void)orderAction
{
//    tableView1.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
//    tableView2.center= CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT / 2);
    tableView2.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    tableView1.frame = CGRectMake(SCREEN_WIDTH, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    view2.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view1.backgroundColor = [UIColor clearColor];
    [orderBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [thingsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setupRefresh2];
    imageview.center = tableView1.center;
}

- (void)deleteThing:(id)sender
{
    PublishButton * button = sender;
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountDeleteGuaranteePost" parameters:@{@"account":name, @"password":password,@"id":[thingsArr[button.tag - 100] model_id]}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [thingsArr removeObjectAtIndex:button.tag - 100];
            [tableView1 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:button.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView1.center;
        }
    }];

}

- (void)deleteList:(id)sender
{
    PublishButton * button = sender;
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetGuaranteeOrderDelete" parameters:@{@"account":name, @"password":password,@"orderId":[orderArr[button.tag - 100] orderId]}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [orderArr removeObjectAtIndex:button.tag - 100];
            [tableView2 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:button.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
        }
    }];
}

//post请求
- (void)post1
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSString * start = [NSString stringWithFormat:@"%d", _start1];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{@"account":name, @"password":password, @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                MyAssureThingModel * model = [[MyAssureThingModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [thingsArr addObject:model];
                if (thingsArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [thingsArr removeLastObject];
                    break;
                }
            }
            [tableView1 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            _start1 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView1.center;
        }
    }];
}

//post请求
- (void)post2
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSString * start = [NSString stringWithFormat:@"%d", _start2];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeOrderList" parameters:@{@"account":name, @"password":password, @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                MyAssureOrderModel * model = [[MyAssureOrderModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [orderArr addObject:model];
                if (orderArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [orderArr removeLastObject];
                    break;
                }
            }
            [tableView2 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            _start2 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView2.center;
        }
    }];
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark -
#pragma mark 刷新
- (void)setupRefresh1
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView1 addHeaderWithTarget:self action:@selector(headerRereshing1)];
    [tableView1 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView1 addFooterWithTarget:self action:@selector(footerRereshing1)];
    [tableView1 footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView1.headerPullToRefreshText = @"下拉可以刷新了";
    tableView1.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView1.headerRefreshingText = @"正在刷新中";

    tableView1.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView1.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView1.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing1
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (thingsArr.count == 0) {
            [self post1];
        } else
        {
            [tableView1 reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView1 headerEndRefreshing];
    });
    
}

- (void)footerRereshing1
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post1];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView1 footerEndRefreshing];
    });
}

#pragma mark -
#pragma mark 刷新
- (void)setupRefresh2
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView2 addHeaderWithTarget:self action:@selector(headerRereshing2)];
    [tableView2 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView2 addFooterWithTarget:self action:@selector(footerRereshing2)];
    [tableView2 footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView2.headerPullToRefreshText = @"下拉可以刷新了";
    tableView2.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView2.headerRefreshingText = @"正在刷新中";
    
    tableView2.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView2.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView2.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing2
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (orderArr.count == 0) {
            [self post2];
        } else
        {
            [tableView2 reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView2 headerEndRefreshing];
    });
    
}

- (void)footerRereshing2
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post2];
        [tableView2 reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView2 footerEndRefreshing];
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1) {
        MyAssureThingsCell * cell = [[MyAssureThingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.thingImv sd_setImageWithURL:[NSURL URLWithString:[thingsArr[indexPath.row] cover]]];
        cell.titleLb.text =[thingsArr[indexPath.row] title];
        cell.detailLb.text = [thingsArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[thingsArr[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLb.text = str;
        [cell.deleteBtn addTarget:self action:@selector(deleteThing:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteBtn setTag:100 + indexPath.row];
        cell.deleteBtn.indexpath = indexPath;
        return cell;
    }
    if (tableView == tableView2) {
        MyAssureOrderCell * cell = [[MyAssureOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        NSArray * arr = [orderArr[indexPath.row] goods];
        NSDictionary * dic = [arr firstObject];
        [cell.thingImv sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"cover"]]];
        cell.titleLb.text = [NSString stringWithFormat:@"订单号:%@",[orderArr[indexPath.row] orderNum]];
        cell.detailLb.text = [dic objectForKey:@"title"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //日期格式化
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[orderArr[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLb.text = str;;
        cell.priceLb.text = [NSString stringWithFormat:@"￥%@",[orderArr[indexPath.row] orderAmount]];
        cell.customLb.text = [NSString stringWithFormat:@"卖家:%@", [orderArr[indexPath.row] sellernick]];
        cell.salerLb.text = [NSString stringWithFormat:@"买家:%@",[orderArr[indexPath.row] buyernick]];
        cell.moveListBtn.text = [orderArr[indexPath.row] statusName];
        if ([cell.moveListBtn.text isEqualToString:@"订单取消"]) {
            [cell.deleteBtn setBackgroundImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];
            [cell.deleteBtn addTarget:self action:@selector(deleteList:) forControlEvents:UIControlEventTouchUpInside];
            [cell.deleteBtn setTag:100 + indexPath.row];
            cell.deleteBtn.indexpath = indexPath;
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1) {
        return 90;
    }
    if (tableView == tableView2) {
        return 140;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableView1) {
        return thingsArr.count;
    }
    if (tableView == tableView2) {
        return orderArr.count;
    }
    return 0;
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
