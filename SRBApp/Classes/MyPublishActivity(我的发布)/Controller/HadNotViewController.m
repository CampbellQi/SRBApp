//
//  HadNotViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "HadNotViewController.h"
#import "ChangeSaleViewController.h"
#import "ChangeBuyViewController.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface HadNotViewController ()
{
    NoDataView * nodataView;
}
@end

@implementation HadNotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView addSubview:nodataView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSString * dealtype = [super dealType];
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":dealtype,@"status":@"-1", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                NotPublishModel * bussinessModel = [[NotPublishModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            nodataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        page = 0;
    } andFailureBlock:^{
        nodataView.hidden = NO;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        page = 0;
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSString * dealtype = [super dealType];
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":dealtype,@"status":@"-1", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if([result isEqualToString:@"4"]){
            [temTableView reloadData];
            page -= NumOfItemsForZuji;
            [temTableView footerEndRefreshing];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
            [temTableView footerEndRefreshing];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[dataArray[indexPath.row] bangPrice] intValue] > 0) {
        ChangeSaleViewController * vc = [[ChangeSaleViewController alloc]init];
        vc.model = dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ChangeBuyViewController * vc = [[ChangeBuyViewController alloc]init];
        vc.model = dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
