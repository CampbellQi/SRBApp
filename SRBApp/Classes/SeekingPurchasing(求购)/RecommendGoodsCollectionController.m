//
//  RecommendGoodsCollectionController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "RecommendGoodsCollectionController.h"

@interface RecommendGoodsCollectionController ()

@end

@implementation RecommendGoodsCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView headerBeginRefreshing];
    
}

//最新商品列表
- (void)loadNewDataListRequest
{
    _page = 0;
    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{ACCOUNT_PASSWORD,@"type":@"123", @"keyword": _name, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count], @"order": @"postid", @"dealType": @"1"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            _noDataView.hidden = YES;
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
            
        }else if([result isEqualToString:@"4"]){
            _noDataView.hidden = NO;
        }else{
            _noDataView.hidden = NO;
        }
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    } andFailureBlock:^{
        [self.collectionView headerEndRefreshing];

    }];
    
}
//更多商品列表
- (void)loadMoreDataListRequest
{
    _page += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{ACCOUNT_PASSWORD,@"type":@"123", @"order": @"postid", @"keyword": _name, @"start":[NSString stringWithFormat:@"%d",_page], @"count":[NSString stringWithFormat:@"%d",_count], @"dealType": @"1"}];
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
                    _page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.collectionView reloadData];
        }else if([result isEqualToString:@"4"]){
            _page -= NumOfItemsForZuji;
        }else{
            _page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
        [self.collectionView footerEndRefreshing];
    } andFailureBlock:^{
        _page -= NumOfItemsForZuji;
        [self.collectionView footerEndRefreshing];
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillEndDraggingDelegate:)]) {
        [self.delegate scrollViewWillEndDraggingDelegate:velocity];
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
