//
//  ToBuyerCommentTable.m
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ToBuyerCommentTable.h"
#import "SecondSubclassDetailViewController.h"

@interface ToBuyerCommentTable ()

@end
static int page = 0;
static int count = NumOfItemsForZuji;
@implementation ToBuyerCommentTable

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 91 - 64)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    SellerEvaluateListActivityCell * cell = [SellerEvaluateListActivityCell sellerCellWithTableView:tableView];
    TosellerModel * sellerModel = dataArray[indexPath.row];
    //    [cell.goComentBtn addTarget:self action:@selector(goComentBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentType = @"tobuyer";
    cell.goodsImg.indexpath = indexPath;
    UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
    [cell.goodsImg addGestureRecognizer:imgTap];
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
        //return rect.size.height + 103 + 10 + 16 + 10 + 10;
    }else{
        return 149 + 10 + 16 + 10 + 10;
    }
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"tobuyer",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
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
                //                [dataArray addObject:commentModel];
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
    count += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"tobuyer",@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItems]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
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
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
