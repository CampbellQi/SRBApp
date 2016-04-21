//
//  FromSellerViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FromSellerViewController.h"
#import "FollowEvaluateViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface FromSellerViewController ()

@end

@implementation FromSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.evaGrade = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"tobuyer",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count],@"grade":self.evaGrade}];
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
            if (dataArray.count == 0) {
                noData.hidden = NO;
            }else{
                noData.hidden = YES;
            }
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        if (dataArray.count == 0) {
            noData.hidden = NO;
        }
        [self.tableView reloadData];
        page = 0;
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [TotalArray removeAllObjects];
        [dataArray removeAllObjects];
        noData.hidden = NO;
        page =0 ;
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
    page += NumOfItemsForZuji;;
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"tobuyer",@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItems],@"grade":self.evaGrade}];
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
        [self.tableView footerEndRefreshing];
        page -= NumOfItemsForZuji;
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

@end
