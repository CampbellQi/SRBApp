//
//  SquareSearchViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SquareSearchViewController.h"
#import "SquareSearchView.h"
#import "MJRefresh.h"
#import "CategoryTableViewController.h"
#import "AppDelegate.h"
#import "SquareDetailSearchViewController.h"
#import "GroupModel.h"
#import "SquareSearchCell.h"
#import <UIImageView+WebCache.h>


@interface SquareSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end
@implementation SquareSearchViewController
{
    UIView * searchView;
    CategoryTableViewController * categoryTableView;
    BOOL isBack;
    NSArray * categoryArr; //分类数组
    UITextField * searchText;
    UITableView * tableview;
    NSMutableArray * groupArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isBack = NO;
    [self customInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    //[app.application setStatusBarHidden:YES withAnimation:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
    //[app.application setStatusBarHidden:NO withAnimation:NO];
}

#pragma mark - 控件初始化
- (void)customInit
{
    groupArray = [NSMutableArray array];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 10, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"closeS"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    searchText = [[UITextField alloc]initWithFrame:CGRectMake(backBtn.frame.size.width + backBtn.frame.origin.x + 15, 5, SCREEN_WIDTH - 15 - 15 - 20 - 25 - 15 - 15, 30)];
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    searchText.font = SIZE_FOR_14;
    searchText.placeholder = @"寻找宝贝";
    searchText.returnKeyType=UIReturnKeyDone;
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"square_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.frame = CGRectMake(searchText.frame.size.width + searchText.frame.origin.x + 15, 10, 20, 20);
    
    
    UIView * serachBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    serachBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [serachBGView addSubview:searchText];
    [serachBGView addSubview:backBtn];
    [serachBGView addSubview:searchBtn];
    [self.view addSubview:serachBGView];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.rowHeight = 75;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableview];
    
    [self urlRequest];
    
//    categoryArr = @[@"鞋帽",@"服装",@"食品",@"护肤",@"箱包",@"数码",@"母婴",@"其他"];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self next:nil];
    return YES;
}

- (void)next:(UIButton *)sender
{
    SquareDetailSearchViewController * squareDetailVC = [[SquareDetailSearchViewController alloc]init];
    squareDetailVC.searchState = self.searchState;
    squareDetailVC.keyStr = searchText.text;
    [self.navigationController pushViewController:squareDetailVC animated:YES];
}

- (void)backBtn:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"123"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [groupArray removeAllObjects];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                GroupModel * groupModel = [[GroupModel alloc]init];
                [groupModel setValuesForKeysWithDictionary:tempdic];
                [groupArray addObject:groupModel];
            }
            [tableview reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate
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
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    GroupModel * groupModel = groupArray[indexPath.row];
    SquareDetailSearchViewController * squareDetailVC = [[SquareDetailSearchViewController alloc]init];
    if (searchText.text == nil || [searchText.text isEqualToString:@""] || searchText.text.length == 0) {
        
    }else{
        squareDetailVC.keyStr = searchText.text;
    }
    squareDetailVC.searchState = self.searchState;
    squareDetailVC.categoryID = groupModel.categoryID;
    [self.navigationController pushViewController:squareDetailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return groupArray.count;
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
