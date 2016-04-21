//
//  EvaluateViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EvaluateViewController.h"


@interface EvaluateViewController ()

@end

@implementation EvaluateViewController
{
    BOOL secondVC;
    BOOL isisBack;
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
    self.title = @"交易评价";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self customInit];
    
    
}

- (void)backBtn:(id)sender
{
    isisBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化控件
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
    
    self.goodFriendVC = [[GoodFriendViewController alloc]init];
    self.goodFriendVC.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.goodFriendVC.idNumber = self.idNumber;
    [self.sv addSubview:self.goodFriendVC.view];
    [self addChildViewController:self.goodFriendVC];
    
    self.totalEvaluateVC = [[TatolEvaluateViewController alloc]init];
    self.totalEvaluateVC.tableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39);
    self.totalEvaluateVC.idNumber = self.idNumber;
    
    [self.view addSubview:topBGView];
    
    //熟人圈按钮
    relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relationBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [relationBtn setTitle:@"熟人评价" forState:UIControlStateNormal];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [relationBtn addTarget:self action:@selector(relationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [relationBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    relationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    relationBtn.selected = YES;
    [topBGView addSubview:relationBtn];
    
    //关系圈按钮
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [circleBtn setTitle:@"全部评价" forState:UIControlStateNormal];
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
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (isisBack) {
    [self.totalEvaluateVC removeFromParentViewController];
    [self.totalEvaluateVC.view removeFromSuperview];
    [self.goodFriendVC removeFromParentViewController];
    [self.goodFriendVC.view removeFromSuperview];
    }
}

#pragma mark - 两个button点击事件
- (void)relationBtn:(UIButton *)sender
{
    circleBtn.selected = NO;
    relationBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, relationBtn.frame.size.height + relationBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.goodFriendVC urlRequestPost];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)circleBtn:(UIButton *)sender
{
    relationBtn.selected = NO;
    circleBtn.selected = YES;
    if (!secondVC) {
        [self.sv addSubview:self.totalEvaluateVC.view];
        [self addChildViewController:self.totalEvaluateVC];
        secondVC = YES;

    }
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.totalEvaluateVC urlRequestPost];
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
        [self.goodFriendVC urlRequestPost];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        relationBtn.selected = NO;
        circleBtn.selected = YES;
        if (!secondVC) {
            [self.sv addSubview:self.totalEvaluateVC.view];
            [self addChildViewController:self.totalEvaluateVC];
            secondVC = YES;
            
        }
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, circleBtn.frame.size.height + circleBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self.totalEvaluateVC urlRequestPost];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }

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
