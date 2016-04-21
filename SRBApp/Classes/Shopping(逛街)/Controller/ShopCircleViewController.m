//
//  ShopCircleViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShopCircleViewController.h"
#import "BuyCell.h"
#import "SellCell.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "AppDelegate.h"
#import "ZZNavigationController.h"
#import "Singleton.h"
#import "ShoppingViewController.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface ShopCircleViewController ()

@end

@implementation ShopCircleViewController
{
    NSMutableArray * dataArray;
    NoDataView * noData;
    int _lastPosition;
    BOOL isHidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49)];
    //noData.center = self.tableView.center;
    noData.hidden = YES;
    [self.tableView addSubview:noData];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
    //        //分割线的位置不带偏移
    //        self.tableView.separatorInset = UIEdgeInsetsZero;
    //    }
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    
    self.loginVC =[[LoginViewController alloc] init];
    self.nav = [[ZZNavigationController alloc] initWithRootViewController:self.loginVC];
    
    [self toTop];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"shopCircle"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"shopCircle"];
    [MobClick endLogPageView:@"shopRelation"];
    if (isHidden == YES) {
       [self huanYuan];
    }
}

//返回顶部
- (void)toTop
{
    UIButton * toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40, 45, 45);
    self.toTopBtn = toTopBtn;
    //    toTopBtn.backgroundColor = [UIColor redColor];
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    toTopBtn.hidden = YES;
    [self.view addSubview:toTopBtn];
    [self.view bringSubviewToFront:toTopBtn];
}

- (void)clickToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}
- (void)reloadPost
{
    [dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
    myAssureVC.idNumber = [dataArray[indexPath.row] model_id];
    [self.navigationController pushViewController:myAssureVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
//        BuyCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
        BuyCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
        cell.thingimage.clipsToBounds = YES;
        cell.titleLabel.text = [dataArray[indexPath.row] title];
        cell.detailLabel.text = [dataArray[indexPath.row] model_description];
        cell.signImage.image = [UIImage imageNamed:@"maisignNew.png"];
        cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [dataArray[indexPath.row]nickname]];
        cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
        return cell;
    }
    SellCell * cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.thingimage.clipsToBounds = YES;
    cell.titleLabel.text = [dataArray[indexPath.row] title];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[dataArray[indexPath.row] bangPrice]];
    [cell.priceLabel sizeToFit];
    cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
    cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [dataArray[indexPath.row]nickname]];
    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
        cell.postLabel.text = @"包邮";
        cell.postLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x + cell.priceLabel.frame.size.width + 20, cell.priceLabel.frame.origin.y + 5, 30, 16);
    }
    else
    {
        cell.postLabel.hidden = YES;
    }
    cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
    return cell;
    
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.saleAndBuyType == nil || self.saleAndBuyType.length == 0) {
        self.saleAndBuyType = @"0";
    }
    if (self.categoryID == nil || self.categoryID.length == 0) {
        self.categoryID = @"0";
    }
    if (self.order == nil) {
        self.order = @"postid";
    }
    NSDictionary * dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType,@"order":self.order, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
            self.toTopBtn.hidden = YES;
        }else if ([result isEqualToString:@"10100"]){
            Singleton * singleton = [Singleton sharedInstance];
            if (singleton.isShow == NO) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                [alert show];
                singleton.isShow = YES;
            }
            noData.hidden = NO;
            self.toTopBtn.hidden = YES;
        }else{
            noData.hidden = NO;
            self.toTopBtn.hidden = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        self.toTopBtn.hidden = YES;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        noData.hidden = NO;
    }];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    Singleton * singleton = [Singleton sharedInstance];
//    singleton.isShow = NO;
//    if (buttonIndex == 1) {
//        [self presentViewController:self.nav animated:YES completion:nil];
//    }
//}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    if (self.saleAndBuyType == nil || self.saleAndBuyType.length == 0) {
        self.saleAndBuyType = @"0";
    }
    if (self.categoryID == nil || self.categoryID.length == 0) {
        self.categoryID = @"0";
    }
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
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
            [temTableView reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        self.toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        self.toTopBtn.hidden = YES;
    }
    
    int currentPostion = scrollView.contentOffset.y;
    if (self.shoppingVC.shaixuanView.hidden == NO) {
        if (currentPostion - _lastPosition > 100) {
            isHidden = YES;
            _lastPosition = currentPostion;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            self.shoppingVC.sv.scrollEnabled = NO;
            self.shoppingVC.topBGView.hidden = YES;
            self.shoppingVC.typeView.hidden = YES;
            CGRect tempRect = self.shoppingVC.shaixuanView.frame;
            tempRect.origin.y = 0;
            self.shoppingVC.shaixuanView.frame = tempRect;
            self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 40 - 49);
            self.shoppingVC.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
            self.shoppingVC.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
            self.shoppingVC.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 40, 45, 45);
            [UIView commitAnimations];
            [self.shoppingVC.navigationController setNavigationBarHidden:YES animated:YES];
            AppDelegate * app = APPDELEGATE;
            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else if(_lastPosition - currentPostion > 100){
            _lastPosition = currentPostion;
            isHidden = NO;
            [self huanYuan];
        }
    }
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    
//    if (self.shoppingVC.shaixuanView.hidden == NO) {
//        if (velocity.y > 0) {
//            self.shoppingVC.sv.scrollEnabled = NO;
//            self.shoppingVC.topBGView.hidden = YES;
//            self.shoppingVC.typeView.hidden = YES;
//            CGRect tempRect = self.shoppingVC.shaixuanView.frame;
//            tempRect.origin.y = 0;
//            self.shoppingVC.shaixuanView.frame = tempRect;
//            self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 40 - 49);
//            self.shoppingVC.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
//            self.shoppingVC.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
//            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
//            self.shoppingVC.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 40, 45, 45);
//            [self.shoppingVC.navigationController setNavigationBarHidden:YES animated:YES];
//            AppDelegate * app = APPDELEGATE;
//            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        }else if(velocity.y < 0){
//            [self huanYuan];
//        }
//    }
//}

- (void)huanYuan
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    self.shoppingVC.sv.scrollEnabled = YES;
    self.shoppingVC.topBGView.hidden = NO;
    self.shoppingVC.typeView.hidden = NO;
    CGRect tempRect = self.shoppingVC.shaixuanView.frame;
    tempRect.origin.y = 79;
    self.shoppingVC.shaixuanView.frame = tempRect;
    self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
    self.shoppingVC.sv.frame = CGRectMake(0, 119, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
    self.shoppingVC.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
    self.shoppingVC.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40 - 40, 45, 45);
    [UIView commitAnimations];
    [self.shoppingVC.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


@end
