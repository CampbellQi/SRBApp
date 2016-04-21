//
//  BrowsingHistoryViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BrowsingHistoryViewController.h"
#import "MJRefresh.h"
#import "BrowsingHistoryCell.h"
#import "SecondSubclassDetailViewController.h"
#import "AppDelegate.h"
#import "TopicDetailListController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface BrowsingHistoryViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *idArray;      //存放id
@property (nonatomic, strong) NSMutableArray *allIdArray;   //存放全部id


@end

@implementation BrowsingHistoryViewController
{
    UITableView * tableview;

    BOOL isBack;
    BOOL search;
    UISearchBar * mySearchBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    self.title = @"浏览历史";
    [self customInit];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
}

- (void)refresh
{
    [self headerRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[tableview setEditing:NO];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        //[self.mineFragmentVC postHistory];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    self.backButton = backBtn;
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.dataArray = [NSMutableArray array];

    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(0, 0, 55, 25);
    orderBtn.backgroundColor = WHITE;
    orderBtn.layer.cornerRadius = CGRectGetHeight(orderBtn.frame) * 0.5;
    orderBtn.layer.masksToBounds = YES;
    self.editButton = orderBtn;
    orderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [orderBtn setTitle:@"清 空" forState:UIControlStateNormal];
//    [orderBtn setTitle:@"编 辑" forState:UIControlStateNormal];
//    [orderBtn setTitle:@"取 消" forState:UIControlStateSelected];
    [orderBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:orderBtn];

    
//    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleteBtn.frame = CGRectMake(0, 0, 80, 25);
//    deleteBtn.backgroundColor = WHITE;
//    deleteBtn.layer.cornerRadius = 2;
//    deleteBtn.layer.masksToBounds = YES;
//    self.deleteButton = deleteBtn;
//    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [deleteBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteSomeUsers) forControlEvents:UIControlEventTouchUpInside];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"搜索";
    [self.view addSubview:mySearchBar];
    
    for (UIView * view in mySearchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.tableHeaderView = mySearchBar;
    [self.view addSubview: tableview];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y + 40, tableview.frame.size.width, tableview.frame.size.height)];
    noData.hidden = YES;
    [tableview addSubview:noData];
    

}
//编辑
//- (void)editAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [tableview setEditing:YES animated:YES];
//        [self updateButtonsToMatchTableState];
//    }else{
//        [tableview setEditing:NO animated:YES];
//        [self updateButtonsToMatchTableState];
//    }
//}
//
//
////无数据时
//- (void)noDataBase{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
//    self.editButton.selected = NO;
//    tableview.editing = NO;
//}


#pragma mark - Updating button state

- (void)updateButtonsToMatchTableState
{
    if (tableview.editing)
    {
        // Show the option to cancel the edit.
        [self updateDeleteButtonTitle];
        
        // Show the delete button.
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.deleteButton];
    }
    else
    {
        // Not in editing mode.
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
        
        // Show the edit button, but disable the edit button if there's nothing to edit.
        if (self.dataArray.count > 0)
        {
            self.editButton.enabled = YES;
        }
        else
        {
            self.editButton.enabled = NO;
        }
    }
}


- (void)updateDeleteButtonTitle
{
    // Update the delete button's title, based on how many items are selected
    NSArray *selectedRows = [tableview indexPathsForSelectedRows];
    
//    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (noItemsAreSelected)
    {

        [self.deleteButton setTitle:@"清 空" forState:UIControlStateNormal
         ];
    }
    else
    {
        NSString *titleFormatString =
        NSLocalizedString(@"删除 (%d)", @"Title for delete button with placeholder for number");

        [self.deleteButton setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
    }
}
#pragma mark - UIsearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self urlRequest];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        mySearchBar.text = @"";
        [self urlRequest];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//        
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//        
//    }
    
}


#pragma mark - 刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequest];
//        [self noDataBase];
    });
}
#pragma mark - 加载更多
- (void)footerRefresh
{
    int tempCount = 0;
    if (_dataArray.count < 10) {
        tempCount = (int)_dataArray.count;
    }else{
        tempCount = NumOfItemsForZuji;
    }
    page += tempCount;
    NSDictionary * dic = [self parametersForDic:@"getPostListByHistory" parameters:@{ACCOUNT_PASSWORD,@"dealType": @"3",@"start":[NSString stringWithFormat:@"%d",page], @"keyword":mySearchBar.text,@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BrowsingHistoryModel * browsingHistoryModel = [[BrowsingHistoryModel alloc]init];
                [browsingHistoryModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistoryModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= tempCount;
                    break;
                }
            }
            [tableview reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= tempCount;
        }else{
            page -= tempCount;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= tempCount;
        [tableview footerEndRefreshing];
    }];
}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowsingHistoryCell * cell = [BrowsingHistoryCell browsingHeistoryCellWithTableView:tableview];
    cell.browsingHistoryModel = self.dataArray[indexPath.row];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//    
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BrowsingHistoryModel * browsingHistoryModel = [self.dataArray objectAtIndex:indexPath.row];
        [self.dataArray removeObject:browsingHistoryModel];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteRequest:browsingHistoryModel];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableview.isEditing) {
        [self updateButtonsToMatchTableState];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
//        BrowsingHistoryModel * browsingModel = self.dataArray[indexPath.row];
//        SecondSubclassDetailViewController * detailVC = [[SecondSubclassDetailViewController alloc]init];
//        detailVC.idNumber = browsingModel.ID;
//        [self.navigationController pushViewController:detailVC animated:YES];
        
        BrowsingHistoryModel * browsingModel = self.dataArray[indexPath.row];
        TopicDetailListController *vc = [[TopicDetailListController alloc] init];
        vc.modelId = browsingModel.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - post请求
- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"getPostListByHistory" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"dealType": @"3",@"keyword":mySearchBar.text,@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            for (int i = 0; i< temparr.count; i++) {
                BrowsingHistoryModel * browsingHistroyModel = [[BrowsingHistoryModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [browsingHistroyModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistroyModel];
            }
            noData.hidden = YES;
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [tableview reloadData];
        [tableview headerEndRefreshing];
//        self.editButton.selected = NO;
        if (self.dataArray.count > 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } andFailureBlock:^{
        page = 0;
        noData.hidden = NO;
        [self.dataArray removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
        self.navigationItem.rightBarButtonItem = nil;
//        self.editButton.selected = NO;
    }];

}
-(void)deleteRequest:(BrowsingHistoryModel *)browsingHistoryModel {
    NSDictionary * dic = [self parametersForDic:@"accountDeletePostHistory" parameters:@{ACCOUNT_PASSWORD,@"id":browsingHistoryModel.ID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            [self urlRequest];
            if (_dataArray.count == 0) {
                noData.hidden = NO;
            }
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        if (self.dataArray.count > 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - 删除全部操作

//- (void)deleteSomeUsers
//{
//    NSString *alertTitle;
//    if ([tableview indexPathsForSelectedRows].count == 0) {
//        alertTitle = @"确定清空？";
//    }else if ([tableview indexPathsForSelectedRows].count == 1) {
//        alertTitle = @"确定删除？";
//    }else{
//        alertTitle = @"确定删除？";
//    }
//    UIAlertView *allAlertView = [[UIAlertView alloc] initWithTitle:alertTitle
//                                                           message:nil
//                                                          delegate:self
//                                                 cancelButtonTitle:@"取消"
//                                                 otherButtonTitles:@"确定", nil];
//    [allAlertView show];
//}

- (void)clean
{
    UIAlertView *allAlertView = [[UIAlertView alloc] initWithTitle:@"确定清空?"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
    [allAlertView show];
}

- (void)delAllHistory
{
    NSDictionary * dic = [self parametersForDic:@"accountClearPostHistory" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequest];
//            [self noDataBase];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            [self noDataBase];
        }
        [tableview headerEndRefreshing];
        self.navigationItem.rightBarButtonItem = nil;
    } andFailureBlock:^{
        [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self delAllHistory];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        if ([tableview indexPathsForSelectedRows].count == 0) {
//            NSLog(@"删除全部 == %ld",buttonIndex);
//            [self delAllHistory];
//            self.navigationItem.rightBarButtonItem = nil;
//            // Tell the tableView that we deleted the objects.
//            // Because we are deleting all the rows, just reload the current table section
//            [tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            //选中的rows
//            NSArray *selectedRows = [tableview indexPathsForSelectedRows];
//            self.idArray = [[NSMutableArray alloc] init];
//            for (int i = 0 ; i < selectedRows.count; i++) {
//                NSIndexPath * index = selectedRows[i];
//                BrowsingHistoryModel * deleModel = self.dataArray[index.row];
//                [self.idArray addObject:deleModel.ID];
//            }
//            NSString *idStr = [self jointString:self.idArray];
//            NSDictionary * dic = [self parametersForDic:@"accountDeletePostHistory" parameters:@{ACCOUNT_PASSWORD,@"id":idStr}];
//
//            [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//                tableview.editing = NO;
//                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
//                self.editButton.selected = NO;
//                [self headerRefresh];
//            } andFailureBlock:^{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//                tableview.editing = NO;
//                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
//                self.editButton.selected = NO;
//                [self headerRefresh];
//            }];
//            
//            // Build an NSIndexSet of all the objects to delete, so they can all be removed at once.
//            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
//            for (NSIndexPath *selectionIndex in selectedRows)
//            {
//                [indicesOfItemsToDelete addIndex:selectionIndex.row];
//            }
//            // Delete the objects from our data model.
//            
//            [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
//            
//            // Tell the tableView that we deleted the objects
//            [tableview deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
//}
//
////拼接id
//- (NSString *)jointString:(NSMutableArray *)strArr
//{
//    NSString *str;
//    NSString *str1;
//    if (strArr.count == 1) {
//        str = [strArr objectAtIndex:0];
//        return str;
//    }else{
//        for (int i = 0; i < strArr.count; i ++) {
//            if (i == 0) {
//                str1 = [strArr objectAtIndex:i];
//            }
//            if (i == strArr.count - 1) {
//                return str;
//            }
//            str = [str1 stringByAppendingString:[NSString stringWithFormat:@",%@",[strArr objectAtIndex:i+1]]];
//            str1 = str;
//        }
//        return str;
//    }
//}
//
//
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Update the delete button's title based on how many items are selected.
//    [self updateDeleteButtonTitle];
//}

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
