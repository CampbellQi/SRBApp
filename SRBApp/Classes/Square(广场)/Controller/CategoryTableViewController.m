//
//  CategoryTableViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "CategoryTableViewController.h"
#import <UIImageView+WebCache.h>
#import "GroupModel.h"
#import "SquareSearchCell.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController
{
    NSMutableArray * groupArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    groupArray = [NSMutableArray array];

    [self urlRequest];
}

- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"123"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                GroupModel * groupModel = [[GroupModel alloc]init];
                [groupModel setValuesForKeysWithDictionary:tempdic];
                [groupArray addObject:groupModel];
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseID = @"category";
    SquareSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SquareSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    GroupModel * groupModel = groupArray[indexPath.row];
    cell.categoryLabel.text = groupModel.categoryName;
    [cell.logoImg sd_setImageWithURL:[NSURL URLWithString:groupModel.pic] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.logoImg.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.categoryDelegate respondsToSelector:@selector(didSelectRow:)]) {
        [self.categoryDelegate didSelectRow:indexPath];
    }
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

@end
