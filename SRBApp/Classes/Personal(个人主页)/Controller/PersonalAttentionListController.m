//
//  PersonalAttentionListController.m
//  SRBApp
//  我的关注
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//
#define CELL_HEIGHT 70

#import "PersonalAttentionListController.h"
#import "MarkTopicListHeaderView.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "CommonView.h"
#import "MarkTopicListController.h"
#import "WQAlertView.h"
#import "NoDataView.h"


@interface PersonalAttentionListController ()
{
    NSMutableArray *_dataArray;
    int _page;
    int _count;
     NoDataView * _noDataView;
}
@end

@implementation PersonalAttentionListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    //app.zhedangView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [NSMutableArray new];
    self.title = @"我的关注";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    [self.view layoutIfNeeded];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView headerBeginRefreshing];
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        MarkTopicListHeaderView *markTopicView = [[MarkTopicListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT)];
        markTopicView.grayLbl.hidden = YES;
        NSLog(@"frame = %@", NSStringFromCGRect(markTopicView.frame));
        [cell.contentView addSubview:markTopicView];
        //markTopicView.tag = 100;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dict = _dataArray[indexPath.row];
        markTopicView.dataDict = dict;
        markTopicView.attentionBtn.hidden = YES;
        markTopicView.attentionCountLbl.text = [NSString stringWithFormat:@"关注%@   话题%@", dict[@"likeCount"], dict[@"topicCount"]];
    }
//    NSDictionary *dict = _dataArray[indexPath.row];
//    MarkTopicListHeaderView *markTopicView = [(MarkTopicListHeaderView *)cell.contentView viewWithTag:100];
//    markTopicView.dataDict = dict;
//    [markTopicView.attentionBtn addTarget:self action:@selector(attentionClicked:) forControlEvents:UIControlEventTouchUpInside];
//    markTopicView.attentionBtn.tag = 200 + indexPath.row;
//    markTopicView.attentionBtn.hidden = YES;
//    markTopicView.attentionCountLbl.text = [NSString stringWithFormat:@"关注%@   话题%@", dict[@"likeCount"], dict[@"topicCount"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataArray[indexPath.row];
    MarkTopicListController *vc = [[MarkTopicListController alloc] init];
    vc.tagName = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSDictionary * InfoModel = [_dataArray objectAtIndex:indexPath.row];
//        NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD,@"id":InfoModel[@"id"]}];
//        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//            NSString * result = [dic objectForKey:@"result"];
//            if ([result isEqualToString:@"0"]) {
//                if (_dataArray.count == 0) {
//                    _noDataView.hidden = NO;
//                }
//                [self.tableView headerBeginRefreshing];
//            }else{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//        }];
//        [_dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
//        [_dataArray removeObject:dict];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self cancelAttentionStateRequest:dict];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
    }
}
-(void)attentionClicked:(UIButton *)sender
{
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:@"提示" Message:@"确定取消关注？" ConfirmName:@"确定" CancelName:@"取消" ConfirmBlock:^{
        MarkTopicListHeaderView *markTopicView = (MarkTopicListHeaderView *)sender.superview.superview;
        NSDictionary *dict = markTopicView.dataDict;
        NSLog(@"%ld", sender.tag);
        [self cancelAttentionStateRequest:dict];
    } CancelBlock:nil];
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
    _page = 0;
    _count = NumOfItemsForZuji * 2;
    NSDictionary * param = [self parametersForDic:@"getCollectedTagList" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count], @"order": @"postid"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            [_dataArray addObjectsFromArray:[[dic objectForKey:@"data"] objectForKey:@"list"]];
            _noDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            _noDataView.hidden = NO;
        }else{
             _noDataView.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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
    _page += _count;
    NSDictionary * param = [self parametersForDic:@"getCollectedTagList" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d", _page], @"count":[NSString stringWithFormat:@"%d",_count], @"order": @"postid"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [_dataArray addObject:tempdic];
                if (_dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_dataArray removeLastObject];
                    _page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            _page -= NumOfItemsForZuji;
        }else{
            _page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        _page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
}
//标签取消关注
//- (void)cancelAttentionStateRequest:(NSDictionary *)dict {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"获取中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
//    
//    NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedTag" parameters:@{ACCOUNT_PASSWORD, @"id": dict[@"id"]}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [hud removeFromSuperview];
//        if ([result isEqualToString:@"0"]) {
//            //[self showTableHeaderView:[dic objectForKey:@"data"]];
//            // [_markDataDict setObject:@"0" forKey:@"isLike"];
//            //_headerView.dataDict = _markDataDict;
//            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:dict] inSection:0];
//            [_dataArray removeObject:dict];
//            [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationMiddle];
//        }
//    } andFailureBlock:^{
//        [hud removeFromSuperview];
//    }];
//}
- (void)cancelAttentionStateRequest:(NSDictionary *)dict {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];

    NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedTag" parameters:@{ACCOUNT_PASSWORD, @"id": dict[@"id"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            //[self showTableHeaderView:[dic objectForKey:@"data"]];
            // [_markDataDict setObject:@"0" forKey:@"isLike"];
            //_headerView.dataDict = _markDataDict;
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:dict] inSection:0];
            [_dataArray removeObject:dict];
            if (_dataArray.count == 0) {
                _noDataView.hidden = NO;
            }
            [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
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
