//
//  NewsCenterMainViewController.m
//  SRBApp
//  消息中心一级页面
//  Created by fengwanqi on 16/1/23.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "NewsCenterMainViewController.h"
#import "NewsCenterMainCell.h"
#import "NewsCenterViewController.h"
#import "AppDelegate.h"
#import "CommonView.h"
#import "NewsCenterTransationController.h"
#import "PersonalAttentionListController.h"

@interface NewsCenterMainViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NewsCenterMainCell *_propertyCell;
    NSArray *_dataArray;
    NSDictionary *_newsCountDict;
}
@end

@implementation NewsCenterMainViewController
- (void)viewWillAppear:(BOOL)animated
{
    //[self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
    [self loadNewsCountRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    UINib *nib = [UINib nibWithNibName:@"NewsCenterMainCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"NewsCenterMainCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"NewsCenterMainCell"];
    self.tableView.tableFooterView = [UIView new];
    _dataArray = @[@{@"image": @"mf_commentRevel", @"name": @"评论回复"}, @{@"image": @"mf_praise", @"name": @"赞我的"}, @{@"image": @"mf_transHelper", @"name": @"交易助手"}, @{@"image": @"mf_system", @"name": @"系统发现"}];
    
    _newsCountDict = [NSDictionary new];
    
    
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCenterMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCenterMainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.IV.image = [UIImage imageNamed:dict[@"image"]];
    cell.nameLbl.text = dict[@"name"];
    
    if ([self getCountWithName:dict[@"name"]]) {
        cell.countLbl.text = [self getCountWithName:dict[@"name"]];
        cell.countLbl.hidden = NO;
    }else {
        cell.countLbl.hidden = YES;
    }
    return cell;
}
-(NSString *)getCountWithName:(NSString *)name {
    NSString *count = nil;
    if ([name isEqualToString:@"评论回复"]) {
        count = _newsCountDict[@"newCommentMessageCount"];
    }else if ([name isEqualToString:@"赞我的"]){
        count = _newsCountDict[@"newLikeMessageCount"];
    }else if ([name isEqualToString:@"交易助手"]){
        count = _newsCountDict[@"newOrderMessageCount"];
    }else if ([name isEqualToString:@"系统发现"]){
        count = _newsCountDict[@"newSystemMessageCount"];
    }
    if (count && count.length && ![count isEqualToString:@"0"]) {
        return count;
    }else {
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(_propertyCell.frame);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[NewsCenterViewController alloc] init];
    vc.title = self.title;
    NSString *newsType = @"";
    switch (indexPath.row) {
        case 0:
            newsType = @"comment";
            ((NewsCenterViewController *)vc).messageType = newsType;
            break;
        case 1:
            newsType = @"like";
            ((NewsCenterViewController *)vc).messageType = newsType;
            break;
        case 2:
            newsType = @"order";
            vc = [[NewsCenterTransationController alloc] init];
            ((NewsCenterTransationController *)vc).messageType = newsType;
            //vc = [[PersonalAttentionListController alloc] init];
            break;
        case 3:
            newsType = @"system";
            ((NewsCenterViewController *)vc).messageType = newsType;
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 网络请求
- (void)loadNewsCountRequest
{
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountGetNewMessageCount" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _newsCountDict = [dic objectForKey:@"data"];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView reloadData];
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
