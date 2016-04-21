//
//  SquareDetailSearchViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SquareDetailSearchViewController.h"
#import "SecondSubclassDetailViewController.h"
#import <UIImageView+WebCache.h>
#import "MJRefresh.h"
#import "NoDataView.h"
#import "BussinessModel.h"
#import "BuyCell.h"
#import "SellCell.h"
#import "AppDelegate.h"
static int page = 0;
@interface SquareDetailSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end

@implementation SquareDetailSearchViewController
{
    UITableView * tableview;
    UISearchBar * mySearchBar;
    NoDataView * imageview;
    NSMutableArray * dataArray; //商品数组
    UIView * searchBGView;
    int buttonOldIndex;
    MyImgView * priceImg;
    BOOL isJiangXu;
    int tapNum;
    NSArray * orderArr;
    UIActivityIndicatorView * activity;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发现宝贝";
    [self customInit];
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    buttonOldIndex = 10000;
    orderArr = @[@"",@"sales",@"price-asc",@"comments",@"favorites"];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - 144)];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = 130;
    tableview.tableFooterView = [[UIView alloc]init];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    [self.view addSubview: tableview];
    
    tableview.backgroundColor = [UIColor clearColor];
    
    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    [self.view addSubview:imageview];
    
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"寻找宝贝";
    mySearchBar.text = self.keyStr;
    
    for (UIView * view in mySearchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    searchBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    searchBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [self.view addSubview:searchBGView];
    [searchBGView addSubview:mySearchBar];
    
    UIView * shaixuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    shaixuanView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
    shaixuanView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    shaixuanView.layer.masksToBounds = NO;
    shaixuanView.layer.shadowOpacity = 0.8;
    shaixuanView.layer.shadowOffset = CGSizeMake(4, 3);
    [self.view addSubview:shaixuanView];
    NSArray * titleArr = @[@"最新",@"销量",@"价格",@"评价",@"收藏"];
    for (int i = 0; i < 5; i++) {
        TabButton * tapBtn = [TabButton buttonWithType:UIButtonTypeCustom];
        [tapBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
        tapBtn.titleLabel.font = SIZE_FOR_14;
        [tapBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
        [tapBtn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        
        tapBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        tapBtn.frame = CGRectMake((i + 1) * (SCREEN_WIDTH / 6) - 20, 10, 40, 20);
        tapBtn.frame = CGRectMake(i * (SCREEN_WIDTH / 5), 10, SCREEN_WIDTH / 5, 20);
        if (i == 0) {
            tapBtn.selected = YES;
        }
        if (i == 2) {
            priceImg = [[MyImgView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH / 5 - 40)/2 + 30, 3, 9, 14)];
            priceImg.image = [UIImage imageNamed:@"ranking_arrow_gray2"];
            [tapBtn addSubview:priceImg];
        }
        tapBtn.contentEdgeInsets = UIEdgeInsetsMake(0,(SCREEN_WIDTH / 5 - 40)/2, 0, 0);
        tapBtn.tag = i + 10000;
        [shaixuanView addSubview:tapBtn];
        [tapBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchDown];
    }
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activity.color = RGBCOLOR(223, 0, 85, 1);
    activity.center = tableview.center;
    [activity setHidesWhenStopped:YES];
    [tableview addSubview:activity];
}

- (void)selectedBtn:(UIButton *)sender
{
    [self changeIndex:buttonOldIndex newIndex:(int)sender.tag];
}

- (void)changeIndex:(int)oldIndex newIndex:(int)newIndex
{
    [activity startAnimating];
    if (newIndex == 10002) {
        if (isJiangXu == NO) {
            priceImg.image = [UIImage imageNamed:@"ranking_arrow_red"];
            isJiangXu = YES;
        }else{
            priceImg.image = [UIImage imageNamed:@"ranking_arrow_gray"];
            isJiangXu = NO;
        }
    }else{
        priceImg.image = [UIImage imageNamed:@"ranking_arrow_gray2"];
        isJiangXu = NO;
    }
    UIButton * oldBtn = (UIButton *)[self.view viewWithTag:oldIndex];
    UIButton * newBtn = (UIButton *)[self.view viewWithTag:newIndex];
    [oldBtn setSelected:NO];
    [newBtn setSelected:YES];
    [dataArray removeAllObjects];
    [tableview reloadData];
    buttonOldIndex = (int)newIndex;
    [self urlRequestForSearch];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

#pragma mark - 搜索请求
- (void)urlRequestForSearch
{
    if (self.keyStr == nil) {
        self.keyStr = @"";
    }
    if (self.categoryID == nil) {
        self.categoryID = @"";
    }
    NSString * orderStr = orderArr[buttonOldIndex - 10000];
    if (buttonOldIndex - 10000 == 2) {
        if (isJiangXu == YES) {
            orderStr = @"price-asc";
        }else{
            orderStr = @"price-desc";
        }
    }
    for (int i = 0 ; i < 5; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
        btn.userInteractionEnabled = NO;
    }
    NSDictionary * dic;
    //熟人圈搜索
    if ([self.searchState isEqualToString:@"relation"]) {
        dic = [self parametersForDic:@"getPostListByRelation" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
    }else if ([self.searchState isEqualToString:@"circle"]){//关系圈搜索
        dic = [self parametersForDic:@"getPostListByCircle" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
    }else{
        if (self.categoryID == nil || [self.categoryID isEqualToString:@""] || self.categoryID.length == 0) {
            self.categoryID = @"0";
        }
        dic = [self parametersForDic:@"getPostListByCategory" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
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
            imageview.hidden = YES;
        }else if ([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        [activity stopAnimating];
        [tableview reloadData];
        page = 0;
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
        imageview.hidden = NO;
        [dataArray removeAllObjects];
        [tableview reloadData];
        page = 0;
        [tableview headerEndRefreshing];
    }];
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestForSearch];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    if (self.keyStr == nil) {
        self.keyStr = @"";
    }
    if (self.categoryID == nil) {
        self.categoryID = @"";
    }
    NSString * orderStr = orderArr[buttonOldIndex - 10000];
    if (buttonOldIndex - 10000 == 2) {
        if (isJiangXu == YES) {
            orderStr = @"price-asc";
        }else{
            orderStr = @"price-desc";
        }
    }
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    //熟人圈
    if ([self.searchState isEqualToString:@"relation"]) {
        dic = [self parametersForDic:@"getPostListByRelation" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
    }else if ([self.searchState isEqualToString:@"circle"]){//关系圈
        dic = [self parametersForDic:@"getPostListByCircle" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
    }else{//随便逛逛
        dic = [self parametersForDic:@"getPostListByCategory" parameters:@{@"keyword": self.keyStr,ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"categoryID":self.categoryID,@"order":orderStr,@"type":@"0",@"dealType":@"0"}];
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
            imageview.hidden = YES;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    BussinessModel * bussinessModel = dataArray[indexPath.row];
    SecondSubclassDetailViewController * detailVC = [[SecondSubclassDetailViewController alloc]init];
    detailVC.idNumber = bussinessModel.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    tableview.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//    searchBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//    AppDelegate * app = APPDELEGATE;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    AppDelegate * app = APPDELEGATE;
//
//    if (velocity.y > 0) {
//        tableview.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
//        searchBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    }else if(velocity.y < 0){
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        tableview.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
//        searchBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//    }
//}

#pragma mark - UIsearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyStr = searchBar.text;
    [self urlRequestForSearch];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    self.keyStr = searchText;
//    //[self urlRequestForSearch];
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
