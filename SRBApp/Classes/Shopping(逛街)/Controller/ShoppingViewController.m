//
//  ShoppingViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShoppingViewController.h"
#import "LoginViewController.h"
#import "ZZNavigationController.h"
#import "FriendFragmentModel.h"
#import "RCIM.h"
#import "CDRTranslucentSideBar.h"
#import "LeftSideBarViewController.h"
#import "GroupModel.h"
#import "SquareSearchViewController.h"
#import "SquareViewController.h"

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
/*! @brief 图片模式的时候向上按钮
 */
#define btnHeightForSquare SCREEN_HEIGHT - 49 - 60 - 64 - 40
/*! @brief 图片模式的时候View
 */
#define viewHeightForSquare SCREEN_HEIGHT - 64 - 39 - 49

@interface ShoppingViewController ()<CDRTranslucentSideBarDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)MyLabel * gongxuLabel;
//@property (nonatomic,strong)MyLabel * goodsTypeLabel;
//@property (nonatomic,strong)MyLabel * groupTypeLabel;
@end

@implementation ShoppingViewController
{
    CDRTranslucentSideBar * rightSideBar;
    LeftSideBarViewController * leftSideBarVC;
    NSMutableArray * categoryArr;
    UIButton * rightBtn;
    UIButton * allSearchBtn;
    
    NSTimer * timer;
    BOOL isShow;
    int buttonOldIndex;
    MyImgView * priceImg;
    BOOL isJiangXu;
    int tapNum;
    UIButton * changeBtn;
    
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
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
//    if ([[dic objectForKey:@"isLogin"] isEqualToString:@"1"]) {
//        if ([dataDic objectForKey:@"shopping"]== nil) {
//            [dataDic setObject:@"1" forKey:@"shopping"];
//            [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [[[UIApplication sharedApplication].windows lastObject] addSubview:self.bgView];
//            });
//        }
//    }
    
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if ([dataDic objectForKey:@"shopping"]== nil) {
        [dataDic setObject:@"1" forKey:@"shopping"];
        [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
        static dispatch_once_t token;
        dispatch_once(&token, ^{
                timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(seeFinished) userInfo:nil repeats:YES];
        });
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isSquareShow == YES) {
        self.typeView.hidden = YES;
        self.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 -49);
        self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        self.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        self.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
        CGRect tempBtn1 = self.shopRelationTVC.toTopBtn.frame;
        CGRect tempBtn2 = self.shopCircleTVC.toTopBtn.frame;
        tempBtn1.origin.y = SCREEN_HEIGHT - 49 - 60 - 64 - 40;
        tempBtn2.origin.y = SCREEN_HEIGHT - 49 - 60 - 64 - 40;
        self.shopRelationTVC.toTopBtn.frame = tempBtn1;
        self.shopCircleTVC.toTopBtn.frame = tempBtn2;
    }
}

- (void)seeFinished
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    //NSString * isFinished = [dataDic objectForKey:@"finished"];
    NSString * isLogin = [dataDic objectForKey:@"isLogin"];
    if ([isLogin isEqualToString:@"1"]) {
        [timer invalidate];
        [[[UIApplication sharedApplication].windows lastObject] addSubview:self.bgView];
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor clearColor];
        
        UIView * tempBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        tempBGView.backgroundColor = [UIColor blackColor];
        tempBGView.alpha = 0.4;
        [_bgView addSubview:tempBGView];
        
        UIImageView * alertImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 4 - (SCREEN_WIDTH/5/2) - 60, SCREEN_HEIGHT - 35 - 125, 165, 125)];
        alertImg.image = [UIImage imageNamed:@"alert_shopping"];
        [_bgView addSubview:alertImg];
        UITapGestureRecognizer * removeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTap:)];
        [_bgView addGestureRecognizer:removeTap];
    }
    return _bgView;
}

- (void)removeTap:(UITapGestureRecognizer *)tap
{
    [_bgView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"逛 街";
    categoryArr = [NSMutableArray array];
    [self customInit];
    //[self boundThird_PartyPaltform];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(boundThird_PartyPaltform) name:@"reloadVC" object:nil];
    
    [self toAppStoreComment];

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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 || buttonIndex == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",APP_ID]]];
    }
}

//绑定微信/微博
- (void)boundThird_PartyPaltform
{
//    if (self.resultTP == 100) {
//        if ([self.type isEqualToString:@"weibo"]) {
//            NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
//            
//            //拼接post请求所需参数
//            NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{@"account":account,@"password":password,@"apiType":@"weibo",@"token":self.token}};
//            
//            [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
//            }];
//        }
//        if ([self.type isEqualToString:@"weixin"]) {
//            NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
//            //拼接post请求所需参数
//            NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{@"account":account,@"password":password,@"apiType":@"weixin",@"token":self.token,@"unionid":self.uid}};
//            [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
//            }];
//        }
//    }
//    if (isShow == YES) {
//      [self restBtn:nil];
//    }
}

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
    self.orderArr = @[@"",@"sales",@"price-asc",@"comments",@"favorites"];
    self.shaixuanView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 40)];
    self.shaixuanView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
    self.shaixuanView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    self.shaixuanView.layer.masksToBounds = NO;
    self.shaixuanView.layer.shadowOpacity = 0.8;
    self.shaixuanView.layer.shadowOffset = CGSizeMake(4, 3);
    [self.view addSubview:self.shaixuanView];
    
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
        [self.shaixuanView addSubview:tapBtn];
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
    
    self.shopRelationTVC.order = orderStr;
    self.shopCircleTVC.order = orderStr;
    for (int i = 0 ; i < 5; i++) {
        UIButton * btn = (UIButton *)[self.view viewWithTag:i + 10000];
        btn.userInteractionEnabled = NO;
    }
    [self.shopCircleTVC.dataArray removeAllObjects];
    [self.shopRelationTVC.dataArray removeAllObjects];
    [self.shopCircleTVC.tabelView reloadData];
    [self.shopRelationTVC.tabelView reloadData];
    [self.shopRelationTVC start];
    [self.shopCircleTVC start];
    
    [self.shopCircleTVC urlRequestPost];
    [self.shopRelationTVC urlRequestPost];
}

#pragma mark - 初始化控件
- (void)customInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    searchState = @"relation";
    //顶部背景
    self.topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    self.topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    self.topBGView.layer.shadowOpacity = 0.8;
    self.topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 40)];
    self.typeView.backgroundColor = [GetColor16 hexStringToColor:@"#f8f8f8"];
    self.typeView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    //self.typeView.transform = CGAffineTransformMakeScale(1, 0.0);
    self.typeView.layer.shadowOpacity = 0.8;
    self.typeView.layer.shadowOffset = CGSizeMake(4, 3);
    self.typeView.hidden = YES;
    
    MyLabel * gongxuLabel = [[MyLabel alloc]initWithFrame:CGRectMake(15, 13, 200, 16)];
    self.gongxuLabel = gongxuLabel;
    gongxuLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    gongxuLabel.font = SIZE_FOR_14;
    [self.typeView addSubview:gongxuLabel];
    
//    MyLabel * goodsTypeLabel = [[MyLabel alloc]initWithFrame:CGRectMake(gongxuLabel.frame.size.width + gongxuLabel.frame.origin.x + 5, 13, 66, 16)];
//    self.goodsTypeLabel = goodsTypeLabel;
//    goodsTypeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//    goodsTypeLabel.font = SIZE_FOR_14;
//    [self.typeView addSubview:goodsTypeLabel];
//    
//    MyLabel * groupTypeLabel = [[MyLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goodsTypeLabel.frame) + 5, 13, 90, 16)];
//    self.groupTypeLabel = groupTypeLabel;
//    groupTypeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//    groupTypeLabel.font = SIZE_FOR_14;
//    [self.typeView addSubview:groupTypeLabel];
    
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
    
    //topBGView.layer.shadowRadius = 0;
    
    
    
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 79, SCREEN_WIDTH, viewHeightForListWhenHide)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, viewHeightForListWhenHide);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.bounces = NO;
    self.sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.sv];
    
//    self.shopTotalVC = [[ShopTotalViewController alloc]init];
//    self.shopTotalVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//    [self.sv addSubview:self.shopTotalVC.view];
//    [self addChildViewController:self.shopTotalVC];
    
    self.shopRelationTVC = [[ShopRelationViewController alloc]init];
    self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
    self.shopRelationTVC.shoppingVC = self;
    [self.sv addSubview:self.shopRelationTVC.view];
    [self addChildViewController:self.shopRelationTVC];
    
    self.shopCircleTVC = [[ShopCircleFromRelationViewController alloc]init];
    self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
    self.shopCircleTVC.shoppingVC = self;
//    [self.sv addSubview:self.shopCircleTVC.view];
//    [self addChildViewController:self.shopCircleTVC];
    
    [self.view addSubview:self.typeView];
    [self createShaiXuan];
    [self.view addSubview:self.topBGView];
    
//    //全部按钮
//    totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    totalBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 38);
//    [totalBtn setTitle:@"广场" forState:UIControlStateNormal];
//    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
//    [totalBtn addTarget:self action:@selector(totalBtn:) forControlEvents:UIControlEventTouchUpInside];
//    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    totalBtn.selected = YES;
//    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
//    [self.topBGView addSubview:totalBtn];
    
    //熟人圈按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [relationBtn setTitle:@"熟人圈" forState:UIControlStateNormal];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topBGView addSubview:relationBtn];
    
    //关系圈按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [circleBtn setTitle:@"关系圈" forState:UIControlStateNormal];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [self.topBGView addSubview:circleBtn];
    
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38 , SCREEN_WIDTH / 2, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.topBGView addSubview:lineView];
    
    rightSideBar = [[CDRTranslucentSideBar alloc]initWithDirection:YES];
    rightSideBar.sideBarWidth = 160;
    rightSideBar.animationDuration = 0.3f;
    rightSideBar.translucentAlpha = 1;
    rightSideBar.delegate = self;
    rightSideBar.view.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
    rightSideBar.view.layer.shadowOpacity = 0.6;
    rightSideBar.view.layer.shadowOffset = CGSizeMake(-4, 3);
    
    leftSideBarVC = [[LeftSideBarViewController alloc]init];
    leftSideBarVC.rightSideBar = rightSideBar;
    leftSideBarVC.shoppingVC = self;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"shopping_filter"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn addTarget:self action:@selector(shaiXuan:) forControlEvents:UIControlEventTouchUpInside];
    
    allSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSearchBtn.frame = CGRectMake(0, 0, 25, 25);
    [allSearchBtn setBackgroundImage:[UIImage imageNamed:@"shopping_search"] forState:UIControlStateNormal];
    [allSearchBtn addTarget:self action:@selector(allSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
//    changeBtn.layer.cornerRadius = 2;
//    changeBtn.layer.masksToBounds = YES;
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    changeBtn.frame = CGRectMake(0, 0, 25, 25);
    [changeBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    
    __block ShoppingViewController * tempShopping = self;
    self.isShowBlock = ^void(NSString * saleOrBuy,NSString * goodsType,NSString * groupType){
        [tempShopping changeWith:saleOrBuy and:goodsType groupType:groupType];
    };
}

/**
 *  @brief  切换逛街数据显示方式
 *  @param sender
 */
- (void)changeBtn:(UIButton *)sender
{
    SquareViewController * squareVC = [[SquareViewController alloc]init];
    [self.navigationController pushViewController:squareVC animated:YES];
//    CGRect tempRealation = self.shopRelationTVC.view.frame;
//    CGRect tempCircle = self.shopCircleTVC.view.frame;
//    CGRect tempRelationTable = self.shopRelationTVC.tabelView.frame;
//    CGRect tempCircleTable = self.shopCircleTVC.tabelView.frame;
//    CGRect tempSV = self.sv.frame;
//    CGRect tempTopBtn = self.shopRelationTVC.toTopBtn.frame;
//    CGRect tempTopBtn2 = self.shopCircleTVC.toTopBtn.frame;
//    //[self.shopRelationTVC.tabelView headerEndRefreshing];
//    //[self.shopCircleTVC.tabelView headerEndRefreshing];
//    
//    //切换到square
//    if ([self.shopRelationTVC.tableState isEqualToString:@"list"]) {
//        [sender setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
//        self.isSquareShow = YES;
//        if (self.shopRelationTVC.isSquareNoDataHidden == YES) {
//            self.shopRelationTVC.noData.hidden = YES;
//        }else{
//            self.shopRelationTVC.noData.hidden = NO;
//        }
//        self.shopRelationTVC.listNoDataView.hidden = YES;
//        self.shopCircleTVC.listNoDataView.hidden = YES;
//        if (self.shopCircleTVC.isSquareNoDataHidden == YES) {
//            self.shopCircleTVC.noData.hidden = YES;
//        }else{
//            self.shopCircleTVC.noData.hidden = NO;
//        }
//        self.shopRelationTVC.tableState = @"square";
//        self.shopCircleTVC.tableState = @"square";
//        self.typeView.hidden = YES;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSearchBtn];
//        self.shaixuanView.hidden = YES;
//        tempSV.origin.y = 39;
//        tempSV.size.height = viewHeightForSquare;
//        self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, viewHeightForSquare);
//        tempRealation.size.height = viewHeightForSquare;
//        tempRelationTable.size.height = viewHeightForSquare;
//        tempCircle.size.height = viewHeightForSquare;
//        tempCircleTable.size.height = viewHeightForSquare;
//        tempTopBtn.origin.y = btnHeightForSquare;
//        tempTopBtn2.origin.y = btnHeightForSquare;
//        self.shopRelationTVC.tabelView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        self.shopCircleTVC.tabelView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    }else{//切换到list
//        [sender setBackgroundImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
//        self.isSquareShow = NO;
//        if (self.shopRelationTVC.isNoDataHidden == YES) {
//            self.shopRelationTVC.noData.hidden = YES;
//            self.shopRelationTVC.listNoDataView.hidden = YES;
//        }else{
//            //关系圈数据为空
//            if (self.shopRelationTVC.isNoData == YES) {
//                self.shopRelationTVC.noData.hidden = YES;
//                self.shopRelationTVC.listNoDataView.hidden = NO;
//            }else{
//                self.shopRelationTVC.listNoDataView.hidden = YES;
//                self.shopRelationTVC.noData.hidden = NO;
//            }
//        }
//        if (self.shopCircleTVC.isNoDataHidden == YES) {
//            self.shopCircleTVC.listNoDataView.hidden = YES;
//            self.shopCircleTVC.noData.hidden = YES;
//        }else{
//            //关系圈数据为空
//            if (self.shopCircleTVC.isNoData == YES) {
//                self.shopCircleTVC.noData.hidden = YES;
//                self.shopCircleTVC.listNoDataView.hidden = NO;
//            }else{
//                self.shopCircleTVC.listNoDataView.hidden = YES;
//                self.shopCircleTVC.noData.hidden = NO;
//            }
//        }
//        self.shopRelationTVC.tableState = @"list";
//        self.shopCircleTVC.tableState = @"list";
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//        self.shaixuanView.hidden = NO;
//        tempSV.origin.y = 79;
//        tempSV.size.height = viewHeightForListWhenHide;
//        self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, viewHeightForListWhenHide);
//        tempRealation.size.height = viewHeightForListWhenHide;
//        tempRelationTable.size.height = viewHeightForListWhenHide;
//        tempCircle.size.height = viewHeightForListWhenHide;
//        tempCircleTable.size.height = viewHeightForListWhenHide;
//        tempTopBtn.origin.y = btnHeightForListWhenHide;
//        tempTopBtn2.origin.y = btnHeightForListWhenHide;
//        if (self.shopRelationTVC.tabelView.contentOffset.y >0 ) {
//            self.shopRelationTVC.tabelView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
//        }
//        if (self.shopCircleTVC.tabelView.contentOffset.y > 0) {
//            self.shopCircleTVC.tabelView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
//        }
//    }
//    self.sv.frame = tempSV;
//    self.shopRelationTVC.view.frame = tempRealation;
//    self.shopRelationTVC.tabelView.frame = tempRelationTable;
//    self.shopCircleTVC.view.frame = tempCircle;
//    self.shopCircleTVC.tabelView.frame = tempCircleTable;
//    self.shopRelationTVC.toTopBtn.frame = tempTopBtn;
//    self.shopCircleTVC.toTopBtn.frame = tempTopBtn2;
//    [self.shopRelationTVC.tabelView reloadData];
//    [self.shopRelationTVC setHeader];
//    [self.shopCircleTVC.tabelView reloadData];
//    [self.shopCircleTVC setHeader];
}

- (void)changeWith:(NSString *)saleOrBuy and:(NSString *)goodsType groupType:(NSString *)groupType
{
    if ([saleOrBuy isEqualToString:@"全部"] && [goodsType isEqualToString:@"全部"] && [groupType isEqualToString:@"全部"]) {
        self.gongxuLabel.text = @"分类:全部";
//        self.goodsTypeLabel.text = [NSString stringWithFormat:@"信息:%@",goodsType];
//        self.groupTypeLabel.text = [NSString stringWithFormat:@"分组:%@",groupType];
        
//        UIButton * oldBtn = (UIButton *)[self.view viewWithTag:buttonOldIndex];
//        oldBtn.selected = NO;
//        buttonOldIndex = 10000;
//        UIButton * btn = (UIButton *)[self.view viewWithTag:buttonOldIndex];
//        btn.selected = YES;
//        priceImg.image = [UIImage imageNamed:@"ranking_arrow_gray2"];
//        isJiangXu = NO;
        self.isTypeShow = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            //self.typeView.transform = CGAffineTransformMakeScale(1, 0.1);
            
            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, viewHeightForListWhenHide);
            self.sv.frame = CGRectMake(0, 79, SCREEN_WIDTH, viewHeightForListWhenHide);
            
            self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
            self.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
            self.shopRelationTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnHeightForListWhenHide, 45, 45);
            
            self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
            self.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenHide);
            self.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnHeightForListWhenHide, 45, 45);
            
            self.shaixuanView.frame = CGRectMake(0, 39, SCREEN_WIDTH, 40);
        } completion:^(BOOL finished) {
//            changeBtn.hidden = NO;
            self.typeView.hidden = YES;
        }];
    }else{
//        changeBtn.hidden = YES;
        self.isTypeShow = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.shaixuanView.frame = CGRectMake(0, 79, SCREEN_WIDTH, 40);
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
//            self.goodsTypeLabel.text = [NSString stringWithFormat:@"信息:%@",goodsType];
//            self.groupTypeLabel.text = [NSString stringWithFormat:@"分组:%@",groupType];
            
            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, viewHeightForListWhenShow);
            self.sv.frame = CGRectMake(0, 119, SCREEN_WIDTH, viewHeightForListWhenShow);
            
            self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenShow);
            self.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenShow);
            self.shopRelationTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnHeightForListWhenShow, 45, 45);
            
            self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, viewHeightForListWhenShow);
            self.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeightForListWhenShow);
            self.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, btnHeightForListWhenShow, 45, 45);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)restBtn:(UIButton *)btn
{
    [leftSideBarVC restAllState];
    self.goodsType = @"";
    self.saleOrBuy = @"";
    self.groupType = @"";
    self.gongxuLabel.text = @"分类:全部";
//    self.goodsTypeLabel.text = [NSString stringWithFormat:@"信息:全部"];
//    self.groupTypeLabel.text = [NSString stringWithFormat:@"分组:全部"];
}

- (void)allSearchBtn:(UIButton *)sender
{
    SquareSearchViewController * squareSearchVC = [[SquareSearchViewController alloc]init];
    squareSearchVC.hidesBottomBarWhenPushed = YES;
    squareSearchVC.searchState = searchState;
    [self.navigationController pushViewController:squareSearchVC animated:YES];
}

- (void)shaiXuan:(UIButton *)sender
{
    [rightSideBar setContentViewInSideBar:leftSideBarVC.view];
    [rightSideBar showAnimated:YES];
    isShow = YES;
}

#pragma mark - 三个button点击事件
//- (void)totalBtn:(UIButton *)sender
//{
//    relationBtn.selected = NO;
//    circleBtn.selected = NO;
//    totalBtn.selected = YES;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.typeView.transform = CGAffineTransformMakeScale(1, 0.1);
//        self.shaixuanView.transform = CGAffineTransformMakeScale(1, 0.1);
//        self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 64 - 39 - 49);
//        self.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//    } completion:^(BOOL finished) {
//        self.typeView.hidden = YES;
//        self.shaixuanView.hidden = YES;
//    }];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSearchBtn];
//    [UIView beginAnimations:@"lineview" context:nil];
//    [UIView setAnimationDuration:0.3];
//    lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/3, 1);
//    self.sv.contentOffset = CGPointMake(0, 0);
//    [self.shopTotalVC.tableV headerBeginRefreshing];
//    self.sv.contentOffset = CGPointMake(0, 0);
//    [UIView commitAnimations];
//}

- (void)relationBtn:(UIButton *)sender
{
    circleBtn.selected = NO;
    totalBtn.selected = NO;
    relationBtn.selected = YES;
    searchState = @"relation";
    if (!secondVC) {
        [self.sv addSubview:self.shopRelationTVC.view];
        [self addChildViewController:self.shopRelationTVC];
        secondVC = YES;
    }
    //[self isRelationRefresh];
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/2, 1);
    [self.shopRelationTVC.tabelView headerBeginRefreshing];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    totalBtn.selected = NO;
    circleBtn.selected = YES;
    searchState = @"circle";
    if (!thirdVC) {
        [self.sv addSubview:self.shopCircleTVC.view];
        [self addChildViewController:self.shopCircleTVC];
        thirdVC = YES;
    }
    
    //[self isCircleRefresh];
    
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH/2, 38, SCREEN_WIDTH/2, 1);
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.shopCircleTVC.tabelView headerBeginRefreshing];
    [UIView commitAnimations];
    
}


//- (void)isRelationRefresh
//{
//    if (([self.saleOrBuy isEqualToString:@"全部"] && [self.goodsType isEqualToString:@"全部"]) || self.saleOrBuy == nil || self.goodsType == nil || [self.saleOrBuy isEqualToString:@""] || [self.goodsType isEqualToString:@""]) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.typeView.transform = CGAffineTransformMakeScale(1, 0.1);
//            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            
//            self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.shopRelationTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40, 45, 45);
//        } completion:^(BOOL finished) {
//            self.typeView.hidden = YES;
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            self.typeView.hidden = NO;
//            self.typeView.transform = CGAffineTransformMakeScale(1, 1);
//            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.sv.frame = CGRectMake(0, 119, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            
//            self.shopRelationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.shopRelationTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.shopRelationTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40 - 40, 45, 45);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}
//
//- (void)isCircleRefresh
//{
//    if (([self.saleOrBuy isEqualToString:@"全部"] && [self.goodsType isEqualToString:@"全部"]) || self.saleOrBuy == nil || self.goodsType == nil || [self.saleOrBuy isEqualToString:@""] || [self.goodsType isEqualToString:@""]) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.typeView.transform = CGAffineTransformMakeScale(1, 0.1);
//            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            
//            self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40, 45, 45);
//        } completion:^(BOOL finished) {
//            self.typeView.hidden = YES;
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            self.typeView.hidden = NO;
//            self.typeView.transform = CGAffineTransformMakeScale(1, 1);
//            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.sv.frame = CGRectMake(0, 119, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            
//            self.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.shopCircleTVC.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49 - 40 - 40);
//            self.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40 - 40, 45, 45);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    if (self.sv.contentOffset.x == 0) {
//        relationBtn.selected = NO;
//        circleBtn.selected = NO;
//        totalBtn.selected = YES;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allSearchBtn];
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            self.typeView.transform = CGAffineTransformMakeScale(1, 0.1);
//            self.shaixuanView.transform = CGAffineTransformMakeScale(1, 0.1);
//            self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49);
//            self.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//        } completion:^(BOOL finished) {
//            self.typeView.hidden = YES;
//            self.shaixuanView.hidden = YES;
//        }];
//        
//        [UIView beginAnimations:@"lineview" context:nil];
//        [UIView setAnimationDuration:0.3];
//        lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/3, 1);
//        self.sv.contentOffset = CGPointMake(0, 0);
//        [UIView commitAnimations];
//        
//    }
    if (scrollView == self.sv) {
        if (self.sv.contentOffset.x == 0) {
            
            circleBtn.selected = NO;
            //totalBtn.selected = NO;
            relationBtn.selected = YES;
            
            //[self isRelationRefresh];
            searchState = @"relation";
            [UIView beginAnimations:@"lineview" context:nil];
            [UIView setAnimationDuration:0.3];
            self.sv.contentOffset = CGPointMake(0, 0);
            lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/2, 1);
            [UIView commitAnimations];
        }
        if (self.sv.contentOffset.x == SCREEN_WIDTH) {
            
            relationBtn.selected = NO;
            //totalBtn.selected = NO;
            circleBtn.selected = YES;
            searchState = @"circle";
            if (!secondVC) {
                [self.sv addSubview:self.shopCircleTVC.view];
                [self addChildViewController:self.shopCircleTVC];
                secondVC = YES;
            }
            
            //[self isCircleRefresh];
            
            [UIView beginAnimations:@"lineview" context:nil];
            [UIView setAnimationDuration:0.3];
            lineView.frame = CGRectMake(SCREEN_WIDTH/2, 38, SCREEN_WIDTH/2, 1);
            self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            [UIView commitAnimations];
            
        }
    }
}

@end
