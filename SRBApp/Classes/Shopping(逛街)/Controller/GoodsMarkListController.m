//
//  GoodsMarkController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodsMarkListController.h"
#import "GoodsMarkListCell.h"
#import "AppDelegate.h"
#import "MarkTopicListController.h"
#import "UIColor+Dice.h"
#import "MarkSearchListController.h"
#import "AllMarkListController.h"
#import "WQGuideView.h"

@interface GoodsMarkListController ()
{
//    NSMutableDictionary *_dataDict;
//    NSArray *_pinYinArray;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation GoodsMarkListController
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
    // Do any additional setup after loading the view from its nib.
    //显示引导页
    [[WQGuideView share] showAtIndex:2 GuideViewRemoveBlock:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];
    [self loadNewDataListRequest];
}
#pragma mark- 页面
-(void)setUpView {
    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    //右导航
    UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    allBtn.frame = CGRectMake(0, 0, 30, 44);
    allBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allBtn];
    //导航栏
    float xSpace = 25;
    float height = 28;
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(xSpace, (44 - height)/2, SCREEN_WIDTH - xSpace * 5, height)];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, searchBgView.width - 20, height)];
    [searchBgView addSubview:tf];
    searchBgView.layer.cornerRadius = height /2 ;
    searchBgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    tf.placeholder = @"搜索标签";
    tf.textAlignment = NSTextAlignmentLeft;
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    tf.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = searchBgView;
    tf.backgroundColor = [UIColor clearColor];
    
    tf.font = [UIFont systemFontOfSize:14];
    //隐藏键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];

}
#pragma mark- 数据
-(void)setDataArray:(NSMutableArray *)dataArray {
    NSMutableArray *tempArray1 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempArray2 = nil;
    for (int i=0; i<dataArray.count; i++) {
        if (i % 4 == 0) {
            tempArray2 = [NSMutableArray arrayWithCapacity:0];
            [tempArray1 addObject:tempArray2];
        }
        [tempArray2 addObject:[dataArray objectAtIndex:i]];
    }
    _dataArray = tempArray1;
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)allBtnClicked {
    AllMarkListController *markVC = [[AllMarkListController alloc] init];
    [self.navigationController pushViewController:markVC animated:YES];
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
#pragma mark- textfiled delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    MarkSearchListController *vc = [[MarkSearchListController alloc] init];
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:vc];
    //[self.navigationController presentViewController:nav animated:NO completion:nil];
    [self presentViewController:nav animated:NO completion:nil];
    return NO;
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"GoodsMarkListCell";
    GoodsMarkListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GoodsMarkListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.marksArray = [self.dataArray objectAtIndex:indexPath.row];
    cell.markViewTapBlock = ^(NSDictionary *dataDict) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = dataDict[@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGTH;
}
#pragma mark- 网络请求
-(void)loadNewDataListRequest {
    NSDictionary * dic = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"40", @"categoryID": @"250"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            self.dataArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [self.tableView reloadData];
        }
        
    } andFailureBlock:^{
        
    }];
}
//-(void)loadMoreDataRequest {
//
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
