//
//  SquareViewController.m
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "SquareViewController.h"
#import "ZZGoPayBtn.h"
#import "SquareModel.h"
#import "SquareCell.h"
#import "GroupModel.h"
#import "XLCycleScrollView.h"
#import <UIImageView+WebCache.h>
#import "SquareSearchViewController.h"
#import "CarouselDiagram.h"
#import "SquareMoreViewController.h"
#import "DetailActivityViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

@interface SquareViewController ()<UITableViewDataSource,UITableViewDelegate,squareCellDelegate>

@end

@implementation SquareViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;     //详细数组
    NSMutableArray * groupArray;    //分组数组
    NSMutableDictionary * addDic;      //详细数组的数组
    int count;
    XLCycleScrollView * csView;     //轮播图
    UIImageView * imgView1;
    UIImageView * imgView2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customInit];
    self.navigationItem.title = @"随便逛逛";
}

- (void)backBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)customInit
{
    count = 0;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //dataArray = [NSMutableArray array];
    groupArray = [NSMutableArray array];
    addDic = [NSMutableDictionary dictionary];
    

    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.rowHeight = 257;
    tableview.tableFooterView = [[UIView alloc]init];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview headerBeginRefreshing];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"shopping_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
}

- (void)searchBtn:(UIButton *)sender
{
    SquareSearchViewController * squareSearchVC = [[SquareSearchViewController alloc]init];
    squareSearchVC.searchState = @"none";
    [self.navigationController pushViewController:squareSearchVC animated:YES];
}

#pragma mark - 广告请求
- (void)adUrlPostRequest
{
    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self getImgWithDic:dic];
        }
    } andFailureBlock:^{
        
    }];
    
}

- (void)getImgWithDic:(NSDictionary *)dic
{
    NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
    NSMutableArray * imgarr = [NSMutableArray array];
    imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 130)];
    CarouselDiagram *cdView = [[CarouselDiagram alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130) andimgArray:imgarr];
    tableview.tableHeaderView = cdView;
    [imgView1 sd_setImageWithURL:[NSURL URLWithString:[temparr[0] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imgarr addObject:imgView1];
        //[cdView start];
    }];
    [imgView2 sd_setImageWithURL:[NSURL URLWithString:[temparr[1] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imgarr addObject:imgView2];
        [cdView start];
    }];

}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getPostListByType" parameters:@{@"type":@"123",@"count":@"6"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [groupArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                GroupModel * groupModel = [[GroupModel alloc]init];
                [groupModel setValuesForKeysWithDictionary:tempdic];
                [groupArray addObject:groupModel];
            }

        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview headerEndRefreshing];
        [tableview reloadData];
    } andFailureBlock:^{
        [tableview headerEndRefreshing];
    }];
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
        [self adUrlPostRequest];
    });
}

#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return groupArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建一个cell
    SquareCell * cell = [SquareCell squareCellWithTableView:tableview andIndexPath:indexPath];
    //2.取出对应的模型
    GroupModel * groupModel = [groupArray objectAtIndex:indexPath.section];
    cell.moreBtn.indexpath = indexPath;
    [cell.moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
    NSArray * dataArr = [addDic objectForKey:groupModel.categoryID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailArr = dataArr;
    cell.groupModel = groupModel;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BussinessViewController * bussinessVC = [[BussinessViewController alloc]init];
//    [self.navigationController pushViewController:bussinessVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)moreBtn:(ZZGoPayBtn *)sender
{
    GroupModel * groupModel = groupArray[sender.indexpath.section];
    SquareMoreViewController * squareMoreVC = [[SquareMoreViewController alloc]init];
    squareMoreVC.keyStr = groupModel.categoryID;
    squareMoreVC.titleStr = groupModel.categoryName;
    [self.navigationController pushViewController:squareMoreVC animated:YES];
}

#pragma mark - squareCellDelegate
- (void)jumpToDetail:(NSInteger)index
{
    DetailActivityViewController * detailVC = [[DetailActivityViewController alloc]init];
    detailVC.idNumber = [NSString stringWithFormat:@"%lu",index];
    [self.navigationController pushViewController:detailVC animated:YES];
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
