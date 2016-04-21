//
//  MyVipTableViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyVipTableViewController.h"
#import "ZZMyAttentionVipModel.h"
#import "ZZMyAttentionCell.h"
#import "PersonalViewController.h"
#import "MJRefresh.h"
#import "GetColor16.h"

@interface MyVipTableViewController ()
@property (nonatomic, strong) UIButton *cancleAllItems;       //删除全部
@property (nonatomic, strong) UIButton *cancleItem;           //删除某个
@property (nonatomic, strong) NSMutableArray *userArray;      //存放user
@property (nonatomic, strong) NSMutableArray *allUserArray;   //存放全部user


@end

@implementation MyVipTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView headerBeginRefreshing];
    [self headerRefresh];
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
}

//按钮状态的切换
- (void)navigationEditButtonClick:(UIButton *)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setTitle:@"完 成" forState:UIControlStateNormal];
        [self creatCustomView];
        [UIView animateWithDuration:0.2 animations:^{
            self.customView.frame = CGRectMake(0, SCREEN_HEIGHT - 98, SCREEN_WIDTH, 42);
        }];
        [self.tableView setEditing:YES animated:YES];
    }else{
        sender.selected = NO;
        [sender setTitle:@"编 辑" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.customView.frame = CGRectMake(0, SCREEN_HEIGHT - 56, SCREEN_WIDTH, 42);
        }];
        
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - vip网络请求
- (void)urlRequestForVIP
{
    NSDictionary * dic = [self parametersForDic:@"getCollectedUserList" parameters:@{ACCOUNT_PASSWORD}];
    
    __block NSMutableArray *temArray = self.dataArray;
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result ==0) {
            [temArray removeAllObjects];
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            NSArray * array = [tempdic objectForKey:@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary * listDic = array[i];
                ZZMyAttentionVipModel * vipModel = [[ZZMyAttentionVipModel alloc]init];
                [vipModel setValuesForKeysWithDictionary:listDic];
                [temArray addObject:vipModel];
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
        }else{
            if (result == 4) {
                [temArray removeAllObjects];
                [temTableView reloadData];
                [temTableView headerEndRefreshing];
            }else{
                [AutoDismissAlert autoDismissAlert:@"请求失败!"];
            }
        }
    }];
}

//头部刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestForVIP];
    });
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray objectAtIndex:indexPath.row]isKindOfClass:[ZZMyAttentionVipModel class]]) {
        ZZMyAttentionVipModel * vipModel = self.dataArray[indexPath.row];
        CGRect rect = [vipModel.sign boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
        return rect.size.height + 53;
    }return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZMyAttentionCell * cell = [ZZMyAttentionCell settingCellWithTaableView:tableView];
    
    if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZZMyAttentionVipModel class]]) {
        ZZMyAttentionVipModel * vipModel = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.vipModel = vipModel;
    }
    
    return cell;
}


//编辑

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row == %ld",(long)indexPath.row + 10);
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSLog(@"indexPath.row == %ld",(long)indexPath.row);
        [self updateDeleteButtonTitle];
    }
    if (!tableView.editing) {
        PersonalViewController *psersonalVC = [[PersonalViewController alloc] init];
        ZZMyAttentionVipModel *model = [self.dataArray objectAtIndex:indexPath.row];
        psersonalVC.account = model.account;
        psersonalVC.nickname = model.nickname;
        [self.navigationController pushViewController:psersonalVC animated:YES];
    }
}

//删除全部关注人数
- (void)deleteAllUsers
{
    UIAlertView *allAlertView = [[UIAlertView alloc] initWithTitle:@"确定全部取消关注？"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
    allAlertView.tag = 520;
    [allAlertView show];
}

- (void)deleteSomeUsers
{
    NSString *alertTitle;
    if ([self.tableView indexPathsForSelectedRows].count == 0) {
        alertTitle = @"请选择要取消关注的选项";
    }
    if ([self.tableView indexPathsForSelectedRows].count == 1) {
        alertTitle = @"确定取消关注他(她)？";
    }else{
        alertTitle = @"确定取消关注他(她)？";
    }
    UIAlertView *someAlertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
    someAlertView.tag = 521;
    [someAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 520) {
        if (buttonIndex == 1) {
            NSLog(@"删除全部 == %lu",buttonIndex);
            
            self.allUserArray = [[NSMutableArray alloc] init];
            for (ZZMyAttentionVipModel *model in self.dataArray) {
                [self.allUserArray addObject:model.account];
            }
            NSString *allUserStr = [self jointString:self.allUserArray];
            NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedUser" parameters:@{@"user":allUserStr,ACCOUNT_PASSWORD}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }else if(result == 4){
                    
                }else{
                    NSLog(@"%d",result);
                    [AutoDismissAlert autoDismissAlert:@"请求失败"];
                }
            }];
            // Delete everything, delete the objects from our data model.
            [self.dataArray removeAllObjects];
            
            // Tell the tableView that we deleted the objects.
            // Because we are deleting all the rows, just reload the current table section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Vip" object:nil];
        }
    }
    if (alertView.tag == 521) {
        if (buttonIndex == 1) {
            //选中的rows
            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
            self.userArray = [[NSMutableArray alloc] init];
            for (int i = 0 ; i < selectedRows.count; i++) {
                NSIndexPath * index = selectedRows[i];
                ZZMyAttentionVipModel * vipModel = self.dataArray[index.row];
                [self.userArray addObject:vipModel.account];
            }
            NSString *userStr = [self jointString:self.userArray];
            NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedUser" parameters:@{@"user":userStr,ACCOUNT_PASSWORD}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKey:@"result"] intValue];
                if (result == 0) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }else if(result == 4){
                    
                }else{
                    NSLog(@"%d",result);
                    [AutoDismissAlert autoDismissAlert:@"请求失败"];
                }
            }];
            
            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }
            // Delete the objects from our data model.
            
            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
            
            // Tell the tableView that we deleted the objects
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Vip" object:nil];
        }
    }
}
//拼接id
- (NSString *)jointString:(NSMutableArray *)strArr
{
    NSString *str;
    NSString *str1;
    if (strArr.count == 1) {
        str = [strArr objectAtIndex:0];
        return str;
    }else{
        for (int i = 0; i < strArr.count; i ++) {
            if (i == 0) {
                str1 = [strArr objectAtIndex:i];
            }
            if (i == strArr.count - 1) {
                return str;
            }
            str = [str1 stringByAppendingString:[NSString stringWithFormat:@",%@",[strArr objectAtIndex:i+1]]];
            str1 = str;
        }
        return str;
    }
}


//底部删除视图
- (UIView *)creatCustomView
{
    NSLog(@"creatCustomView");
    if (!self.customView) {
        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 56, SCREEN_WIDTH, 42)];
        self.customView.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#f6f6f6"]];
        [self.parentViewController.view addSubview:self.customView];
        //删除全部
        self.cancleAllItems = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleAllItems.frame = CGRectMake(0, 0, 80, 40);
        self.cancleAllItems.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancleAllItems setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
        [self.cancleAllItems setTitle:@"删除全部" forState:UIControlStateNormal];
        [self.cancleAllItems addTarget:self action:@selector(deleteAllUsers) forControlEvents:UIControlEventTouchUpInside];
        [self.customView addSubview:self.cancleAllItems];
        //删除选中
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSString *titleFormatString =
        NSLocalizedString(@"删除 (%d)", @"Title for delete button with placeholder for number");
        
        self.cancleItem = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleItem.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 80, 40);
        self.cancleItem.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancleItem setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
        [self.cancleItem addTarget:self action:@selector(deleteSomeUsers) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleItem setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
        [self updateDeleteButtonTitle];
        [self.customView addSubview:self.cancleItem];
        
    }
    return self.customView;
}
//更新删除键人数
- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    NSString *titleFormatString =
    NSLocalizedString(@"删除 (%d)", @"Title for delete button with placeholder for number");
    [self.cancleItem setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
}

@end
