//
//  NewAttentionViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewAttentionViewController.h"
#import "ZZMyAttentionInfoModel.h"
#import "DetailActivityViewController.h"
#import "ZZMyAttentionCell.h"
#import "MJRefresh.h"
#import "GetColor16.h"
#import "SecondSubclassDetailViewController.h"
#import "AppDelegate.h"
#import "TopicDetailListController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface NewAttentionViewController ()<UISearchBarDelegate>
{
    BOOL isBack;
    MBProgressHUD * hud;
    UISearchBar * mySearchBar;
    
    
}
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray *idArray;      //存放id
@property (nonatomic, strong) NSMutableArray *allIdArray;   //存放全部id
@end

@implementation NewAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    isBack = NO;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    self.backButton = backBtn;
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
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
//    [orderBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:orderBtn];
    
//    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleteBtn.frame = CGRectMake(0, 0, 80, 25);
//    deleteBtn.backgroundColor = WHITE;
//    deleteBtn.layer.cornerRadius = 2;
//    deleteBtn.layer.masksToBounds = YES;
//    self.deleteButton = deleteBtn;
//    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [deleteBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteSomeUsers) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = mySearchBar;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 20, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    noData.hidden = YES;
    [self.tableView addSubview:noData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
}

//编辑
//- (void)editAction:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [self.tableView setEditing:YES animated:YES];
//        [self updateButtonsToMatchTableState];
//    }else{
//        [self.tableView setEditing:NO animated:YES];
//        [self updateButtonsToMatchTableState];
//    }
//    
//}
//
////无数据时
//- (void)noDataBase{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
//    self.editButton.selected = NO;
//    self.tableView.editing = NO;
//}


#pragma mark - Updating button state

//- (void)updateButtonsToMatchTableState
//{
//    if (self.tableView.editing)
//    {
//        // Show the option to cancel the edit.
//        [self updateDeleteButtonTitle];
//        
//        // Show the delete button.
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.deleteButton];
//    }
//    else
//    {
//        // Not in editing mode.
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
//        
//        // Show the edit button, but disable the edit button if there's nothing to edit.
//        if (self.dataArray.count > 0)
//        {
//            self.editButton.enabled = YES;
//        }
//        else
//        {
//            self.editButton.enabled = NO;
//        }
//    }
//}
//
//
//- (void)updateDeleteButtonTitle
//{
//    // Update the delete button's title, based on how many items are selected
//    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
//    
//    //    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
//    BOOL noItemsAreSelected = selectedRows.count == 0;
//    
//    if (noItemsAreSelected)
//    {
//        //        self.deleteButton.title = NSLocalizedString(@"Delete All", @"");
//        [self.deleteButton setTitle:@"清 空" forState:UIControlStateNormal
//         ];
//    }
//    else
//    {
//        NSString *titleFormatString =
//        NSLocalizedString(@"删除 (%d)", @"Title for delete button with placeholder for number");
//        //        self.deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
//        [self.deleteButton setTitle:[NSString stringWithFormat:titleFormatString, selectedRows.count] forState:UIControlStateNormal];
//    }
//}

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
    
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        //[self.mineFragmentVC postCollect];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIsearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self urlRequestForVIP];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        mySearchBar.text = @"";
        [self urlRequestForVIP];
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


#pragma mark - info网络请求
- (void)urlRequestForVIP
{
    NSDictionary * dic = [self parametersForDic:@"getCollectedPostList" parameters:@{ACCOUNT_PASSWORD, @"keyword":mySearchBar.text, @"dealType": @"3"}];
    
    __block NSMutableArray *temArray = self.dataArray;
    __block UITableView *temTableView = self.tableView;
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [temArray removeAllObjects];
        if (result ==0) {
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            NSArray * array = [tempdic objectForKey:@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary * listDic = array[i];
                ZZMyAttentionInfoModel * infoModel = [[ZZMyAttentionInfoModel alloc]init];
                [infoModel setValuesForKeysWithDictionary:listDic];
                [temArray addObject:infoModel];
            }
            noData.hidden = YES;
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];

        }else{
            if (result == 4) {
                noData.hidden = NO;
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                noData.hidden = NO;
            }
        }
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        if (self.dataArray.count > 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
        }else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } andFailureBlock:^{
        [temArray removeAllObjects];
        noData.hidden = NO;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        
        self.navigationItem.rightBarButtonItem = nil;
    }];
    
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
    NSDictionary * dic = [self parametersForDic:@"getCollectedPostList" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page], @"keyword":mySearchBar.text,@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji], @"dealType": @"3"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                ZZMyAttentionInfoModel * zzmvipModel = [[ZZMyAttentionInfoModel alloc]init];
                [zzmvipModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:zzmvipModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= tempCount;
                    break;
                }
            }
            [self.tableView reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= tempCount;
        }else{
            page -= tempCount;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= tempCount;
        [self.tableView footerEndRefreshing];
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ZZMyAttentionInfoModel * infoModel = self.dataArray[indexPath.row];
    //    CGRect rect = [infoModel.descriptions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 87.5 - 15 - 12 - 60, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
    //    if (rect.size.height + 50 >= 90) {
    //        return rect.size.height + 50;
    //    }else{
    //        return 90;
    //    }
    return 90;
}

//头部刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestForVIP];
//        [self noDataBase];
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


//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZMyAttentionCell * cell = [ZZMyAttentionCell settingCellWithTaableView:tableView];
    ZZMyAttentionInfoModel * infoModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.infoModel = infoModel;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.isEditing) {
//        [self updateButtonsToMatchTableState];
//    }else{
    ZZMyAttentionInfoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.sourcemodule isEqualToString:@"usertopic"]) {
        TopicDetailListController *detail = [[TopicDetailListController alloc] init];
        detail.modelId = model.sourcevalue;
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
        detailAVC.idNumber = model.ID;
        [self.navigationController pushViewController:detailAVC animated:YES];
    }
    
//    }
}

#pragma mark - 删除操作

//- (void)deleteSomeUsers
//{
//    NSString *alertTitle;
//    if ([self.tableView indexPathsForSelectedRows].count == 0) {
//        alertTitle = @"确定清空？";
//    }else if ([self.tableView indexPathsForSelectedRows].count == 1) {
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
- (void)clean{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定清空?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)delAllHistory
{
    NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD,@"id":@"0"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequestForVIP];
//            [self noDataBase];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            [self noDataBase];
        }
        [self headerRefresh];
        self.navigationItem.rightBarButtonItem = nil;
    } andFailureBlock:^{
        [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self delAllHistory];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        if ([self.tableView indexPathsForSelectedRows].count == 0) {
//            NSLog(@"删除全部 == %ld",buttonIndex);
//            
//            [self delAllHistory];
//            self.navigationItem.rightBarButtonItem = nil;
//            // Tell the tableView that we deleted the objects.
//            // Because we are deleting all the rows, just reload the current table section
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            //选中的rows
//            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
//            self.idArray = [[NSMutableArray alloc] init];
//            for (int i = 0 ; i < selectedRows.count; i++) {
//                NSIndexPath * index = selectedRows[i];
//                ZZMyAttentionInfoModel * myattModel = self.dataArray[index.row];
//                [self.idArray addObject:myattModel.ID];
//            }
//            NSString *idStr = [self jointString:self.idArray];
//            NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD,@"id":idStr}];
//            
//            [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//                [self headerRefresh];
//            } andFailureBlock:^{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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
//            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
//}

//拼接id
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



//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Update the delete button's title based on how many items are selected.
//    [self updateDeleteButtonTitle];
//}


// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPat
//{
//    return YES;
//}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ZZMyAttentionInfoModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [self.dataArray removeObject:model];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteRequest:model];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)deleteRequest:(ZZMyAttentionInfoModel *)model {
    NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD,@"id":model.ID}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [self urlRequestForVIP];
            if (_dataArray.count == 0) {
                noData.hidden = NO;
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
    
    if (self.dataArray.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
@end
