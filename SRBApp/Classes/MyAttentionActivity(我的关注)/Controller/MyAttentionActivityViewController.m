//
//  MyAttentionActivityViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyAttentionActivityViewController.h"
#import "MyVipTableViewController.h"
#import "MyInfoTableViewController.h"
#import "MJRefresh.h"

@interface MyAttentionActivityViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) MyVipTableViewController *vipTVC;
@property (nonatomic, strong) MyInfoTableViewController *infoTVC;
@property (nonatomic, strong) UIScrollView *sv;

@property (nonatomic, strong) NSMutableArray *vipArray;
@property (nonatomic, strong) NSMutableArray *infoArray;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation MyAttentionActivityViewController
{
    UIView * lineView;
    UIButton * vipBtn;
    UIButton * infoBtn;
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
    self.title = @"关注收藏";
    //编辑按钮
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 100/2, 50/2);
    self.rightBtn.backgroundColor = [UIColor whiteColor];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 2;
    [self.rightBtn setTitle:@"编 辑" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];


    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self customInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnStateVip) name:@"Vip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnStateInfo) name:@"Info" object:nil];
    

}
//编辑与完成按钮
- (void)editButtonClick
{
    if (self.sv.contentOffset.x == 0) {
        [self.vipTVC navigationEditButtonClick:self.rightBtn];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        [self.infoTVC navigationEditButtonClick:self.rightBtn];
    }
}

//
- (void)changeBtnStateVip
{
    [self.vipTVC navigationEditButtonClick:self.rightBtn];
}

- (void)changeBtnStateInfo
{
    [self.infoTVC navigationEditButtonClick:self.rightBtn];
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 初始化控件
- (void)customInit
{

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    //顶部背景
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    topBGView.layer.shadowColor = [GetColor16 hexStringToColor:@"#eeeeee"].CGColor;
    topBGView.layer.shadowOpacity = 2;
    topBGView.layer.shadowOffset = CGSizeMake(0, 2);
    topBGView.layer.shadowRadius = 2;
    [self.view addSubview:topBGView];
    
    //vip按钮
    vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 38);
    [vipBtn setTitle:@"用户" forState:UIControlStateNormal];
    [vipBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [vipBtn addTarget:self action:@selector(vipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [vipBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    vipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    vipBtn.selected = YES;
    [topBGView addSubview:vipBtn];
    //信息按钮
    infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38);
    [infoBtn setTitle:@"信息" forState:UIControlStateNormal];
    [infoBtn setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(infoBtn:) forControlEvents:UIControlEventTouchUpInside];
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [infoBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    [topBGView addSubview:infoBtn];
    //底部横线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, vipBtn.frame.size.height + vipBtn.frame.origin.y - 1, SCREEN_WIDTH / 2, 1.5)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [topBGView addSubview:lineView];
    
    //scrollerView
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y - 1, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    self.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 64 - 40);
    self.sv.pagingEnabled = YES;
    self.sv.delegate = self;
    self.sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.sv];
    
    self.vipTVC = [[MyVipTableViewController alloc]init];
    
    self.vipTVC.tableView.frame = CGRectMake(0, topBGView.frame.size.height + topBGView.frame.origin.y-40, SCREEN_WIDTH, SCREEN_HEIGHT - 64-40);
    [self.sv addSubview:self.vipTVC.view];
    [self addChildViewController:self.vipTVC];
    
    self.infoTVC = [[MyInfoTableViewController alloc]init];
    self.infoTVC.tableView.frame = CGRectMake(SCREEN_WIDTH, topBGView.frame.size.height + topBGView.frame.origin.y-40, SCREEN_WIDTH, SCREEN_HEIGHT - 64-40);
    [self.sv addSubview:self.infoTVC.view];
    [self addChildViewController:self.infoTVC];

}


#pragma mark - 两个button点击事件
- (void)vipBtn:(UIButton *)sender
{
    infoBtn.selected = NO;
    vipBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(0, vipBtn.frame.size.height + vipBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.vipTVC urlRequestForVIP];
    self.sv.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)infoBtn:(UIButton *)sender
{
    vipBtn.selected = NO;
    infoBtn.selected = YES;
    [UIView beginAnimations:@"lineview" context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, infoBtn.frame.size.height + infoBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
    [self.infoTVC urlRequestForVIP];
    self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    [UIView commitAnimations];

}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"滑动结束。。。。。。。。");
    if (self.sv.contentOffset.x == 0) {
        infoBtn.selected = NO;
        vipBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(0, vipBtn.frame.size.height + vipBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self cancelEditingWithInfoTableView:self.infoTVC];
        [self.vipTVC urlRequestForVIP];
        [UIView commitAnimations];
    }
    if (self.sv.contentOffset.x == SCREEN_WIDTH) {
        vipBtn.selected = NO;
        infoBtn.selected = YES;
        [UIView beginAnimations:@"lineview" context:nil];
        [UIView setAnimationDuration:0.3];
        lineView.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/2, infoBtn.frame.size.height + infoBtn.frame.origin.y - 1, SCREEN_WIDTH/2, 1.5);
        [self.infoTVC urlRequestForVIP];
        [self cancelEditingWithVipTableView:self.vipTVC];
        self.sv.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [UIView commitAnimations];
    }
}

- (void)cancelEditingWithInfoTableView:(MyInfoTableViewController *)tableview
{
    self.rightBtn.selected = NO;
    [self.rightBtn setTitle:@"编 辑" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        tableview.customView.frame = CGRectMake(0, SCREEN_HEIGHT - 56, SCREEN_WIDTH, 42);
    }];
    
    [tableview setEditing:NO animated:YES];
}

- (void)cancelEditingWithVipTableView:(MyVipTableViewController *)tableview
{
    self.rightBtn.selected = NO;
    [self.rightBtn setTitle:@"编 辑" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        tableview.customView.frame = CGRectMake(0, SCREEN_HEIGHT - 56, SCREEN_WIDTH, 42);
    }];
    
    [tableview setEditing:NO animated:YES];
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
