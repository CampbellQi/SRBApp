//
//  FootPrintViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FootPrintViewController.h"
#import "RelationTable.h"
#import "CircleTable.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RunViewController.h"
#import "ZZNavigationController.h"
//#import "TotalViewController.h"
#import "FindLocationViewController.h"

@interface FootPrintViewController ()<UIScrollViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) RelationTable *relationTVC;
@property (nonatomic, strong) CircleTable *circleTVC;
//@property (nonatomic, strong) TotalViewController *totalVC;
@property (nonatomic, strong) UIScrollView *sv;

@end

@implementation FootPrintViewController
{
    UIView * lineView;
    UIButton * relationBtn;
    UIButton * circleBtn;
    UIButton *totalBtn;
    
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    self.title = @"足 迹";
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"发 布" forState:UIControlStateNormal];

    [regBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.backgroundColor = [UIColor whiteColor];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    [self customInit];
    
}

- (void)regController:(id)sender
{
    RunViewController * myAssureVC = [[RunViewController alloc]init];
    //myAssureVC.totalVC = self.totalVC;
    myAssureVC.circleVC = self.circleTVC;
//    myAssureVC.relationVC = self.relationTVC;
//    [myAssureVC relation:^(NSString *relation) {
//        self.type = relation;
//        if ([self.type isEqualToString:@"1"]) {
//            circleBtn.selected = NO;
//            totalBtn.selected = NO;
//            relationBtn.selected = YES;
//            
//            lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/3, 1);
//            [self.relationTVC.tableview headerBeginRefreshing];
//            [self.relationTVC hiddenBtn];
//            self.sv.contentOffset = CGPointMake(0, 0);
//        }
//    }];
    [self.navigationController pushViewController:myAssureVC animated:YES];
}


#pragma mark - 初始化控件
- (void)customInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.masksToBounds = NO;
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);

    //熟人圈按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [relationBtn setTitle:@"熟人圈" forState:UIControlStateNormal];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = SIZE_FOR_14;
    relationBtn.selected = YES;
    [topBGView addSubview:relationBtn];
    
    //关系圈按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [circleBtn setTitle:@"关系圈" forState:UIControlStateNormal];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.titleLabel.font = SIZE_FOR_14;
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:circleBtn];
    
//    //全部按钮
//    totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    totalBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 38);
//    [totalBtn setTitle:@"发现" forState:UIControlStateNormal];
//    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
//    [totalBtn addTarget:self action:@selector(totalBtn:) forControlEvents:UIControlEventTouchUpInside];
//    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [totalBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
//    [topBGView addSubview:totalBtn];
    
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH / 2, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39 - 49);
    self.sv.bounces = NO;
    self.sv.pagingEnabled = YES;
    self.sv.showsHorizontalScrollIndicator = NO;
    self.sv.delegate = self;
    self.sv.delaysContentTouches = NO;
    [self.view addSubview:self.sv];
    
    self.relationTVC = [[RelationTable alloc]init];
    self.relationTVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
    self.relationTVC.tempScrollView = self.sv;
    [self.sv addSubview:self.relationTVC.view];
    [self addChildViewController:self.relationTVC];
    
    self.circleTVC = [[CircleTable alloc]init];
    self.circleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
    self.circleTVC.tempScrollView = self.sv;
//    [self.sv addSubview:self.circleTVC.view];
//    [self addChildViewController:self.circleTVC];
    

//    self.totalVC = [[FindLocationViewController alloc]init];
//    self.totalVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49);
//    self.relationTVC.tempScrollView = self.sv;
//    [self.sv addSubview:self.totalVC.view];
//    [self addChildViewController:self.totalVC];
    [self.view addSubview:topBGView];
    
}


#pragma mark - 三个button点击事件
- (void)relationBtn:(UIButton *)sender
{
    circleBtn.selected = NO;
    totalBtn.selected = NO;
    relationBtn.selected = YES;
//    [self.totalVC.hpTextView resignFirstResponder];
//    self.totalVC.hpTextView.text = @"";
//    self.totalVC.tempCommentID = @"";
//    self.totalVC.tempCommentStr = @"";
    
    [self.circleTVC.hpTextView resignFirstResponder];
    self.circleTVC.hpTextView.text = @"";
    self.circleTVC.tempCommentID = @"";
    self.circleTVC.tempCommentStr = @"";

    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/2, 1);
    [self.relationTVC.tableview headerBeginRefreshing];
    [self.relationTVC hiddenBtn];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    totalBtn.selected = NO;
    circleBtn.selected = YES;
//    [self.totalVC.hpTextView resignFirstResponder];
//    self.totalVC.hpTextView.text = @"";
//    self.totalVC.tempCommentID = @"";
//    self.totalVC.tempCommentStr = @"";
    
    [self.relationTVC.hpTextView resignFirstResponder];
    self.relationTVC.hpTextView.text = @"";
    self.relationTVC.tempCommentID = @"";
    self.relationTVC.tempCommentStr = @"";
    if (!secondVC) {
        [self.sv addSubview:self.circleTVC.view];
        [self addChildViewController:self.circleTVC];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH/2, 38, SCREEN_WIDTH/2, 1);
    [self.circleTVC.tableview headerBeginRefreshing];
    [self.circleTVC hiddenBtn];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    
}
//- (void)totalBtn:(UIButton *)sender
//{
//    relationBtn.selected = NO;
//    circleBtn.selected = NO;
//    totalBtn.selected = YES;
//    [self.circleTVC.hpTextView resignFirstResponder];
//    self.circleTVC.hpTextView.text = @"";
//    self.circleTVC.tempCommentID = @"";
//    self.circleTVC.tempCommentStr = @"";
//    
//    [self.relationTVC.hpTextView resignFirstResponder];
//    self.relationTVC.hpTextView.text = @"";
//    self.relationTVC.tempCommentID = @"";
//    self.relationTVC.tempCommentStr = @"";
//    if (!thirdVC) {
//        [self.sv addSubview:self.totalVC.view];
//        [self addChildViewController:self.totalVC];
//        thirdVC = YES;
//    }
//    [UIView beginAnimations:@"lineview" context:nil];
//    [UIView setAnimationDuration:0.3];
//    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, 38, SCREEN_WIDTH/3, 1);
//    [self.totalVC.tableview headerBeginRefreshing];
//    [self.totalVC hiddenBtn];
//    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
//    [UIView commitAnimations];
//    
//}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        circleBtn.selected = NO;
        //totalBtn.selected = NO;
        relationBtn.selected = YES;
        
        
//        [self.totalVC.hpTextView resignFirstResponder];
//        self.totalVC.hpTextView.text = @"";
//        self.totalVC.tempCommentID = @"";
//        self.totalVC.tempCommentStr = @"";
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, 38, SCREEN_WIDTH/2, 1);
        //[self.relationTVC urlRequestPost];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        relationBtn.selected = NO;
        //totalBtn.selected = NO;
        circleBtn.selected = YES;
//        [self.totalVC.hpTextView resignFirstResponder];
//        self.totalVC.hpTextView.text = @"";
//        self.totalVC.tempCommentID = @"";
//        self.totalVC.tempCommentStr = @"";
        
        
        if (!secondVC) {
            [self.sv addSubview:self.circleTVC.view];
            [self addChildViewController:self.circleTVC];
            secondVC = YES;
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH/2, 38, SCREEN_WIDTH/2, 1);
        //[self.circleTVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
//    if (self.sv.contentOffset.x == SCREEN_WIDTH*2) {
//        relationBtn.selected = NO;
//        circleBtn.selected = NO;
//        totalBtn.selected = YES;
//        [self.circleTVC.hpTextView resignFirstResponder];
//        self.circleTVC.hpTextView.text = @"";
//        self.circleTVC.tempCommentID = @"";
//        self.circleTVC.tempCommentStr = @"";
//        
//        [self.relationTVC.hpTextView resignFirstResponder];
//        self.relationTVC.hpTextView.text = @"";
//        self.relationTVC.tempCommentID = @"";
//        self.relationTVC.tempCommentStr = @"";
//        if (!thirdVC) {
//            [self.sv addSubview:self.totalVC.view];
//            [self addChildViewController:self.totalVC];
//            thirdVC = YES;
//        }
//        [UIView beginAnimations:@"lineview" context:nil];
//        [UIView setAnimationDuration:0.3];
//        //[self.totalVC urlRequestPost];
//        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, 38, SCREEN_WIDTH/3, 1);
//        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH*2, 0);
//        [UIView commitAnimations];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.circleTVC.hpTextView resignFirstResponder];
    self.circleTVC.hpTextView.text = @"";
    self.circleTVC.tempCommentID = @"";
    self.circleTVC.tempCommentStr = @"";
    [self.relationTVC.hpTextView resignFirstResponder];
    self.relationTVC.hpTextView.text = @"";
    self.relationTVC.tempCommentID = @"";
    self.relationTVC.tempCommentStr = @"";
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
 */@end
