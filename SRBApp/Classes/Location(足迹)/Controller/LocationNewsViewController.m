//
//  LocationNewsViewController.m
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationNewsViewController.h"
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationNewsCell.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface LocationNewsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LocationNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"足迹消息";
    [self customInit];
}

- (void)customInit
{
    dataArr = [NSMutableArray array];
    //创建tableview
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 59) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 139;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableview];
    
    tableview.backgroundColor = [UIColor clearColor];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [dataArr removeAllObjects];
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArr addObject:locationModel];
            }
            [tableview reloadData];
        }else if(result == 4){
            [tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
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
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++){
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArr addObject:locationModel];
                if (dataArr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArr removeLastObject];
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
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

#pragma mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建一个cell
    LocationNewsCell * cell = [LocationNewsCell locationNewsCellWithTableView:tableView];
    cell.logoImg.indexpath = indexPath;
    cell.photoImg.indexpath = indexPath;
    UITapGestureRecognizer * logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoTap:)];
    [cell.logoImg addGestureRecognizer:logoTap];
    LocationModel * locationModel = dataArr[indexPath.row];
    cell.locationModel = locationModel;
    return cell;
}

- (void)logoTap:(UITapGestureRecognizer *)tap
{
    MyImgView * logoImg = (MyImgView *)tap.view;
    LocationModel * locationModel = dataArr[logoImg.indexpath.row];
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = locationModel.account;
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
