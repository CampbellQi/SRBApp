//
//  ConsultViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ConsultViewController.h"
#import "AccountCommentViewController.h"
//#import "GoodFriendConsultViewController.h"
#import "GoodFriendZixunViewController.h"
//#import "TotalConsultViewController.h"
#import "TotalZixunViewController.h"

@interface ConsultViewController ()

@property (nonatomic, strong) GoodFriendZixunViewController *goodConsultVC;
@property (nonatomic, strong) TotalZixunViewController *totalConsultVC;

@end

@implementation ConsultViewController
{
    BOOL secondVC;
    BOOL isisBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"咨询留言";
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"咨 询" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    [regBtn addTarget:self action:@selector(toAccountCommentVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    
    

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

- (void)toAccountCommentVC:(id)sender
{
    AccountCommentViewController * vc = [[AccountCommentViewController alloc]init];
    vc.idNumber = self.idNumber;
    [vc sendMessage:^(id result) {
        [self.goodConsultVC urlRequestPost];
        [self.totalConsultVC urlRequestPost];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    topBGView.layer.shadowOpacity = 0.8;
    topBGView.layer.shadowOffset = CGSizeMake(4, 3);
    
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 39);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.showsHorizontalScrollIndicator = NO;
    
    UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
    if (screen != nil) {
        [self.sv.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
    }
    
    [self.view addSubview:self.sv];
    
    self.goodConsultVC = [[GoodFriendZixunViewController alloc]init];
    self.goodConsultVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.goodConsultVC.idNumber = self.idNumber;
    [self.sv addSubview:self.goodConsultVC.view];
    [self addChildViewController:self.goodConsultVC];
    
    self.totalConsultVC = [[TotalZixunViewController alloc]init];
    self.totalConsultVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.totalConsultVC.idNumber = self.idNumber;

    [self.view addSubview:topBGView];
    
    //熟人圈按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [relationBtn setTitle:@"熟人咨询" forState:UIControlStateNormal];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    relationBtn.selected = YES;
    [topBGView addSubview:relationBtn];
    
    //关系圈按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [circleBtn setTitle:@"全部咨询" forState:UIControlStateNormal];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [circleBtn addTarget:self action:@selector(circleBtn:) forControlEvents:UIControlEventTouchUpInside];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:circleBtn];
    
    
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y , SCREEN_WIDTH / 2, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
}

- (void)backBtn:(id)sender
{
    isisBack = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"asd" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
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
    if (isisBack) {
        [self.goodConsultVC removeFromParentViewController];
        [self.goodConsultVC.view removeFromSuperview];
        [self.totalConsultVC removeFromParentViewController];
        [self.totalConsultVC.view removeFromSuperview];
        
    }
}

#pragma mark - 两个button点击事件
- (void)relationBtn:(UIButton *)sender
{
    [self.goodConsultVC.view endEditing:YES];
    [self.totalConsultVC.view endEditing:YES];
    circleBtn.selected = NO;
    relationBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.goodConsultVC.tableView headerBeginRefreshing];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    [self.goodConsultVC.view endEditing:YES];
    [self.totalConsultVC.view endEditing:YES];
    relationBtn.selected = NO;
    circleBtn.selected = YES;
    if (!secondVC) {
        [self.sv addSubview:self.totalConsultVC.view];
        [self addChildViewController:self.totalConsultVC];
        secondVC = YES;
    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.totalConsultVC.tableView headerBeginRefreshing];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        circleBtn.selected = NO;
        relationBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        relationBtn.selected = NO;
        circleBtn.selected = YES;
        if (!secondVC) {
            [self.sv addSubview:self.totalConsultVC.view];
            [self addChildViewController:self.totalConsultVC];
            secondVC = YES;
            
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.goodConsultVC.view endEditing:YES];
    [self.totalConsultVC.view endEditing:YES];
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
