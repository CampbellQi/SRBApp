//
//  TopicDetailSPListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TopicDetailSPListController.h"
#import "TopicDetailSPListCell.h"

@interface TopicDetailSPListController ()
{
    NSInteger _selectedIndex;
    NSArray *_dataArray;
}
@end

@implementation TopicDetailSPListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"TopicDetailSPListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TopicDetailSPListCell"];
    self.tableView.tableFooterView = [UIView new];
    self.ContentView.layer.cornerRadius = 4.0f;
    self.ContentView.layer.masksToBounds = YES;
        
    _selectedIndex = -1;
}
#pragma mark- 数据
-(void)setTopicDetailModel:(TopicDetailModel *)topicDetailModel {
    _topicDetailModel = topicDetailModel;
    NSMutableArray *tempArray = [NSMutableArray new];
    NSArray *labelsArray = topicDetailModel.labels;
    for (NSDictionary *dic in labelsArray) {
        TPMarkModel *model = [TPMarkModel new];
        [model setValuesForKeysWithDictionary:dic];
        [tempArray addObject:model];
    }
    _dataArray = tempArray;
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailSPListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicDetailSPListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sourceModel = _dataArray[indexPath.row];
    cell.cover = self.topicDetailModel.cover;
    if (indexPath.row == _selectedIndex) {
        cell.selectedIV.hidden = NO;
    }else {
        cell.selectedIV.hidden = YES;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 119.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    self.selectedMarkModel = _dataArray[_selectedIndex];
    [self.tableView reloadData];
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
