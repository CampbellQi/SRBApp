//
//  ShopRelationViewController.m
//  SRBApp
//
//  Created by lizhen on 15/2/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShopRelationViewController.h"
#import "ShoppingViewController.h"
#import "SquareViewController.h"
#import "ZZAlertView.h"

/*! @brief 筛选类型隐藏的时候向上按钮
 */
#define btnHeightForListWhenHide SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40
/*! @brief 筛选类型隐藏的时候View
 */
#define viewHeightForListWhenHide SCREEN_HEIGHT - 64 - 39 - 49 - 40
/*! @brief 筛选类型显示的时候View
 */
#define viewHeightForListWhenShow SCREEN_HEIGHT - 64 - 39 - 40 - 40 - 49
/*! @brief 筛选类型显示的时候向上按钮
 */
#define btnHeightForListWhenShow SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40 - 40

static int page = 0;
static int count = NumOfItemsForZuji;

@interface ShopRelationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)ZZAlertView * alertView;
@end

@implementation ShopRelationViewController
{
    int _lastPosition;
    BOOL isHidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.isNoDataHidden = YES;
//    self.isSquareNoDataHidden = YES;
    self.dataArray = [NSMutableArray array];
    
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49)];
    self.tabelView.backgroundColor = [UIColor clearColor];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.tabelView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tabelView addFooterWithTarget:self action:@selector(footerRefresh)];
    if (![ACCOUNT_SELF isEqualToString:@""]) {

        [self.tabelView headerBeginRefreshing];
    }
    self.tabelView.backgroundColor = [UIColor clearColor];
    
    self.noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40)];
    //noData.center = self.tableView.center;
    self.noData.hidden = YES;
    [self.tabelView addSubview:self.noData];
    [self.view addSubview:self.tabelView];
    self.tabelView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
    
//    self.tableState = @"list";
    [self toTop];
    
    [self noDataView];
//    self.groupArray = [NSMutableArray array];
//    self.addDic = [NSMutableDictionary dictionary];
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    activity.color = RGBCOLOR(223, 0, 85, 1);
    activity.center = self.tabelView.center;
    [activity setHidesWhenStopped:YES];
    [self.tabelView addSubview:activity];
    
//    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
//    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//    self.topBGView = topBGView;
    
    
}

- (void)noDataView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40)];
    self.listNoDataView = view;
    view.hidden = YES;
    view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.tabelView addSubview:view];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 55, 200, 170)];
    [imageV setImage:[UIImage imageNamed:@"suibianmai"]];
    [view addSubview:imageV];
    
}

#pragma mark - 广告请求
//- (void)adUrlPostRequest
//{
//    
//    NSDictionary * dic = [self parametersForDic:@"getAdList" parameters:@{@"start":@"0",@"count":@"100"}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            self.addDic = dic;
//            [self customInit];
//            
//        }
//    } andFailureBlock:^{
//        
//    }];
//}

#pragma mark - 点击广告
//- (void)tapDetail1:(UITapGestureRecognizer *)tap
//{
//    NSArray * temparr = [[self.addDic objectForKey:@"data"] objectForKey:@"list"];
//    int ID = [[temparr[0] objectForKey:@"url"] intValue];
//    if (ID != 0) {
//        DetailActivityViewController * subsubVC = [[DetailActivityViewController alloc]init];
//        subsubVC.idNumber = [NSString stringWithFormat:@"%d",ID];
//        [self.navigationController pushViewController:subsubVC animated:YES];
//    }
//}
//
//- (void)tapDetail2:(UITapGestureRecognizer *)tap
//{
//    NSArray * temparr = [[self.addDic objectForKey:@"data"] objectForKey:@"list"];
//    int ID = [[temparr[1] objectForKey:@"url"] intValue];
//    if (ID != 0) {
//        DetailActivityViewController * subsubVC = [[DetailActivityViewController alloc]init];
//        subsubVC.idNumber = [NSString stringWithFormat:@"%d",ID];
//        [self.navigationController pushViewController:subsubVC animated:YES];
//    }
//}

//- (void)customInit
//{
//    NSMutableArray * imgarr = [NSMutableArray array];
//    
//    self.imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
//    self.imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 130)];
//    self.imgView1.userInteractionEnabled = YES;
//    self.imgView2.userInteractionEnabled = YES;
//    UITapGestureRecognizer * imgView1Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail1:)];
//    UITapGestureRecognizer * imgView2Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetail2:)];
//    [self.imgView1 addGestureRecognizer:imgView1Tap];
//    [self.imgView2 addGestureRecognizer:imgView2Tap];
//    
//    
//    CarouselDiagram *cdView = [[CarouselDiagram alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130) andimgArray:imgarr];
//    [self.topBGView addSubview:cdView];
//    
//    NSArray * temparr = [[self.addDic objectForKey:@"data"] objectForKey:@"list"];
//    [self.imgView1 sd_setImageWithURL:[NSURL URLWithString:[temparr[0] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [imgarr addObject:self.imgView1];
//        [self.imgView2 sd_setImageWithURL:[NSURL URLWithString:[temparr[1] objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [imgarr addObject:self.imgView2];
//            cdView.imageArray = imgarr;
//            [cdView start];
//        }];
//    }];
//}

//- (void)setHeader
//{
//    if ([self.tableState isEqualToString:@"square"]) {
//        if (self.isSquareNoDataHidden == NO) {
//           self.tabelView.tableHeaderView = nil;
//        }else{
//           self.tabelView.tableHeaderView = self.topBGView;
//        }
//        
//    }else{
//        self.tabelView.tableHeaderView = nil;
//    }
//}

//- (void)moreBtn:(ZZGoPayBtn *)sender
//{
//    SquareMoreViewController * vc = [[SquareMoreViewController alloc]init];
//    GroupModel * groupModel = self.groupArray[sender.indexpath.section];
//    vc.keyStr = groupModel.categoryID;
//    vc.titleStr = groupModel.categoryName;
//    vc.team = @"relation";
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - squareCellDelegate
//- (void)jumpToDetail:(NSInteger)index
//{
//    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
//    vc.idNumber = [NSString stringWithFormat:@"%lu",index];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)refresh
{
    [self headerRefresh];
}

#pragma mark - 返回顶部
- (void)toTop
{
    UIButton * toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40, 45, 45);
    //toTopBtn.translatesAutoresizingMaskIntoConstraints = NO;
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
    [self.tabelView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)reloadPost
{
    //self.tableState = @"list";
    [self.dataArray removeAllObjects];
//    [self.groupArray removeAllObjects];
    [self.tabelView reloadData];
    [self.tabelView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"shopRelation"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"shopRelation"];
    if (isHidden == YES) {
       [self huanYuan];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.tableState isEqualToString:@"list"]) {
//        return 130;
//    }else{
//        return 257;
//    }
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if ([self.tableState isEqualToString:@"square"]) {
//        return 1;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if ([self.tableState isEqualToString:@"square"]) {
//        return 20;
//    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
//    if ([self.tableState isEqualToString:@"square"]) {
//        return self.groupArray.count;
//    }else{
//        return 1;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    if ([self.tableState isEqualToString:@"square"]) {
//        return 1;
//    }else{
//        return self.dataArray.count;
//    }
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.tableState isEqualToString:@"list"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
        myAssureVC.idNumber = [self.dataArray[indexPath.row] model_id];
        [self.navigationController pushViewController:myAssureVC animated:YES];
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
//        BuyCell * cell = [self.tabelView dequeueReusableCellWithIdentifier:@"cell"];
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
    
    
    
//    if ([self.tableState isEqualToString:@"list"]) {
        BussinessModel * bussinessModel = self.dataArray[indexPath.row];
        if ([bussinessModel.dealName isEqualToString:@"想买"]) {
            BuyCell * cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.bussinessModel = bussinessModel;
            return cell;
        }else{
            SellCell * cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.bussinessModel = bussinessModel;
            return cell;
        }
    
//    }else{
//        //1.创建一个cell
//        SquareCell * cell = [SquareCell squareCellWithTableView:tableView andIndexPath:indexPath];
//        //SquareCell * cell = [SquareCell squareCellWithTableView:tableView];
//        //2.取出对应的模型
//        GroupModel * groupModel = [self.groupArray objectAtIndex:indexPath.section];
//        cell.moreBtn.indexpath = indexPath;
//        [cell.moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
//        cell.groupModel = groupModel;
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
}

//#pragma mark - 网络请求(Square)
//- (void)urlRequestPosts
//{
//    if (ACCOUNT_SELF == nil || PASSWORD_SELF == nil) {
//        return;
//    }
//    NSDictionary * dic = [self parametersForDic:@"getPostListByType" parameters:@{@"type":@"123",@"count":@"6",ACCOUNT_PASSWORD,@"team":@"relation"}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [self.groupArray removeAllObjects];
//        if ([result isEqualToString:@"0"]) {
//            
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                GroupModel * groupModel = [[GroupModel alloc]init];
//                [groupModel setValuesForKeysWithDictionary:tempdic];
//                [self.groupArray addObject:groupModel];
//            }
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            [self adUrlPostRequest];
//            self.isSquareNoDataHidden = YES;
//            [self setHeader];
//        }else if([result isEqualToString:@"4"]){
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            self.isSquareNoDataHidden = NO;
//        }else{
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = YES;
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//            self.isSquareNoDataHidden = NO;
//        }
//        if ([self.tableState isEqualToString:@"square"]) {
//            [self.tabelView reloadData];
//            //[self.tabelView headerEndRefreshing];
//        }
//    } andFailureBlock:^{
//        [self.groupArray removeAllObjects];
//        self.isSquareNoDataHidden = NO;
//        if ([self.tableState isEqualToString:@"square"]) {
//            self.tabelView.tableHeaderView = nil;
//            self.noData.hidden = NO;
//            self.toTopBtn.hidden = YES;
//            self.listNoDataView.hidden = YES;
//            [self.tabelView reloadData];
//            //[self.tabelView headerEndRefreshing];
//        }
//    }];
//}

- (void)seeSomething
{
    [self.alertView dismiss];
    SquareViewController * squareVC = [[SquareViewController alloc]init];
    [self.navigationController pushViewController:squareVC animated:YES];
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
        self.order = @"";
    }
    if (self.groupID == nil) {
        self.groupID = @"";
    }
    
    if (ACCOUNT_SELF == nil || PASSWORD_SELF == nil) {
        return;
    }
    
    NSDictionary * dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"groupId":self.groupID,@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType,@"order":self.order, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tabelView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            self.isNoDataHidden = YES;
//            self.isNoData = NO;
            self.noData.hidden = YES;
            self.listNoDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
//            self.isNoData = YES;
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = YES;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = NO;
//                
//                //提示框
//                ZZAlertView * alertView = [ZZAlertView zzAlertView];
//                [alertView setAlertWord:@"还没有买卖消息耶"];
//                self.alertView = alertView;
//                [alertView setSureBtnEvent:self action:@selector(seeSomething)];
//                [alertView showAlert];
//            }
//            self.isNoDataHidden = NO;
            self.listNoDataView.hidden = NO;
            self.noData.hidden = YES;
        }else{
//            self.isNoData = NO;
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = YES;
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//            self.isNoDataHidden = YES;
            self.noData.hidden = NO;
            self.listNoDataView.hidden = YES;
        }
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [activity stopAnimating];
//        if ([self.tableState isEqualToString:@"list"]) {
//            [temTableView reloadData];
//        }
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [activity stopAnimating];
        [self.dataArray removeAllObjects];
//        self.isNoData = NO;
        self.noData.hidden = NO;
        self.listNoDataView.hidden = YES;
//        if ([self.tableState isEqualToString:@"list"]) {
//            
//            self.isNoDataHidden = NO;
//            self.listNoDataView.hidden = YES;
//            self.toTopBtn.hidden = YES;
//            [temTableView reloadData];
//        }
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
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
//        [self urlRequestPosts];
        
    });
}

- (void)start
{
    [activity startAnimating];
}

#pragma mark - 加载更多
- (void)footerRefresh
{
//    if ([self.tableState isEqualToString:@"list"]) {
        if (self.saleAndBuyType == nil || self.saleAndBuyType.length == 0) {
            self.saleAndBuyType = @"0";
        }
        if (self.categoryID == nil || self.categoryID.length == 0) {
            self.categoryID = @"0";
        }
        if (self.order == nil) {
            self.order = @"";
        }
        if (self.groupID == nil) {
            self.groupID = @"";
        }
        page += NumOfItemsForZuji;
        NSDictionary * dic;
        
        dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"groupId":self.groupID,@"dealType":self.saleAndBuyType,@"order":self.order,@"categoryID":self.categoryID, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
        
        __block UITableView *temTableView = self.tabelView;
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (int i = 0; i < temparrs.count; i++) {
                    NSDictionary * tempdic = [temparrs objectAtIndex:i];
                    BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                    [bussinessModel setValuesForKeysWithDictionary:tempdic];
                    [self.dataArray addObject:bussinessModel];
                    if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [self.dataArray removeLastObject];
                        page -= NumOfItemsForZuji;
                        break;
                    }
                }
//                if ([self.tableState isEqualToString:@"list"]) {
//                    [temTableView reloadData];
//                    self.noData.hidden = YES;
//                    self.listNoDataView.hidden = YES;
//                }
                [temTableView reloadData];
                self.noData.hidden = YES;
                self.listNoDataView.hidden = YES;
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
//    }else{
//        [self.tabelView footerEndRefreshing];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        self.toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        self.toTopBtn.hidden = YES;
    }
//    if ([self.tableState isEqualToString:@"square"]) {
//        CGFloat sectionHeaderHeight = 20;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //int currentPostion = scrollView.contentOffset.y;
//    if ([self.tableState isEqualToString:@"list"]) {
        if (velocity.y > 0) {
            isHidden = YES;
            //_lastPosition = currentPostion;
            self.shoppingVC.sv.scrollEnabled = NO;
            self.shoppingVC.topBGView.hidden = YES;
            self.shoppingVC.typeView.hidden = YES;
            CGRect tempRect = self.shoppingVC.shaixuanView.frame;
            tempRect.origin.y = 0;
            self.shoppingVC.shaixuanView.frame = tempRect;
            self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 40 - 49);
            self.shoppingVC.sv.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
            self.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 49);
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
            self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 40, 45, 45);
            [self.shoppingVC.navigationController setNavigationBarHidden:YES animated:YES];
            AppDelegate * app = APPDELEGATE;
            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else if(velocity.y < 0){
            //_lastPosition = currentPostion;
            isHidden = NO;
            [self huanYuan];
        }
//    }
}

- (void)huanYuan
{
    self.shoppingVC.sv.scrollEnabled = YES;
    self.shoppingVC.topBGView.hidden = NO;
    self.shoppingVC.typeView.hidden = NO;
    CGRect tempRect = self.shoppingVC.shaixuanView.frame;
    NSInteger tempRectY;
    NSInteger tempSvHeight;
    NSInteger tempBtnY;
    NSInteger tempSvY;
    NSLog(@"%d",self.shoppingVC.typeView.hidden);
    if (self.shoppingVC.isTypeShow == NO) {
        tempRectY = 39;
        tempSvY = 79;
        tempSvHeight = viewHeightForListWhenHide;
        tempBtnY = btnHeightForListWhenHide;
    }else{
        tempRectY = 79;
        tempSvY = 119;
        tempSvHeight = viewHeightForListWhenShow;
        tempBtnY = btnHeightForListWhenShow;
    }
    tempRect.origin.y = tempRectY;
    self.shoppingVC.shaixuanView.frame = tempRect;
    [UIView animateWithDuration:0.3 animations:^{
        self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, tempSvHeight);
        self.shoppingVC.sv.frame = CGRectMake(0, tempSvY, SCREEN_WIDTH, tempSvHeight);
        self.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tempSvHeight);
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, tempSvHeight);
        self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, tempBtnY, 45, 45);
    }];
   
    [self.shoppingVC.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

@end
