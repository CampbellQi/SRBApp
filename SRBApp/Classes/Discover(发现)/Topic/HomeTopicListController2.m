//
//  HomeTopicController2.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/29.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "HomeTopicListController2.h"

@interface HomeTopicListController2 ()

@end

@implementation HomeTopicListController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView headerBeginRefreshing];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollWithContentOffset:)]) {
        [self.delegate scrollWithContentOffset:scrollView.contentOffset];
    }
}
#pragma mark- 网络请求
//最新话题列表
-(void)loadNewDataListRequest {
    if (ACCOUNT_SELF == nil || PASSWORD_SELF == nil) {
        return;
    }
    
    page = 0;
    NSDictionary * param = [self parametersForDic:@"getPostListByTagLink" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":self.categoryID,@"order": @"best", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    if (ACCOUNT_SELF == nil || PASSWORD_SELF == nil) {
        return;
    }
    
    page += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"getPostListByTagLink" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":self.categoryID,@"order": @"best", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
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
//点赞
-(void)praiseRequest:(BussinessModel *)model {
    NSString *url = @"accountLikePost";
    if ([model.isLike isEqualToString:@"1"]) {
        //已经点过赞，取消点赞
        url = @"accountDeleteLikedPost";
    }
    NSDictionary * param = [self parametersForDic:url parameters:@{ACCOUNT_PASSWORD,@"id":model.model_id}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            if ([model.isLike isEqualToString:@"1"]) {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] > 0 ? [model.likeCount intValue] - 1 : 0];
                
            }else {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] + 1];
            }
            
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
    } andFailureBlock:^{
        
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
