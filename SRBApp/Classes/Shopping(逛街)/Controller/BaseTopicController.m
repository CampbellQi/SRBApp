//
//  BaseTopicController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseTopicController.h"
#import "TopicListCell.h"
#import "BussinessModel.h"

@interface BaseTopicController ()

@end

@implementation BaseTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
}
#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListCell *cell = (TopicListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CELL_HEIGHT + [cell.markView fittedSize].height - 24.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"TopicListCell";
    TopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
        //[cell.commentBtn addTarget:self action:@selector(goCommentListVC:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.praiseBtn addTarget:self action:@selector(praiseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentBtn.hidden = NO;
        cell.praiseBtn.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.bussinessModel = [self.dataArray objectAtIndex:indexPath.row];
    [LayoutFrame showViewConstraint:cell.coverIV AttributeHeight:SCREEN_WIDTH / 320.0 * 228];
    [LayoutFrame showViewConstraint:cell.markView AttributeHeight:[cell.markView fittedSize].height];
    cell.commentBtn.tag = indexPath.row + 100;
    cell.praiseBtn.tag = indexPath.row + 200;
    
    //标签点击
    __block typeof(self) unself = self;
    cell.tagClickedBlock = ^(NSString *aTag) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = aTag;
        [unself.navigationController pushViewController:vc animated:YES];
    };
    //头像点击
    cell.avaterClickedBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [unself.navigationController pushViewController:personVC animated:YES];
    };
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailListController *detail = [[TopicDetailListController alloc] init];
    detail.backBlock = ^(void) {
        //重新设置点赞数量
        [self.tableView reloadData];
    };
    detail.deleteBlock = ^(BussinessModel *model){
        [self.dataArray removeObject:model];
        [self.tableView reloadData];
        
    };
    detail.sourceModal = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
-(void)loadNewDataListRequest{

}
-(void)loadMoreDataListRequest{

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
