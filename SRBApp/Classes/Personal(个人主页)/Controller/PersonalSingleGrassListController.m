//
//  PersonalSingleGrassListController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PersonalSingleGrassListController.h"
#import "PersonalSingleGrassListCell.h"
#import "NoDataView.h"

//上拉加载的起始页
static int page = 0;
//请求数据的条数
static int count = NumOfItemsForZuji;

@interface PersonalSingleGrassListController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NoDataView * _noDataView;
    PersonalSingleGrassListCell *_propertyCell;
}
@end

@implementation PersonalSingleGrassListController
-(void)viewWillAppear:(BOOL)animateds {
    [super viewWillAppear:animateds];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"grass" object:nil];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"PersonalSingleGrassListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PersonalSingleGrassListCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonalSingleGrassListCell"];
    
    self.tableView.tableFooterView = [UIView new];
    //_tableView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    
    [_tableView headerBeginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"reloadVC" object:nil];
    
}
- (void)refresh
{
    [self.tableView headerBeginRefreshing];
    //[self totalPriceRequest];
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PersonalSingleGrassListCell";
    PersonalSingleGrassListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.sourceDict = _dataArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    //return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(_propertyCell.frame);
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollwithVelocity:)]) {
        [self.delegate scrollwithVelocity:velocity];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        NewsCenterModel *model = [_dataArray objectAtIndex:indexPath.row];
//        [_dataArray removeObject:model];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self deleteRequet:model];
//        
//    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary * InfoModel = [_dataArray objectAtIndex:indexPath.row];
        NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD,@"id":InfoModel[@"id"]}];
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                if (_dataArray.count == 0) {
                   _noDataView.hidden = NO;
                   _totalPriceView.hidden = YES;
                }
            [self.tableView headerBeginRefreshing];
            [self totalPriceRequest];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
    
}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
    
}
//最新话题列表
- (void)loadNewDataListRequest
{
    page = 0;
    //    NSString *categoryID = @"250";
    //    if (_type == Users_Type) {
    //        categoryID = @"251";
    //    }
    //    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    NSDictionary * param = [self parametersForDic:@"getCollectedPostList" parameters:@{ACCOUNT_PASSWORD,@"dealType":@"1", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            _noDataView.hidden = YES;
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [_dataArray addObjectsFromArray:temparrs];
        }else if([result isEqualToString:@"4"]){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _noDataView.hidden = NO;
            //_totalPriceView.hidden = YES;
        }else{
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _noDataView.hidden = NO;
            //_totalPriceView.hidden = YES;
        }
        
        [self.tableView reloadData];
        [self totalPriceRequest];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    
    
    page += NumOfItemsForZuji;
    //    NSString *categoryID = @"250";
    //    if (_type == Users_Type) {
    //        categoryID = @"251";
    //    }
    
    NSDictionary * param = [self parametersForDic:@"getCollectedPostList" parameters:@{ACCOUNT_PASSWORD,@"dealType":@"1",@"start":[NSString stringWithFormat:@"%d", page], @"count":[NSString stringWithFormat:@"%d",count]}];
    
    //    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [_dataArray addObject:tempdic];
                if (_dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
            //[self totalPriceRequest];
        }else if([result isEqualToString:@"4"]){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            page -= NumOfItemsForZuji;
            //_totalPriceView.hidden = YES;
        }else{
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            page -= NumOfItemsForZuji;
            //_totalPriceView.hidden = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
}
//总价参数获取
- (void)totalPriceRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCollectedPostTotalPrice" parameters:@{ACCOUNT_PASSWORD,@"dealType":@"1"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[_bussinessModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            self.totalPriceLB.text = [NSString stringWithFormat:@"总价 ¥ %@",[[dic objectForKey:@"data"]objectForKey:@"priceTotal"]];
            self.totalPriceLB.hidden = NO;
        }else if([result isEqualToString:@"4"]){
            self.totalPriceLB.hidden = YES;
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
    }];
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
