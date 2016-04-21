//
//  SaleMineViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SaleMineViewController.h"
#import "AppDelegate.h"
#import "MyPublishGiveYouTableViewController.h"
#import "MyGuaranteeGiveYouViewController.h"

@interface SaleMineViewController ()<UIScrollViewDelegate>
{
    UIButton * publishBtn;
    UIButton * guaranteeBtn;
    
    UIView * lineView;
    
    BOOL secondVC;
    
    int page;
    int tempPage;
}
@property (nonatomic ,strong)UIScrollView * sv;
@property (nonatomic ,strong)MyPublishGiveYouTableViewController * publishTableView;
@property (nonatomic, strong)MyGuaranteeGiveYouViewController * guaranteeTableView;
@property (nonatomic ,strong)UITextField * textField;
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation SaleMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_sign isEqualToString:@"1"]) {
        self.title = @"我要推荐";
    }
    else{
        self.title = @"传送门";
    }
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self customInit];
    
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
}

- (void)returnKeyBoard
{
    [_textField resignFirstResponder];
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

- (void)viewDidAppear:(BOOL)animated
{
    //    //添加屏幕边缘手势
    //    UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
    //    //    popSwipe.delegate = self;
    //    [popSwipe setEdges:UIRectEdgeLeft];
    
//    if ([_sign isEqualToString:@"1"]) {
//        //手动取消pop动画
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//    }else if([_sign isEqualToString:@"2"]){
//        //手动取消pop动画
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
//    }else{
        if (down_IOS_8) {
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }
//    }
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
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
        [self.publishTableView removeFromParentViewController];
        [self.guaranteeTableView removeFromParentViewController];
        [self.publishTableView.view removeFromSuperview];
        [self.guaranteeTableView.view removeFromSuperview];
    }
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
{
    [self backBtn:nil];
}

- (void)customInit
{
    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    //发布按钮
    publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [publishBtn setTitle:@"我发布的信息" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    publishBtn.selected = YES;
    [topBGView addSubview:publishBtn];
    
    //担保按钮
    guaranteeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guaranteeBtn.frame = CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH/2, 38);
    [guaranteeBtn setTitle:@"我担保的信息" forState:UIControlStateNormal];
    [guaranteeBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [guaranteeBtn addTarget:self action:@selector(guaranteeBtn:) forControlEvents:UIControlEventTouchUpInside];
    guaranteeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [guaranteeBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:guaranteeBtn];
    
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, publishBtn.frame.size.height + publishBtn.frame.origin.y , SCREEN_WIDTH / 2, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, topBGView.frame.origin.y + topBGView.frame.size.height, SCREEN_WIDTH, 40)];
    searchView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:searchView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 7.5,SCREEN_WIDTH - 50 - 15, 25)];
    _textField.placeholder = @"  查找宝贝";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 2;
    [_textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [searchView addSubview:_textField];
    
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(_textField.frame.origin.x + _textField.frame.size.width + 15, 10, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"square_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search1:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, searchView.frame.size.height + searchView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    
    [self.view addSubview:self.sv];
    
    self.publishTableView = [[MyPublishGiveYouTableViewController alloc]init];
    self.publishTableView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 40);
    self.publishTableView.dealType = _sign;
    self.publishTableView.model = _model;
    [self.sv addSubview:self.publishTableView.view];
    [self addChildViewController:self.publishTableView];
    
    self.guaranteeTableView = [[MyGuaranteeGiveYouViewController alloc]init];
    self.guaranteeTableView.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 40);
    self.guaranteeTableView.dealType = _sign;
    self.guaranteeTableView.model = _model;
    [self.sv addSubview:self.guaranteeTableView.view];
    [self addChildViewController:self.guaranteeTableView];

    page = self.sv.contentOffset.x / SCREEN_WIDTH;
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    
    [self.view addSubview:topBGView];
    
}

- (void)search1:(id)sender
{
    if (lineView.frame.origin.x == 0) {
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user": ACCOUNT_SELF,
                                                                            @"dealType": @"1",
                                                                            @"type": @"0",
                                                                            @"status": @"1",
                                                                            @"start": @"0",
                                                                            @"count": @"100",
                                                                            @"keyword":_textField.text
                                                                 }];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [_publishTableView.dataArray removeAllObjects];
        if (result == 0) {
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                DetailModel * bussinessModel = [[DetailModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [_publishTableView.dataArray addObject:bussinessModel];
            }
            _publishTableView.nodataView.hidden = YES;
            [_textField resignFirstResponder];
        }else if(result == 4){
            _publishTableView.nodataView.hidden = NO;
            [_textField resignFirstResponder];
        }else{
            _publishTableView.nodataView.hidden = NO;
            [_textField resignFirstResponder];
        }
        [_publishTableView.tableView reloadData];
    }andFailureBlock:^{
        
    }];
    }else{
        NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD,
                                                                                            @"start":@"0",
                                                                                            @"count":@"100",
                                                                                            @"keyword":_textField.text
                                                                                            }];
        
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"] intValue];
            [_guaranteeTableView.dataArray removeAllObjects];
            if (result == 0) {
                NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (int i = 0; i < temparrs.count; i++) {
                    NSDictionary * tempdic = [temparrs objectAtIndex:i];
                    DetailModel * bussinessModel = [[DetailModel alloc]init];
                    [bussinessModel setValuesForKeysWithDictionary:tempdic];
                    [_guaranteeTableView.dataArray addObject:bussinessModel];
                }
                _guaranteeTableView.nodataView.hidden = YES;
                [_textField resignFirstResponder];
            }else if(result == 4){
                _guaranteeTableView.nodataView.hidden = NO;
                [_textField resignFirstResponder];
            }else{
                _guaranteeTableView.nodataView.hidden = NO;
                [_textField resignFirstResponder];
            }
            [_guaranteeTableView.tableView reloadData];
        }andFailureBlock:^{
            
        }];

    }
}

//- (void)search2:(id)sender
//{
//    NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD,
//                                                                                        @"start":@"0",
//                                                                                        @"count":@"100",
//                                                                                        @"keyword":_textField.text
//                                                                                  }];
//    
//    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        int result = [[dic objectForKey:@"result"] intValue];
//        [_guaranteeTableView.dataArray removeAllObjects];
//        if (result == 0) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                DetailModel * bussinessModel = [[DetailModel alloc]init];
//                [bussinessModel setValuesForKeysWithDictionary:tempdic];
//                [_guaranteeTableView.dataArray addObject:bussinessModel];
//            }
//            _guaranteeTableView.nodataView.hidden = YES;
//            [_textField resignFirstResponder];
//        }else if(result == 4){
//            _guaranteeTableView.nodataView.hidden = NO;
//            [_textField resignFirstResponder];
//        }else{
//            _guaranteeTableView.nodataView.hidden = NO;
//            [_textField resignFirstResponder];
//        }
//        [_guaranteeTableView.tableView reloadData];
//    }];
//}


#pragma mark - 两个button点击事件
- (void)publishBtn:(UIButton *)sender
{
    guaranteeBtn.selected = NO;
    publishBtn.selected = YES;
    secondVC = YES;
    if (!secondVC) {
        [self.sv addSubview:self.publishTableView.view];
        [self addChildViewController:self.publishTableView];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, publishBtn.frame.size.height + publishBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    self.sv.contentOffset = CGPointMake(0, 0);
    [self.publishTableView urlRequestPost];
    [UIView commitAnimations];
}

- (void)guaranteeBtn:(UIButton *)sender
{
    publishBtn.selected = NO;
    guaranteeBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH / 2, guaranteeBtn.frame.size.height + guaranteeBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.guaranteeTableView urlRequestPost];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    tempPage = self.sv.contentOffset.x / SCREEN_WIDTH;
    if (self.sv.contentOffset.x == 0) {
        guaranteeBtn.selected = NO;
        publishBtn.selected = YES;
        if (tempPage != page) {
            [self.publishTableView urlRequestPost];
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, publishBtn.frame.size.height + publishBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        publishBtn.selected = NO;
        guaranteeBtn.selected = YES;
        if (!secondVC) {
            [self.sv addSubview:self.guaranteeTableView.view];
            [self addChildViewController:self.guaranteeTableView];
            secondVC = YES;
        }
        if (tempPage != page) {
            [self.guaranteeTableView urlRequestPost];
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH / 2, guaranteeBtn.frame.size.height + guaranteeBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self.guaranteeTableView urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
    page = self.sv.contentOffset.x / SCREEN_WIDTH;
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
