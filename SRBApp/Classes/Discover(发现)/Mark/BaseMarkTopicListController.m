//
//  BaseMarkTopicListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseMarkTopicListController.h"
#import "MarkTopicListCell.h"

@interface BaseMarkTopicListController ()
{
    MarkTopicListCell *_propertyCell;
}
@end

@implementation BaseMarkTopicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 0;
    _count = NumOfItemsForZuji;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self setUpView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    UINib *nib = [UINib nibWithNibName:@"MarkTopicListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MarkTopicListCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"MarkTopicListCell"];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //_noDataView.width = SCREEN_WIDTH;
    //_noDataView.center = CGPointMake(self.tableView.width/2, self.tableView.height/2);
}
-(void)setUpView {
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
}
#pragma mark- 事件
-(void)avaterIVClicked:(UIGestureRecognizer *)gr {
    BussinessModel *model = _dataArray[gr.view.tag - 100];
    PersonalViewController * personVC = [[PersonalViewController alloc] init];
    personVC.account = model.account;
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MarkTopicListCell";
    MarkTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterIVClicked:)]];
//    }
    
    [cell.avaterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avaterIVClicked:)]];
    cell.avaterIV.tag = 100 + indexPath.row;
    cell.bussinessModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //MarkTopicListCell *cell = (MarkTopicListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //[_propertyCell layoutIfNeeded];
    //CGFloat height = [_propertyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return CGRectGetHeight(_propertyCell.frame) * (SCREEN_WIDTH / 320.0);
    //return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailListController *detail = [[TopicDetailListController alloc] init];
    detail.sourceModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
}
-(void)loadNewDataListRequest {

}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
-(void)loadMoreDataListRequest {

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
