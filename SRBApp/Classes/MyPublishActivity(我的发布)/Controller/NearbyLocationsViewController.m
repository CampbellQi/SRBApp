//
//  NearbyLocationsViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NearbyLocationsViewController.h"
#import "TencentMapModel.h"
#import "MJRefresh.h"
#import "NearbyLocationVCell.h"
static int page = 0;
//#import "ChangeBuyViewController.h"

@interface NearbyLocationsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSMutableArray *dataArray;
}
@end

@implementation NearbyLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customView];
    [self creatHeaderView];

}

- (void)customView
{
    self.navigationItem.title = @"所在位置";
    
    dataArray = [NSMutableArray array];
    dataArray = [[NSMutableArray alloc] init];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.tableFooterView = [[UIView alloc] init];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
}

- (void)creatHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 59)];
    tableview.tableHeaderView = headerView;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 11, 15)];
    imgView.image = [UIImage imageNamed:@"locationadd_icon"];
    [headerView addSubview:imgView];
    
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, SCREEN_WIDTH - imgView.frame.origin.x - imgView.frame.size.width - 9, 18)];
    addressLable.text = @"默认定位";
    addressLable.font = [UIFont systemFontOfSize:14];
    addressLable.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [headerView addSubview:addressLable];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(35, imgView.frame.origin.x + imgView.frame.size.width + 9, SCREEN_WIDTH - imgView.frame.origin.x - imgView.frame.size.width - 9, 14)];
    titleLable.textColor = [GetColor16 hexStringToColor:@"#959595"];
    titleLable.text = self.address;
    titleLable.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:titleLable];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(17, 58, SCREEN_WIDTH - 17, 1)];
    line.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [headerView addSubview:line];
    
    UITapGestureRecognizer *locationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTap)];
    [headerView addGestureRecognizer:locationTap];
    
}

- (void)locationTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//传值
- (void)position:(PositionBlock)block
{
    self.positionBlock = block;
}
#pragma mark --UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TencentMapModel *model = [dataArray objectAtIndex:indexPath.row];
    CGRect rect = [model.address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil];
    return 59 - 14 + rect.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"nearbyLocation";
    NearbyLocationVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NearbyLocationVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TencentMapModel *model = [dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    CGRect rect = [model.address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 35, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil];
    cell.addressLable.frame = CGRectMake(35, cell.locationImage.frame.origin.x + cell.locationImage.frame.size.width + 9, SCREEN_WIDTH - cell.locationImage.frame.origin.x - cell.locationImage.frame.size.width - 9, rect.size.height);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TencentMapModel *model = [dataArray objectAtIndex:indexPath.row];
    if (self.positionBlock != nil) {
        self.positionBlock(model.title,model.location);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSString *urlStr = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/place/v1/search?boundary=nearby(%@,%@,1000)&keyword=&page_size=%d&page_index=1&orderby=_distance&key=PP6BZ-JZC3W-CQWRR-OC6UL-VNQST-FSBL7",self.lat,self.lon,NumOfItemsForZuji];
    [URLRequest getRequestWith:urlStr parameters:nil andblock:^(NSDictionary *dic) {
        NSArray *array = [dic objectForKey:@"data"];
        for (int i = 0; i < array.count; i ++ ) {
            TencentMapModel *model = [[TencentMapModel alloc] init];
            NSDictionary *temDic = [array objectAtIndex:i];
            [model setValuesForKeysWithDictionary:temDic];
            [dataArray addObject:model];
            NSLog(@"model.title == %@",model.title);
        }
        [tableview reloadData];
        [tableview headerEndRefreshing];
        page = 0;
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSString *urlStr = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/place/v1/search?boundary=nearby(%@,%@,1000)&keyword=&page_size=%d&page_index=%d&orderby=_distance&key=PP6BZ-JZC3W-CQWRR-OC6UL-VNQST-FSBL7",self.lat,self.lon,NumOfItemsForZuji,page];
    [URLRequest getRequestWith:urlStr parameters:nil andblock:^(NSDictionary *dic) {
        NSArray *array = [dic objectForKey:@"data"];
        for (int i = 0; i < array.count; i ++ ) {
            TencentMapModel *model = [[TencentMapModel alloc] init];
            NSDictionary *temDic = [array objectAtIndex:i];
            [model setValuesForKeysWithDictionary:temDic];
            [dataArray addObject:model];
            NSLog(@"model.title == %@",model.title);
        }
        [tableview reloadData];
        [tableview footerEndRefreshing];
    }];
//    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
//    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
//    NSDictionary * dic = [self parametersForDic:@"accountGetFriendApply" parameters:@{@"account":name,@"password":pass,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
//    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        int result = [[dic objectForKey:@"result"] intValue];
//        if (result == 0) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                NewFriendModel * newFriendModel = [[NewFriendModel alloc]init];
//                [newFriendModel setValuesForKeysWithDictionary:tempdic];
//                [dataArray addObject:newFriendModel];
//                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
//                    [dataArray removeLastObject];
//                    page -= NumOfItemsForZuji;
//                    break;
//                }
//            }
//            [tableview reloadData];
//        }else if(result == 4){
//            page -= NumOfItemsForZuji;
//            [tableview reloadData];
//        }else{
//            page -= NumOfItemsForZuji;
//            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
//        }
//        [tableview footerEndRefreshing];
//    }];
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
