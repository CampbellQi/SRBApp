//
//  ShopTotalViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShopTotalViewController.h"
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
#import "ZZNavigationController.h"
#import "SquareSearchViewController.h"
#import "DetailActivityViewController.h"


@interface ShopTotalViewController ()<UITableViewDataSource,UITableViewDelegate,squareCellDelegate>
@end

@implementation ShopTotalViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;     //详细数组
    NSMutableArray * groupArray;    //分组数组
    NSDictionary * addDic;      //广告
    int count;
    MBProgressHUD * HUD;
    XLCycleScrollView * csView;     //轮播图
    UIImageView * imgView1;
    UIImageView * imgView2;
    NoDataView * imageview;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customInit];
    [self adUrlPostRequest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"shopSquare"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"shopSquare"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)customInit
{
    count = 0;
    
    //dataArray = [NSMutableArray array];
    groupArray = [NSMutableArray array];
    addDic = [NSDictionary dictionary];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 38)style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableV = tableview;
    tableview.rowHeight = 257;
    tableview.tableFooterView = [[UIView alloc]init];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview headerBeginRefreshing];
    
    tableview.delaysContentTouches = NO;
    [self.view addSubview:tableview];
    
    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    [tableview addSubview:imageview];
    
    [self urlRequestPost];
}

- (void)searchBtn:(UIButton *)sender
{
    SquareSearchViewController * squareSearchVC = [[SquareSearchViewController alloc]init];
    [self.navigationController pushViewController:squareSearchVC animated:YES];
}

#pragma mark - 广告请求
- (void)adUrlPostRequest
{
    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            addDic = dic;
            [self getImgWithDic:dic];
        }
    } andFailureBlock:^{
        
    }];
}

- (void)searchVC:(UITapGestureRecognizer *)tap
{
//    SquareSearchViewController * squareSearchVC = [[SquareSearchViewController alloc]init];
//    squareSearchVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:squareSearchVC animated:YES];
}

- (void)tapDetail1:(UITapGestureRecognizer *)tap
{
    NSArray * temparr = [[addDic objectForKey:@"data"] objectForKey:@"list"];
    int ID = [[temparr[0] objectForKey:@"url"] intValue];
    if (ID != 0) {
        DetailActivityViewController * subsubVC = [[DetailActivityViewController alloc]init];
        subsubVC.idNumber = [NSString stringWithFormat:@"%d",ID];
        [self.navigationController pushViewController:subsubVC animated:YES];
    }
}

- (void)tapDetail2:(UITapGestureRecognizer *)tap
{
    NSArray * temparr = [[addDic objectForKey:@"data"] objectForKey:@"list"];
    int ID = [[temparr[1] objectForKey:@"url"] intValue];
    if (ID != 0) {
        DetailActivityViewController * subsubVC = [[DetailActivityViewController alloc]init];
        subsubVC.idNumber = [NSString stringWithFormat:@"%d",ID];
        [self.navigationController pushViewController:subsubVC animated:YES];
    }
}

- (void)getImgWithDic:(NSDictionary *)dic
{
    NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
    NSMutableArray * imgarr = [NSMutableArray array];
    imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 130)];

    imgView1.userInteractionEnabled = YES;
    imgView2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * imgView1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail1:)];
    UITapGestureRecognizer * imgView2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail2:)];
    
    [imgView1 addGestureRecognizer:imgView1Tap];
    [imgView2 addGestureRecognizer:imgView2Tap];
    
    
    
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    tableview.tableHeaderView = topBGView;
    
    CarouselDiagram *cdView = [[CarouselDiagram alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130) andimgArray:imgarr];
    [topBGView addSubview:cdView];
    
    [imgView1 sd_setImageWithURL:[NSURL URLWithString:[temparr[0] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imgarr addObject:imgView1];
        [imgView2 sd_setImageWithURL:[NSURL URLWithString:[temparr[1] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [imgarr addObject:imgView2];
            cdView.imageArray = imgarr;
            [cdView start];
        }];
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
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            imageview.hidden = NO;
        }
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        imageview.hidden = NO;
        [groupArray removeAllObjects];
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
    //SquareCell * cell = [SquareCell squareCellWithTableView:tableView];
    //2.取出对应的模型
    GroupModel * groupModel = [groupArray objectAtIndex:indexPath.section];
    cell.moreBtn.indexpath = indexPath;
    [cell.moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.groupModel = groupModel;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    BussinessViewController * bussinessVC = [[BussinessViewController alloc]init];
    //    [self.navigationController pushViewController:bussinessVC animated:YES];
}

- (void)moreBtn:(ZZGoPayBtn *)sender
{
    SquareMoreViewController * vc = [[SquareMoreViewController alloc]init];
    GroupModel * groupModel = groupArray[sender.indexpath.section];
    vc.keyStr = groupModel.categoryID;
    vc.titleStr = groupModel.categoryName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - squareCellDelegate
- (void)jumpToDetail:(NSInteger)index
{
    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
    vc.idNumber = [NSString stringWithFormat:@"%lu",index];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
