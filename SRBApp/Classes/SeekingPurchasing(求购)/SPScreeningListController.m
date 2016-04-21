//
//  SPScreeningCollectionController.m
//  SRBApp
//  求购列表-筛选
//  Created by fengwanqi on 15/10/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define HEADER_HEIGHT 113
#define FOOTER_HEIGHT 69
#import "SPScreeningListController.h"
#import "SPScreeningListHeaderView.h"
#import "SPScreeningListCell.h"
#import "UIColor+Dice.h"

@interface SPScreeningListController ()
{
    NSDictionary *_selectedDict;
    SPScreeningListHeaderView *_headerView;
}
@end

@implementation SPScreeningListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadCityRequest];
    [self setUpView];
}
#pragma mark- 设置页面
-(void)setUpView {
    //设置页眉，页脚
    SPScreeningListHeaderView *headerView = [[SPScreeningListHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
    //注册
    UINib *nib = [UINib nibWithNibName:@"SPScreeningListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SPScreeningListCell"];
    //重置，确定按钮
    self.resetBtn.layer.cornerRadius = 0.5 * self.resetBtn.height;
    self.resetBtn.layer.borderColor = MAINCOLOR.CGColor;
    self.resetBtn.layer.borderWidth = 1.0f;
    self.ensureBtn.layer.cornerRadius = 0.5 * self.resetBtn.height;
    self.ensureBtn.layer.borderColor = MAINCOLOR.CGColor;
    self.ensureBtn.layer.borderWidth = 1.0f;
    //点击拦截
    [self.tableView addTapAction:@selector(hideView) forTarget:self];
}
#pragma mark- 事件
//在本页面添加一个拦截事件防止点击本页空白处消失
-(void)hideView {

}
- (IBAction)resetBtnClicked:(id)sender {
//    NSString *price1 = _headerView.price1TF.text;
//    NSString *price2 = _headerView.price2TF.text;
//    if (price1.length || price2.length || _selectedDict) {
//        if (self.completeBlock) {
//            self.completeBlock(@"", @"", @"");
//        }
//    }
    _headerView.price1TF.text = @"";
    _headerView.price2TF.text = @"";
    if (_selectedDict) {
        _selectedDict = nil;
        [self.tableView reloadData];
    }
}

- (IBAction)ensureBtnClicked:(id)sender {
    if (self.completeBlock) {
        NSString *minMoney = _headerView.price1TF.text;
        NSString *maxMoney = _headerView.price2TF.text;
        NSString *shopLand = @"";
        if (_selectedDict) {
            shopLand = _selectedDict[@"categoryName"];
        }
        self.completeBlock(minMoney, maxMoney, shopLand);
    }
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SPScreeningListCell"];
//    return cell;
    SPScreeningListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPScreeningListCell"];
    NSDictionary *dict = _dataArray[indexPath.section];
    NSArray *array = dict[@"subCategory"];
    
    NSArray *tempArray = [array subarrayWithRange:NSMakeRange(indexPath.row * 4, array.count > (indexPath.row + 1) * 4 ? 4 : array.count - indexPath.row * 4)];
    cell.dataArray = tempArray;
    cell.btnClickedBlock = ^(NSDictionary *dict) {
        _selectedDict = dict;
        [self.tableView reloadData];
    };
    if (_selectedDict) {
        long index = [tempArray indexOfObject:_selectedDict];
        [cell resetBtnBgAtIndex:index];
    }else {
        [cell resetBtnBgAtIndex:10];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = _dataArray[section];
    NSArray *array = dict[@"subCategory"];
    return array.count % 4 == 0 ? array.count / 4 : array.count / 4 + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = _dataArray[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 16 * 2, 30)];
    lbl.text = dict[@"categoryName"];
    lbl.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:lbl];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    iv.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
    return iv;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark- 网络请求
- (void)loadCityRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"2"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            _dataArray = temparrs;
            [self.tableView reloadData];
        }
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
