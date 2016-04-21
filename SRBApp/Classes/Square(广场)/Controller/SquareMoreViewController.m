//
//  SquareMoreViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SquareMoreViewController.h"
#import "MJRefresh.h"
#import "BuyCell.h"
#import "SellCell.h"
#import "BussinessModel.h"
#import <UIImageView+WebCache.h>
#import "SecondSubclassDetailViewController.h"
#import "AppDelegate.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface SquareMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SquareMoreViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray; //商品数组
    BOOL isBack;
    NoDataView * noData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customInit];
}

- (void)backBtn:(id)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    self.navigationItem.title = self.titleStr;
    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = 130;
    tableview.tableFooterView = [[UIView alloc]init];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview: tableview];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    noData.hidden = YES;
    [tableview addSubview:noData];

}

#pragma mark - 搜索请求
- (void)urlRequestForSearch
{
    NSDictionary * dic;
    NSString * order;
    if ([self.keyStr isEqualToString:@"0"]) {
        order = @"best";
    }else{
        order = @"";
    }
    //熟人圈
    if ([self.team isEqualToString:@"circle"]) {
        dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count],@"order":order}];
    }else if([self.team isEqualToString:@"relation"]){//关系圈
        dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count],@"order":order}];
    }else{//随便逛逛
        dic = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    }
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i =0; i <temparrs.count; i++) {
                NSDictionary * tempDic = temparrs[i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempDic];
                [dataArray addObject:bussinessModel];
            }
            noData.hidden = YES;
        }else if ([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        noData.hidden = NO;
        [dataArray removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
    }];
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestForSearch];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic;
//    = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{@"keyword":self.keyStr,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    NSString * order;
    if ([self.keyStr isEqualToString:@"0"]) {
        order = @"best";
    }else{
        order = @"";
    }
    if ([self.team isEqualToString:@"circle"]) {
        dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",count],@"order":order}];
    }else if([self.team isEqualToString:@"relation"]){
        dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",count],@"order":order}];
    }else{
        dic = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"dealType":@"0",@"categoryID":self.keyStr,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",count]}];
    }
   
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            noData.hidden = YES;
            [tableview reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [tableview footerEndRefreshing];
    }];
    
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
//        BuyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!cell) {
//            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
//        cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
//        cell.thingimage.clipsToBounds = YES;
//        cell.titleLabel.text = [dataArray[indexPath.row] title];
//        cell.detailLabel.text = [dataArray[indexPath.row] model_description];
//        cell.signImage.image = [UIImage imageNamed:@"maisignNew.png"];
//        cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [dataArray[indexPath.row]nickname]];
//        cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
//        return cell;
//    }
//    SellCell * cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
//    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
//    cell.thingimage.clipsToBounds = YES;
//    cell.titleLabel.text = [dataArray[indexPath.row] title];
//    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dataArray[indexPath.row] marketPrice]];
//    [cell.priceLabel sizeToFit];
//    double a = [[dataArray[indexPath.row]marketPrice] doubleValue];
//    double b = [[dataArray[indexPath.row]bangPrice] doubleValue];
//    cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
//    cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [dataArray[indexPath.row]nickname]];
//    cell.oldPrice.frame = CGRectMake(cell.priceLabel.frame.origin.x + cell.priceLabel.frame.size.width + 9, cell.priceLabel.frame.origin.y + 3, 120, 12);
//    cell.oldPrice.text = [NSString stringWithFormat:@"￥%@",[dataArray[indexPath.row]bangPrice]];
//    [cell.oldPrice sizeToFit];
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(cell.oldPrice.frame.origin.x, cell.oldPrice.frame.origin.y + 6, cell.oldPrice.frame.size.width, 1)];
//    view.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
//    [cell addSubview:view];
//    if (a >= b) {
//        cell.oldPrice.hidden = YES;
//        view.hidden = YES;
//        cell.zhekouLabel.hidden = YES;
//        cell.postLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x, cell.priceLabel.frame.origin.y + cell.priceLabel.frame.size.height + 2, 30, 16);
//        cell.image.hidden = YES;
//    }else{
//        cell.zhekouLabel.text = [NSString stringWithFormat:@"%.1f折", a/b * 10];
//    }
//    
//    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
//        cell.postLabel.text = @"包邮";
//    }
//    else
//    {
//        cell.postLabel.hidden = YES;
//    }
//    cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
//    return cell;
    BussinessModel * bussinessModel = dataArray[indexPath.row];
    if ([bussinessModel.dealName isEqualToString:@"想买"]) {
        BuyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.bussinessModel = bussinessModel;
        return cell;
    }
    SellCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell.bussinessModel = bussinessModel;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SecondSubclassDetailViewController * detailVC = [[SecondSubclassDetailViewController alloc]init];
    BussinessModel * bussModel = [dataArray objectAtIndex:indexPath.row];
    detailVC.idNumber = bussModel.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
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
