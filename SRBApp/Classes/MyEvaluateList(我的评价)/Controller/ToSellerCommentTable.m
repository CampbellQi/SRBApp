//
//  ToSellerCommentTable.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ToSellerCommentTable.h"
#import "FollowEvaluateViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface ToSellerCommentTable ()

@end

@implementation ToSellerCommentTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    noData.hidden = YES;
    //noData.center = self.tableView.center;
    [self.tableView addSubview:noData];

    dataArray = [NSMutableArray array];
    TotalArray = [NSMutableArray array];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FollowEvaluateViewController * vc = [[FollowEvaluateViewController alloc]init];
//    vc.orderID = [dataArray[indexPath.row] orderId];
//    vc.itemID = [dataArray[indexPath.row] itemId];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    MyEvaluateListCell * cell = [MyEvaluateListCell sellerCellWithTableView:tableView];
    TosellerModel * sellerModel = dataArray[indexPath.row];
    cell.goodsImg.indexpath = indexPath;
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [cell.goodsImg addGestureRecognizer:imgTap];
    cell.commentType = @"toseller";
    cell.toSellerModel = sellerModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //NSArray * imageArr = [sellerModel.photos componentsSeparatedByString:@","];
//    if (imageArr.count < 4 && imageArr.count >= 1) {
//        cell.commentBgview.frame = CGRectMake(15, cell.commentImg.frame.size.height + cell.commentImg.frame.origin.y, SCREEN_WIDTH - 30, 60 + (SCREEN_WIDTH - 30 - 20) / 3);
//    }else if (imageArr.count >= 4){
//        cell.commentBgview.frame = CGRectMake(15, cell.commentImg.frame.size.height + cell.commentImg.frame.origin.y, SCREEN_WIDTH - 30, 60 + (SCREEN_WIDTH - 30 - 20) / 3 * 2 + 5);
//    }
    return cell;
}

- (void)imgTap:(UITapGestureRecognizer *)tap
{
    MyImgView * tempImg = (MyImgView *)tap.view;
    TosellerModel * sellerModel = dataArray[tempImg.indexpath.row];
    SecondSubclassDetailViewController *subDetailVC = [[SecondSubclassDetailViewController alloc] init];
    subDetailVC.idNumber = sellerModel.ID;
    [self.navigationController pushViewController:subDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TosellerModel * sellerModel = dataArray[indexPath.row];
    if ([sellerModel.isCommented isEqualToString:@"1"]) {
        CGRect rect = [sellerModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
        NSArray * imageArr = [sellerModel.photos componentsSeparatedByString:@","];
        if (imageArr.count < 4 && imageArr.count >= 1) {
            return rect.size.height + 149 + 20 + (SCREEN_WIDTH - 30 - 20) / 3;
        }else if (imageArr.count >= 4){
            return rect.size.height + 149 + 20 + (SCREEN_WIDTH - 30 - 20) / 3 * 2 + 5;
        }
        return rect.size.height + 149;
    }else{
        return 149;
    }
    
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"toseller",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        [TotalArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                if ([commentModel.isCommented isEqualToString:@"1"]) {
                    [dataArray addObject:commentModel];
                }
                [TotalArray addObject:commentModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        if (dataArray.count == 0) {
            noData.hidden = NO;
        }
        page = 0;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        noData.hidden = NO;
        [dataArray removeAllObjects];
        [TotalArray removeAllObjects];
        [self.tableView reloadData];
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
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"toseller",@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //0是成功
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [TotalArray addObject:commentModel];
                if (TotalArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [TotalArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
                if ([commentModel.isCommented isEqualToString:@"1"]) {
                    [dataArray addObject:commentModel];
                }
            }
            noData.hidden = YES;
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
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
