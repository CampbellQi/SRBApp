//
//  TatolEvaluateViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TatolEvaluateViewController.h"
#import "BuyandSayCellFrame.h"

static int page = 0;
@interface TatolEvaluateViewController ()
{
    NoDataView * nodataView;
}
@end

@implementation TatolEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] avatar]]];
//    cell.titleLabel.text =[dataArray[indexPath.row] nickname];
//    cell.sayLabel.text = [dataArray[indexPath.row] content];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
//    [dateFormatter setDateFormat:@"MM-dd"];
//    NSString * str = [dateFormatter stringFromDate:date];
//    cell.dateLabel.text = str;
//    
//    return cell;
//}


#pragma mark - 网络请求
- (void)urlRequestPost
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                BuyandSayCellFrame *frame = [BuyandSayCellFrame new];
                frame.markModel = bussinessModel;
                [dataArray addObject:frame];
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            nodataView.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
        }
        page = 0;
    }andFailureBlock:^{
        
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
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                BuyandSayCellFrame *frame = [BuyandSayCellFrame new];
                frame.markModel = bussinessModel;
                [dataArray addObject:frame];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
    }andFailureBlock:^{
        
    }];
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
