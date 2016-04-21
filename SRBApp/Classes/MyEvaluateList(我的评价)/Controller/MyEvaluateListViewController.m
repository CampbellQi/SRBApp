//
//  MyEvaluateListViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyEvaluateListViewController.h"
#import "MJRefresh.h"
#import "MyEvaluateListCell.h"
#import "MineEvaluateViewController.h"
#import "BuyerWaitCommentViewController.h"
#import "AppDelegate.h"
#import "ShaiXuanEvaluateViewController.h"

@interface MyEvaluateListViewController ()<UIScrollViewDelegate>

@end

@implementation MyEvaluateListViewController
{
    BOOL isBack;
    BOOL isOK;                  //是否加载完成
    BOOL isSecond;              //是否在第二个页面
    UIView * topView;
    UIView * topViews;
    BOOL secondVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
    self.title = @"我的评价";
    dataArray = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    [self customInit];
    [self urlRequestPost];
    
}



- (void)showComment:(UITapGestureRecognizer *)showTap
{
//    isShow = !isShow;
//    if (isShow) {
//        showCommentView.hidden = NO;
//    }else{
//        showCommentView.hidden = YES;
//    }
    if (isOK) {
        ShaiXuanEvaluateViewController * shaiXuanVC = [[ShaiXuanEvaluateViewController alloc]init];
        shaiXuanVC.imgArr = imgArr;
        shaiXuanVC.dataArr = dataArray;
//        shaiXuanVC.fromSellerVC = self.fromSellerVC;
        [[UIApplication sharedApplication].windows.lastObject addSubview:shaiXuanVC.view];
        [self addChildViewController:shaiXuanVC];
    }else{
        [AutoDismissAlert autoDismissAlert:@"数据加载中,请稍后"];
    }

}

#pragma mark - 初始化控件
- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 18)];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 18)];
    UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(95, 7, 15, 7)];
    titleLabel.text = @"求购人评价";
    titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    imgview.image = [UIImage imageNamed:@"xiala"];
    [topView addSubview:titleLabel];
    [topView addSubview:imgview];
    UITapGestureRecognizer * commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showComment:)];
    [topView addGestureRecognizer:commentTap];
    
    
    topViews = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, 18)];
    UILabel * titleLabels = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95, 18)];
    titleLabels.text = @"求购人评价";
    titleLabels.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    titleLabels.font = [UIFont systemFontOfSize:18];
    [topViews addSubview:titleLabels];
    self.navigationItem.titleView = topViews;
    

    //查看待评价
//    UIView * waitCommentBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    waitCommentBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    [self.view addSubview:waitCommentBGView];
//    
//    UIImageView * waitImgview = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12, 25, 25)];
//    waitImgview.image = [UIImage imageNamed:@"daipingjia"];
//    [waitCommentBGView addSubview:waitImgview];
//    
//    UILabel * waitLabel = [[UILabel alloc]initWithFrame:CGRectMake(waitImgview.frame.size.width + waitImgview.frame.origin.x + 25, 17, 60, 16)];
//    waitLabel.text = @"待评价";
//    waitLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
//    waitLabel.font = SIZE_FOR_IPHONE;
//    [waitCommentBGView addSubview:waitLabel];
//    
//    UILabel * waitSeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 -6 - 200, 18, 200, 18)];
//    waitSeeLabel.font = SIZE_FOR_14;
//    waitSeeLabel.text = @"查看等待评价的订单";
//    waitSeeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
//    waitSeeLabel.textAlignment = NSTextAlignmentRight;
//    [waitCommentBGView addSubview:waitSeeLabel];
//    
//    UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(waitSeeLabel.frame.size.width + waitSeeLabel.frame.origin.x + 2, 22, 6, 7)];
//    detailImg.image = [UIImage imageNamed:@"detail_jt"];
//    [waitCommentBGView addSubview:detailImg];
//    
//    UITapGestureRecognizer * waitCommentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(waitCommentTap:)];
//    [waitCommentBGView addGestureRecognizer:waitCommentTap];
    
    //左右切换
//    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, waitCommentBGView.frame.size.height + waitCommentBGView.frame.origin.y, SCREEN_WIDTH, 40)];
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
//    topBGView.layer.shadowOpacity = 0.8;
//    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    
    //左侧按钮
    toSellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toSellerBtn.frame = CGRectMake(0, 10, SCREEN_WIDTH/2, 20);
    [toSellerBtn setTitle:@"给代购人的评价" forState:UIControlStateNormal];
    [toSellerBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [toSellerBtn addTarget:self action:@selector(toSellerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [toSellerBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    toSellerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    toSellerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    toSellerBtn.selected = YES;
    [topBGView addSubview:toSellerBtn];
    
    //中间竖线
    UIView *centerlineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 12, 1, 16)];
    centerlineView.backgroundColor = [GetColor16 hexStringToColor:@"#bfbebe"];
    [topBGView addSubview:centerlineView];
    
    //右侧按钮
    toBuyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toBuyerBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 20);
    [toBuyerBtn setTitle:@"代购人给我的评价" forState:UIControlStateNormal];
    [toBuyerBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [toBuyerBtn addTarget:self action:@selector(toBuyerBtn:) forControlEvents:UIControlEventTouchUpInside];
    toBuyerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    toBuyerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [toBuyerBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:toBuyerBtn];
    //底部横线
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, toBuyerBtn.frame.size.height + toBuyerBtn.frame.origin.y + 10, SCREEN_WIDTH, 1)];
    lineImage.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
    [topBGView addSubview:lineImage];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, toBuyerBtn.frame.size.height + toBuyerBtn.frame.origin.y + 8.5, SCREEN_WIDTH / 2, 1.5)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    
    //scrollerView
//    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 91, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 41 - 64)];
    //self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 50 - 41 - 64);
        self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, SCREEN_HEIGHT - 41 - 64)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 41 - 64);
    self.sv.showsHorizontalScrollIndicator = NO;
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;

    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
      [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    
    [self.view addSubview:self.sv];
    [self.view addSubview:topBGView];
    
    self.toSellerVC = [[ToSellerCommentTable alloc]init];
    //self.toSellerVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 91);
    self.toSellerVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 41);
    [self.sv addSubview:self.toSellerVC.view];
    [self addChildViewController:self.toSellerVC];
    
    self.fromSellerVC = [[FromSellerViewController alloc]init];
    //self.fromSellerVC.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 91);
    self.fromSellerVC.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 41);
    
}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

- (void)waitCommentTap:(UITapGestureRecognizer *)waitTap
{
    BuyerWaitCommentViewController * waitCommentVC = [[BuyerWaitCommentViewController alloc]init];
    [self.navigationController pushViewController:waitCommentVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (down_IOS_8) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (isBack) {
        [self.fromSellerVC removeFromParentViewController];
        [self.toSellerVC removeFromParentViewController];
        [self.fromSellerVC.view removeFromSuperview];
        [self.toSellerVC.view removeFromSuperview];
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 两个button点击事件
- (void)toBuyerBtn:(UIButton *)sender
{
    toSellerBtn.selected = NO;
    toBuyerBtn.selected = YES;
    isSecond = YES;
    self.navigationItem.titleView = topView;
    if (!secondVC) {
        [self.sv addSubview:self.fromSellerVC.view];
        [self addChildViewController:self.fromSellerVC];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, toBuyerBtn.frame.size.height + toBuyerBtn.frame.origin.y + 8.5, SCREEN_WIDTH/2, 1.5);
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [self.fromSellerVC urlRequestPost];
    [UIView commitAnimations];
}

- (void)toSellerBtn:(UIButton *)sender
{
    toBuyerBtn.selected = NO;
    toSellerBtn.selected = YES;
    isSecond = NO;
    self.navigationItem.titleView = topViews;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, toSellerBtn.frame.size.height + toSellerBtn.frame.origin.y + 8.5, SCREEN_WIDTH/2, 1.5);
    self.sv.contentOffset = CGPointMake(0, 0);
    [self.toSellerVC urlRequestPost];
    [UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        toSellerBtn.selected = YES;
        toBuyerBtn.selected = NO;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, toBuyerBtn.frame.size.height + toBuyerBtn.frame.origin.y +8.5, SCREEN_WIDTH/2, 1.5);
        isSecond = NO;
        self.navigationItem.titleView = topViews;
        [self.toSellerVC urlRequestPost];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        toBuyerBtn.selected = YES;
        toSellerBtn.selected = NO;
        if (!secondVC) {
            [self.sv addSubview:self.fromSellerVC.view];
            [self addChildViewController:self.fromSellerVC];
            secondVC = YES;
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, toSellerBtn.frame.size.height + toSellerBtn.frame.origin.y +8.5, SCREEN_WIDTH/2, 1.5);
        isSecond = YES;
        self.navigationItem.titleView = topView;
        [self.fromSellerVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getUserGrade" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF,@"type":@"buyer"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [dataArray removeAllObjects];
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            NSString * goodNum = [tempdic objectForKey:@"okCount"];
            NSString * middleNum = [tempdic objectForKey:@"normalCount"];
            NSString * badNum = [tempdic objectForKey:@"badCount"] ;
            NSString * fakeNum = [tempdic objectForKey:@"evilCount"];
            
            if (goodNum == nil) {
                goodNum = @"0";
            }
            if (middleNum == nil) {
                middleNum = @"0";
            }
            if (badNum == nil) {
                badNum = @"0";
            }
            if (fakeNum == nil) {
                fakeNum = @"0";
            }
            [dataArray addObject:[NSString stringWithFormat:@"   全部"]];
            [dataArray addObject:[NSString stringWithFormat:@"（%@）",goodNum]];
            [dataArray addObject:[NSString stringWithFormat:@"（%@）",middleNum]];
            [dataArray addObject:[NSString stringWithFormat:@"（%@）",badNum]];
            [dataArray addObject:[NSString stringWithFormat:@"（%@）",fakeNum]];
            NSArray * imgArrs = @[@"s_total",@"s_good",@"s_middle",@"s_negative",@"s_ey"];
            [imgArr addObjectsFromArray:imgArrs];
            isOK = YES;
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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
