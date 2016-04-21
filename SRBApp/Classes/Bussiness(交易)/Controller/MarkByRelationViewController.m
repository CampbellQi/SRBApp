//
//  MarkByRelationViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkByRelationViewController.h"
#import "NoDataView.h"
#import "MarkModel.h"
#import "MarkOrCommentsCell.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>

@interface MarkByRelationViewController ()
{
    UIButton * friendBtn;
    UIButton * allBtn;
    UIView * view1;
    UIView * view2;
    UITableView * tableView1;
    UITableView * tableView2;
    NSMutableArray * friendArr;
    NSMutableArray * allArr;
    int _start1;
    int _start2;
    NoDataView * imageview;
}
@end

@implementation MarkByRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    _start1 = 0;
    _start2 = 0;
    friendArr = [NSMutableArray array];
    allArr = [NSMutableArray array];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    theView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:theView];
    
    friendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 38)];
    [friendBtn setTitle:@"好友评价" forState:UIControlStateNormal];
    friendBtn.font = [UIFont systemFontOfSize:15];
    [friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendAction) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [theView addSubview:friendBtn];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(friendBtn.frame.origin.x, friendBtn.frame.origin.y + friendBtn.frame.size.height, friendBtn.frame.size.width, 2)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    [theView addSubview:view1];
    
    allBtn = [[UIButton alloc]initWithFrame:CGRectMake(friendBtn.frame.origin.x + friendBtn.frame.size.width, 0, SCREEN_WIDTH / 2, 38)];
    [allBtn setTitle:@"全部评价" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allBtn.font = [UIFont systemFontOfSize:15];
    [allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:allBtn];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(allBtn.frame.origin.x, allBtn.frame.origin.y + allBtn.frame.size.height, allBtn.frame.size.width, 2)];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)friendAction
{
    tableView1.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    tableView2.frame = CGRectMake(SCREEN_WIDTH, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view2.backgroundColor = [UIColor clearColor];
    [friendBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setupRefresh1];
    imageview.center = tableView2.center;
    
}

- (void)allAction
{
    tableView2.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    tableView1.frame = CGRectMake(SCREEN_WIDTH, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    view2.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view1.backgroundColor = [UIColor clearColor];
    [allBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setupRefresh2];
    imageview.center = tableView1.center;
}

//post请求
- (void)post1
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSString * start = [NSString stringWithFormat:@"%d", _start1];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{@"account":name, @"password":password, @"isFriended":@"1",@"id":_idNumber,@"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                MarkModel * model = [[MarkModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [friendArr addObject:model];
                if (friendArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [friendArr removeLastObject];
                    break;
                }
            }
            [tableView1 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            _start1 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"请求失败"];
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
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{@"account":name, @"password":password, @"isFriended":@"0",@"id":_idNumber,@"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                MarkModel * model = [[MarkModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [allArr addObject:model];
                if (allArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [allArr removeLastObject];
                    break;
                }
            }
            [tableView2 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            _start2 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"请求失败"];
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
        if (friendArr.count == 0) {
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
        if (allArr.count == 0) {
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
        MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[friendArr[indexPath.row] cover]]];
        cell.titleLabel.text =[friendArr[indexPath.row] nickname];
        cell.sayLabel.text = [friendArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[friendArr[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLabel.text = str;
        //        cell.dateLb.text = [thingsArr[indexPath.row] updatetime];
        //                @property (nonatomic, strong)UILabel * dateLb;
        //        @property (nonatomic, strong)UIButton * deleteBtn;
        return cell;
    }
    if (tableView == tableView2) {
        MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[friendArr[indexPath.row] cover]]];
        cell.titleLabel.text =[friendArr[indexPath.row] nickname];
        cell.sayLabel.text = [friendArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[friendArr[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLabel.text = str;
        
        //        @property (nonatomic, strong)UIButton * moveListBtn;
        
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
        return friendArr.count;
    }
    if (tableView == tableView2) {
        return allArr.count;
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
