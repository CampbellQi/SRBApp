//
//  NewShoppingViewController.m
//  SRBApp
//
//  Created by zxk on 15/6/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewShoppingViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZZNavigationController.h"
#import "FriendFragmentModel.h"

#import "CDRTranslucentSideBar.h"
#import "NewRightSideBarViewController.h"
#import "GroupModel.h"
#import "SquareViewController.h"
#import "ZZAlertView.h"
#import "BussinessModel.h"
#import "DetailActivityViewController.h"
#import "BuyCell.h"
#import "SellCell.h"

/** 筛选类型隐藏的时候向上按钮 */
#define btnYWhenShow MAIN_NAV_HEIGHT - 49 - 60
/** 筛选类型隐藏的时候View */
#define viewHeightForListWhenHide SCREEN_HEIGHT - 64 - 49 - 40
/** 筛选类型显示的时候View */
#define viewHeightForListWhenShow SCREEN_HEIGHT - 64 - 40 - 40 - 49
/** 筛选类型显示的时候向上按钮 */
#define btnYWhenHide SCREEN_HEIGHT - 49 - 60

static int page = 0;
static int count = NumOfItemsForZuji;

@interface NewShoppingViewController ()<CDRTranslucentSideBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    CDRTranslucentSideBar * rightSideBar;
    NewRightSideBarViewController * rightSideBarVC;
    NSMutableArray * categoryArr;
    UIButton * rightBtn;
    UIButton * allSearchBtn;
    
    //NSTimer * timer;
    BOOL isShow;
    int buttonOldIndex;
    MyImgView * priceImg;
    BOOL isJiangXu;
    int tapNum;
    UIButton * changeBtn;
    UIActivityIndicatorView * activity;
    
    BOOL isHidden;
}
@property (nonatomic, strong) NSString * type;  //第三方登录类型
@property (nonatomic, assign) int resultTP;       //返回结果
@property (nonatomic, strong) NSString *token;  //第三方token
@property (nonatomic, strong) NSString *uid;
@property (nonatomic,assign)BOOL isClick;


@property (nonatomic,strong)NSArray * orderArr;
@property (nonatomic,strong)UIView * orderView;
@property (nonatomic,strong)UIView * typeView;
@property (nonatomic,assign)BOOL isTypeShow;
@property (nonatomic,assign)BOOL isSquareShow;

@property (nonatomic, strong) NSMutableArray *array;
//@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)MyLabel * gongxuLabel;



@end

@implementation NewShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"逛 街";
    categoryArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [self customInit];
    //[self boundThird_PartyPaltform];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
    
    [self toAppStoreComment];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isHidden == YES) {
        [self huanYuan];
    }
}

- (void)refresh
{
    [self headerRefresh];
}

- (void)reloadPost
{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView headerBeginRefreshing];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        self.toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        self.toTopBtn.hidden = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        
        isHidden = YES;
        if (self.isTypeShow == YES) {
            self.typeView.hidden = YES;
        }
        
        self.orderView.y = 0;
        self.tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 49);
        self.noData.height = SCREEN_HEIGHT - 40 - 49;
        self.toTopBtn.y = btnYWhenHide;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        AppDelegate * app = APPDELEGATE;
        [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
    }else if(velocity.y < 0){
        
        isHidden = NO;
        [self huanYuan];
    }
}

- (void)huanYuan
{
    
    NSInteger tempRectY;
    NSInteger tempSvHeight;
    NSInteger tempSvY;
    if (self.isTypeShow == NO) {
        self.typeView.hidden = YES;
        tempRectY = 0;
        tempSvY = 40;
        tempSvHeight = viewHeightForListWhenHide;
    }else{
        self.typeView.hidden = NO;
        tempRectY = 40;
        tempSvY = 80;
        tempSvHeight = viewHeightForListWhenShow;
    }
    self.orderView.y = tempRectY;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = CGRectMake(0, tempSvY, SCREEN_WIDTH, tempSvHeight);
        self.noData.height = tempSvHeight;
        self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnYWhenShow, 45, 45);
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
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
    
    NSDictionary * dic = [self parametersForDic:@"getPostListByFancy" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"groupId":self.groupID,@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType,@"order":self.order, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
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
            self.noData.hidden = YES;
            self.listNoDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.listNoDataView.hidden = NO;
            self.noData.hidden = YES;
        }else{
            self.noData.hidden = NO;
            self.listNoDataView.hidden = YES;
        }
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [activity stopAnimating];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [activity stopAnimating];
        [self.dataArray removeAllObjects];
        self.noData.hidden = NO;
        self.listNoDataView.hidden = YES;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
    
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self urlRequestPost];
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
    
    dic = [self parametersForDic:@"getPostListByFancy" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"groupId":self.groupID,@"dealType":self.saleAndBuyType,@"order":self.order,@"categoryID":self.categoryID, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
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
            [self.tableView reloadData];
            self.noData.hidden = YES;
            self.listNoDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
}

#pragma mark - 初始化控件
- (void)customInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self createShaiXuan];
    
    //商品条件背景view
    self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.typeView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
    self.typeView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    self.typeView.layer.shadowOpacity = 0.8;
    self.typeView.layer.shadowOffset = CGSizeMake(4, 3);
    self.typeView.hidden = YES;
    [self.view addSubview:self.typeView];
    
    MyLabel * gongxuLabel = [[MyLabel alloc]initWithFrame:CGRectMake(15, 13, 200, 16)];
    self.gongxuLabel = gongxuLabel;
    gongxuLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    gongxuLabel.font = SIZE_FOR_14;
    [self.typeView addSubview:gongxuLabel];
    
    UIButton * restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [restBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#f84887"]];
    restBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 15, 7.5, 60, 25);
    [restBtn setTitle:@"重 置" forState:UIControlStateNormal];
    [restBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [restBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    restBtn.layer.masksToBounds = YES;
    restBtn.layer.cornerRadius = 2;
    restBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [restBtn addTarget:self action:@selector(restBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeView addSubview:restBtn];
    
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, viewHeightForListWhenHide) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    [tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    if (![ACCOUNT_SELF isEqualToString:@""]) {
        [tableView headerBeginRefreshing];
    }
    
    self.noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAIN_NAV_HEIGHT - 40 - 49)];
    self.noData.hidden = YES;
    [tableView addSubview:self.noData];
    
    [self toTop];
    
    [self noDataView];
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activity.color = RGBCOLOR(223, 0, 85, 1);
    activity.center = tableView.center;
    [activity setHidesWhenStopped:YES];
    [tableView addSubview:activity];
    
    
    rightSideBar = [[CDRTranslucentSideBar alloc]initWithDirection:YES];
    rightSideBar.sideBarWidth = 160;
    rightSideBar.animationDuration = 0.3f;
    rightSideBar.translucentAlpha = 1;
    rightSideBar.delegate = self;
    rightSideBar.view.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
    rightSideBar.view.layer.shadowOpacity = 0.6;
    rightSideBar.view.layer.shadowOffset = CGSizeMake(-4, 3);
    
    rightSideBarVC = [[NewRightSideBarViewController alloc]init];
    rightSideBarVC.rightSideBar = rightSideBar;
    rightSideBarVC.shoppingVC = self;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shopping_filter"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn addTarget:self action:@selector(shaiXuan:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(0, 0, 25, 25);
    [changeBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    
    __block NewShoppingViewController * tempShopping = self;
    self.isShowBlock = ^void(NSString * saleOrBuy,NSString * goodsType,NSString * groupType){
        [tempShopping changeWith:saleOrBuy and:goodsType groupType:groupType];
    };
    
    [self.view bringSubviewToFront:self.toTopBtn];
}

- (void)noDataView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAIN_NAV_HEIGHT - 49 - 40)];
    self.listNoDataView = view;
    view.hidden = YES;
    view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.tableView addSubview:view];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 55, 200, 170)];
    [imageV setImage:[UIImage imageNamed:@"suibianmai"]];
    [view addSubview:imageV];
    
}

#pragma mark - 返回顶部
- (void)toTop
{
    UIButton * toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, MAIN_NAV_HEIGHT - 49 - 60, 45, 45);
    self.toTopBtn = toTopBtn;
    
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    toTopBtn.hidden = YES;
    [self.view addSubview:toTopBtn];
}

- (void)clickToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

/**
 *  @brief  切换数据显示方式
 */
- (void)changeBtn:(UIButton *)sender
{
    SquareViewController * squareVC = [[SquareViewController alloc]init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

- (void)changeWith:(NSString *)saleOrBuy and:(NSString *)goodsType groupType:(NSString *)groupType
{
    if ([saleOrBuy isEqualToString:@"全部"] && [goodsType isEqualToString:@"全部"] && [groupType isEqualToString:@"全部"]) {
        self.gongxuLabel.text = @"分类:全部";
        self.isTypeShow = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, viewHeightForListWhenHide);
            self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnYWhenHide, 45, 45);
            self.orderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        } completion:^(BOOL finished) {
            self.typeView.hidden = YES;
        }];
    }else{
        self.isTypeShow = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.orderView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 40);
            self.typeView.hidden = NO;
            //self.typeView.transform = CGAffineTransformMakeScale(1, 1);
            NSString * typeStr = @"";
            if (![saleOrBuy isEqualToString:@"全部"]) {
                typeStr = [typeStr stringByAppendingString:saleOrBuy];
            }
            if (![goodsType isEqualToString:@"全部"]) {
                typeStr = [typeStr stringByAppendingFormat:@" %@",goodsType];
            }
            if (![groupType isEqualToString:@"全部"]) {
                typeStr = [typeStr stringByAppendingFormat:@" %@",groupType];
            }
            self.gongxuLabel.text = [NSString stringWithFormat:@"分类:%@",typeStr];
            
            self.tableView.frame = CGRectMake(0, 80, SCREEN_WIDTH, viewHeightForListWhenShow);
            self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnYWhenShow, 45, 45);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)restBtn:(UIButton *)btn
{
    [rightSideBarVC restAllState];
    self.goodsType = @"";
    self.saleOrBuy = @"";
    self.groupType = @"";
    self.gongxuLabel.text = @"分类:全部";
}

- (void)shaiXuan:(UIButton *)sender
{
    [rightSideBar setContentViewInSideBar:rightSideBarVC.view];
    [rightSideBar showAnimated:YES];
    isShow = YES;
}

/**
 *  获取筛选的分类
 */
- (void)categoryRequest
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"123"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                GroupModel * groupModel = [[GroupModel alloc]init];
                [groupModel setValuesForKeysWithDictionary:tempdic];
                [categoryArr addObject:groupModel];
            }
        }
    } andFailureBlock:^{
        
    }];
    
}

- (void)createShaiXuan
{
    buttonOldIndex = 10000;
    self.orderArr = @[@"",@"sales",@"price-asc",@"consultations",@"favorites"];
    self.orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.orderView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
    self.orderView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    self.orderView.layer.masksToBounds = NO;
    self.orderView.layer.shadowOpacity = 0.8;
    self.orderView.layer.shadowOffset = CGSizeMake(4, 3);
    [self.view addSubview:self.orderView];
    
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
        [self.orderView addSubview:tapBtn];
        [tapBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)selectedBtn:(UIButton *)sender
{
    [self changeIndex:buttonOldIndex newIndex:(int)sender.tag];
}

- (void)changeIndex:(int)oldIndex newIndex:(int)newIndex
{
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
    buttonOldIndex = (int)newIndex;
    
    NSString * orderStr = self.orderArr[buttonOldIndex - 10000];
    if (buttonOldIndex - 10000 == 2) {
        if (isJiangXu == YES) {
            orderStr = @"price-asc";
        }else{
            orderStr = @"price-desc";
        }
    }
    
    self.order = orderStr;
    for (int i = 0 ; i < 5; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
        btn.userInteractionEnabled = NO;
    }
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self start];
    [self urlRequestPost];
}



//判断何时提示评论you are my sweet girl
- (void)toAppStoreComment
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    NSString * oldYear = [dataDic objectForKey:@"year"];
    NSString * oldMonth = [dataDic objectForKey:@"month"];
    NSString * oldDay = [dataDic objectForKey:@"day"];
    
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    
    
    NSString * year = [NSString stringWithFormat:@"%ld",(long)[conponent year]];
    NSString * month = [NSString stringWithFormat:@"%ld",(long)[conponent month]];
    NSString * day = [NSString stringWithFormat:@"%ld",(long)[conponent day]];
    
    if ([year intValue] * 365 + [month intValue] * 30 + [day intValue] - [oldYear intValue] * 365 - [oldMonth intValue] * 30 - [oldDay intValue] == 3) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"一大波真货正在向你奔跑，快赏个5分加个油吧" message:nil delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"去评价",@"去吐槽", nil];
        [alertView show];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    
    if (dic == nil) {
        NSDictionary * versionDic = [[NSBundle mainBundle] infoDictionary];
        dic = [NSMutableDictionary dictionary];
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        [dic setObject:[versionDic objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    }else{
        
        NSString * oldYear = [dic objectForKey:@"year"];
        NSString * oldMonth = [dic objectForKey:@"month"];
        NSString * oldDay = [dic objectForKey:@"day"];
        
        NSDate *  senddate=[NSDate date];
        NSCalendar  * cal=[NSCalendar  currentCalendar];
        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
        
        NSString * year = [NSString stringWithFormat:@"%ld",(long)[conponent year]];
        NSString * month = [NSString stringWithFormat:@"%ld",(long)[conponent month]];
        NSString * day = [NSString stringWithFormat:@"%ld",(long)[conponent day]];
        
        [dic setObject:year forKey:@"year"];
        [dic setObject:month forKey:@"month"];
        [dic setObject:day forKey:@"day"];
        LoginViewController * loginVC = [[LoginViewController alloc]init];
        ZZNavigationController * loginNC = [[ZZNavigationController alloc]initWithRootViewController:loginVC];
        //将登录状态写入配置文件
        [dic writeToFile:USER_CONFIG_PATH atomically:YES];
        if (([year intValue] - [oldYear intValue]) * 365 + ([month intValue] - [oldMonth intValue])* 30 + [day intValue] - [oldDay intValue] > 7 && oldYear > 0) {
            [AutoDismissAlert autoDismissAlert:@"账号已过期,请重新登录!"];
            [dic setObject:@"0" forKey:@"isLogin"];
            [dic writeToFile:USER_CONFIG_PATH atomically:YES];
            [self presentViewController:loginNC animated:NO completion:nil];
            //                [self setNoLoginState];
        }else{
            if ([[dic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
                
            }else{
                //                    [self setNoLoginState];
                [self presentViewController:loginNC animated:NO completion:nil];
            }
        }
    }
    
//    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
//    if ([dataDic objectForKey:@"shopping"]== nil) {
//        [dataDic setObject:@"1" forKey:@"shopping"];
//        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
//        static dispatch_once_t token;
//        dispatch_once(&token, ^{
//            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(seeFinished) userInfo:nil repeats:YES];
//        });
//        
//    }
}

//- (void)seeFinished
//{
//    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
//    //NSString * isFinished = [dataDic objectForKey:@"finished"];
//    NSString * isLogin = [dataDic objectForKey:@"isLogin"];
//    if ([isLogin isEqualToString:@"1"]) {
//        [timer invalidate];
//        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.bgView];
//    }
//}

/**
 *  首次进入程序提示图片
 */
//- (UIView *)bgView
//{
//    if (!_bgView) {
//        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _bgView.backgroundColor = [UIColor clearColor];
//        
//        UIView * tempBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        tempBGView.backgroundColor = [UIColor blackColor];
//        tempBGView.alpha = 0.4;
//        [_bgView addSubview:tempBGView];
//        
//        UIImageView * alertImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 4 - (SCREEN_WIDTH/5/2) - 60, SCREEN_HEIGHT - 35 - 125, 165, 125)];
//        alertImg.image = [UIImage imageNamed:@"alert_shopping"];
//        [_bgView addSubview:alertImg];
//        UITapGestureRecognizer * removeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTap:)];
//        [_bgView addGestureRecognizer:removeTap];
//    }
//    return _bgView;
//}
//
//- (void)removeTap:(UITapGestureRecognizer *)tap
//{
//    [_bgView removeFromSuperview];
//}



@end
