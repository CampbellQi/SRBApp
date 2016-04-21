//
//  CommentsByRelationViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CommentsByRelationViewController.h"
#import "NoDataView.h"
#import "MarkModel.h"
#import "MarkOrCommentsCell.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "AccountCommentViewController.h"
#import "SubViewController.h"
@interface CommentsByRelationViewController ()
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

@implementation CommentsByRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"咨询";
    _start1 = 0;
    _start2 = 0;
    friendArr = [NSMutableArray array];
    allArr = [NSMutableArray array];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 60, 25);
    [regBtn setTitle:@"咨询" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = 4;
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    theView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:theView];
    
    friendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 38)];
    [friendBtn setTitle:@"熟人咨询" forState:UIControlStateNormal];
    friendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [friendBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendAction) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [theView addSubview:friendBtn];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(friendBtn.frame.origin.x, friendBtn.frame.origin.y + friendBtn.frame.size.height, friendBtn.frame.size.width, 2)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    [theView addSubview:view1];
    
    allBtn = [[UIButton alloc]initWithFrame:CGRectMake(friendBtn.frame.origin.x + friendBtn.frame.size.width, 0, SCREEN_WIDTH / 2, 38)];
    [allBtn setTitle:@"全部咨询" forState:UIControlStateNormal];
    [allBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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

- (void)regController:(id)sender
{
    AccountCommentViewController * vc = [[AccountCommentViewController alloc]init];
    vc.idNumber = _idNumber;
    [vc sendMessage:^(id result) {
        [friendArr removeAllObjects];
        [self setupRefresh1];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)friendAction
{
    tableView1.frame = CGRectMake(0, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    tableView2.frame = CGRectMake(SCREEN_WIDTH, view1.frame.origin.y + view1.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view2.backgroundColor = [UIColor clearColor];
    [friendBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [allBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
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
    [friendBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [allArr removeAllObjects];
    [self setupRefresh2];
    imageview.center = tableView1.center;
}

//post请求
- (void)post1
{
    NSString * start = [NSString stringWithFormat:@"%d", _start1];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"1",@"id":_idNumber,@"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
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
    }andFailureBlock:^{
        
    }];
}

//post请求
- (void)post2
{
    NSString * start = [NSString stringWithFormat:@"%d", _start2];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":_idNumber,@"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
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
    }andFailureBlock:^{
        
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
        cell.headImage.indexpath = indexPath;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[friendArr[indexPath.row] cover]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.headImage.clipsToBounds = YES;
        cell.titleLabel.text =[friendArr[indexPath.row] nickname];
        cell.sayLabel.text = [friendArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate * date = [dateFormatter dateFromString:[friendArr[indexPath.row] updatetime]];
//        [dateFormatter setDateFormat:@"MM-dd"];
//        NSString * str = [dateFormatter stringFromDate:date];
        MarkModel * modfl = friendArr[indexPath.row];
        double i = modfl.updatetimeLong;
        cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];
//        cell.dateLabel.text = [friendArr[indexPath.row] updatetimeLong];
        UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
        [cell.headImage addGestureRecognizer:tapToPersonal];
        return cell;
    }
    if (tableView == tableView2) {
        MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        cell.headImage.indexpath = indexPath;
        UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
        [cell.headImage addGestureRecognizer:tapToPersonal];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[friendArr[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
        cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.headImage.clipsToBounds = YES;
        cell.titleLabel.text =[friendArr[indexPath.row] nickname];
        cell.sayLabel.text = [friendArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSDate * date = [dateFormatter dateFromString:[friendArr[indexPath.row] updatetime]];
//        [dateFormatter setDateFormat:@"MM-dd"];
//        NSString * str = [dateFormatter stringFromDate:date];
        MarkModel * modfl = friendArr[indexPath.row];
        double i = modfl.updatetimeLong;
        cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];
        
        return cell;
    }
    return nil;
}

- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    MyImgView * myImg = (MyImgView *)sender.view;
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = friendArr[myImg.indexpath.row];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
