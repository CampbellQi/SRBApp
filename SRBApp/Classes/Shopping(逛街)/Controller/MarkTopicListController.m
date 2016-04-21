//
//  MarkTopicListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkTopicListController.h"
#import "MarkTopicListHeaderView.h"
#import "AppDelegate.h"


@interface MarkTopicListController ()
{
    MarkTopicListHeaderView *_headerView;
    NSString *_attentionCount;
    NSString *_topicCount;
    NSMutableDictionary *_markDataDict;
    BOOL _isAttentionCountUpdate;
    
    UIButton *toTopBtn;
    NoDataView *_noDataView;
}

@end

@implementation MarkTopicListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tagName;
    _topicCount = @"0";
    _attentionCount = @"0";
    _isAttentionCountUpdate = NO;
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
    
    
    [self loadTagDetailRequest];
    
}
#pragma mark- 页面
-(void)setUpView {
    _noDataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, MAIN_NAV_HEIGHT - 85)];
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
    
    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self toTop];
}
//返回顶部
- (void)toTop
{
    toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, MAIN_NAV_HEIGHT - 49 - 60, 45, 45);
    //    toTopBtn.backgroundColor = [UIColor redColor];
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    toTopBtn.hidden = YES;
    [self.view addSubview:toTopBtn];
    [self.view bringSubviewToFront:toTopBtn];
}
-(void)showTableHeaderView {
    MarkTopicListHeaderView *headerView = [[MarkTopicListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    self.tableView.tableHeaderView = headerView;
    [headerView.attentionBtn addTarget:self action:@selector(attentionClicked:) forControlEvents:UIControlEventTouchUpInside];
    _headerView = headerView;
    headerView.dataDict = _markDataDict;
    _attentionCount = _markDataDict[@"likeCount"];
    [self resetHeaderViewAttentionCount];
}
-(void)resetHeaderViewAttentionCount {
    _headerView.attentionCountLbl.text = [NSString stringWithFormat:@"关注%@      话题%@", _attentionCount, _topicCount];
}
#pragma mark- 事件
-(void)attentionClicked:(UIButton *)sender {
    if (sender.selected) {
        //已经关注了
        [self cancelAttentionStateRequest];
    }else {
        [self attentionStateRequest];
    }
}
//返回
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        toTopBtn.hidden = YES;
    }
}
#pragma mark- tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailListController *detail = [[TopicDetailListController alloc] init];
    detail.backBlock = ^(void) {
        //重新设置点赞数量
        [self.tableView reloadData];
        _isAttentionCountUpdate = YES;
        [self loadTagDetailRequest];
    };
    detail.sourceModal = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark- 事件
- (void)clickToTop
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
    //atScrollPosition:UITableViewScrollPositionTop
    // animated:YES];
}
//标签关注
- (void)attentionStateRequest {
    NSDictionary * dic = [self parametersForDic:@"accountCollectTag" parameters:@{ACCOUNT_PASSWORD, @"id": _markDataDict[@"id"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[self showTableHeaderView:[dic objectForKey:@"data"]];
            //[_markDataDict setObject:@"1" forKey:@"isLike"];
            //_headerView.dataDict = _markDataDict;
            _isAttentionCountUpdate = YES;
            [self loadTagDetailRequest];
        }
    } andFailureBlock:^{
        
    }];
}
//标签取消关注
- (void)cancelAttentionStateRequest {
    NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedTag" parameters:@{ACCOUNT_PASSWORD, @"id": _markDataDict[@"id"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[self showTableHeaderView:[dic objectForKey:@"data"]];
           // [_markDataDict setObject:@"0" forKey:@"isLike"];
            //_headerView.dataDict = _markDataDict;
            _isAttentionCountUpdate = YES;
            [self loadTagDetailRequest];
        }
    } andFailureBlock:^{
        
    }];
}
//标签明细
- (void)loadTagDetailRequest {
    NSDictionary * dic = [self parametersForDic:@"getTagDetail" parameters:@{ACCOUNT_PASSWORD, @"name": _tagName}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _markDataDict = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
            [self showTableHeaderView];
            if (_isAttentionCountUpdate == NO) {
                [self.tableView headerBeginRefreshing];
            }
            
        }
    } andFailureBlock:^{
        
    }];
}
//最新话题列表
- (void)loadNewDataListRequest
{
    _page = 0;
    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042", @"tags": _markDataDict[@"name"], @"start":@"0", @"count":[NSString stringWithFormat:@"%d",_count], @"order": @"postid"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        _topicCount = @"0";
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            _noDataView.hidden = YES;
            _topicCount = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
            
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
        [self resetHeaderViewAttentionCount];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    _page += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":@"251", @"order": @"postid", @"tags": _markDataDict[@"name"], @"start":[NSString stringWithFormat:@"%d",_page], @"count":[NSString stringWithFormat:@"%d",_count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        _topicCount = @"0";
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                _topicCount = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
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
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            _page -= NumOfItemsForZuji;
        }else{
            _page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
        [self resetHeaderViewAttentionCount];
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        _page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
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
