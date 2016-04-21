//
//  SellerManagementActivityViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerManagementActivityViewController.h"
#import "SellerManagementTablView.h"
#import "SellerEvaluateListActivityViewController.h"
#import "CircleView.h"

@interface SellerManagementActivityViewController ()

@property (nonatomic,strong)CircleView * waitPayView;
@property (nonatomic,strong)CircleView * waitSendGoodsView;
@property (nonatomic,strong)CircleView * waitReGoodsView;
@property (nonatomic,strong)CircleView * waitCommentView;
@property (weak, nonatomic) IBOutlet UIView *orderSegementView;
@property (weak, nonatomic) IBOutlet UIView *orderEvaluationView;

@end

@implementation SellerManagementActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    self.title = @"卖家管理";
    [self urlRequest];
    [self giveDataToControl];
}

#pragma mark - 控件赋值
- (void)giveDataToControl{
   
    self.orderSegementView.tag = 1005;
    CircleView * waitPayView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2, self.orderEvaluationView.frame.size.height + self.orderEvaluationView.frame.origin.y + 60, 88, 88)];
    waitPayView.backgroundColor = [GetColor16 hexStringToColor:@"#8dc21f"];
    waitPayView.titleLabel.text = @"待付款";
    waitPayView.tag = 1000;
    waitPayView.layer.masksToBounds = YES;
    waitPayView.layer.cornerRadius = 44;
    self.waitPayView = waitPayView;
    
    CircleView * waitSendGoodsView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2 + SCREEN_WIDTH/2, self.orderEvaluationView.frame.size.height + self.orderEvaluationView.frame.origin.y + 60, 88, 88)];
    waitSendGoodsView.backgroundColor = [GetColor16 hexStringToColor:@"#2ca6e0"];
    waitSendGoodsView.titleLabel.text = @"待发货";
    waitSendGoodsView.tag = 1001;
    waitSendGoodsView.layer.masksToBounds = YES;
    waitSendGoodsView.layer.cornerRadius = 44;
    self.waitSendGoodsView = waitSendGoodsView;
    
    CircleView * waitReGoodsView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2, waitPayView.frame.size.height + waitPayView.frame.origin.y + 50, 88, 88)];
    waitReGoodsView.backgroundColor = [GetColor16 hexStringToColor:@"#c860f4"];
    waitReGoodsView.titleLabel.text = @"待收货";
    waitReGoodsView.tag = 1002;
    waitReGoodsView.layer.masksToBounds = YES;
    waitReGoodsView.layer.cornerRadius = 44;
    self.waitReGoodsView = waitReGoodsView;
    
    CircleView * waitCommentView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2 + SCREEN_WIDTH/2, waitPayView.frame.size.height + waitPayView.frame.origin.y + 50, 88, 88)];
    waitCommentView.backgroundColor = [GetColor16 hexStringToColor:@"#f29600"];
    waitCommentView.titleLabel.text = @"待评价";
    waitCommentView.tag = 1003;
    waitCommentView.layer.masksToBounds = YES;
    waitCommentView.layer.cornerRadius = 44;
    self.waitCommentView = waitCommentView;
    
    [self.view addSubview:waitPayView];
    [self.view addSubview:waitSendGoodsView];
    [self.view addSubview:waitReGoodsView];
    [self.view addSubview:waitCommentView];
    
    UITapGestureRecognizer * btnClickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
    [waitPayView addGestureRecognizer:btnClickTap];
    
    UITapGestureRecognizer * btnClickTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
    [waitSendGoodsView addGestureRecognizer:btnClickTap2];
    
    UITapGestureRecognizer * btnClickTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
    [waitReGoodsView addGestureRecognizer:btnClickTap3];
    
    UITapGestureRecognizer * btnClickTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
    [waitCommentView addGestureRecognizer:btnClickTap4];
    
    UITapGestureRecognizer * orderListTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
    [self.orderSegementView addGestureRecognizer:orderListTap];
    
    UITapGestureRecognizer * sellerEvaluateListTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sellerEvaluateList:)];
    [self.orderEvaluationView addGestureRecognizer:sellerEvaluateListTap];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController dismissViewController];
}

#pragma mark - 网络请求
- (void)urlRequest
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"sellerGetOrderCount" parameters:@{@"account":name,@"password":pass}];

    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        NSDictionary * tempdic = [dic objectForKey:@"data"];
        if (result == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.waitPayView.numLabel.text = [tempdic objectForKey:@"nodepositCount"];
                self.waitSendGoodsView.numLabel.text = [tempdic objectForKey:@"depositCount"];
                self.waitReGoodsView.numLabel.text = [tempdic objectForKey:@"takeCount"];
                self.waitCommentView.numLabel.text = [tempdic objectForKey:@"commentCount"];
            });
        }else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"发送请求失败"];
        }
    }];
}

- (void)btnClickTap:(UITapGestureRecognizer *)clickTap
{
    UIView * view = clickTap.view;
    SellerManagementTablView * sellerManageVC = [[SellerManagementTablView alloc]init];
    sellerManageVC.orderType = [NSString stringWithFormat:@"%lu",view.tag - 1000];
    [self.navigationController pushViewController:sellerManageVC animated:YES];
}

- (void)sellerEvaluateList:(UITapGestureRecognizer *)clickTap
{
    SellerEvaluateListActivityViewController * sellerEvaluateVC = [[SellerEvaluateListActivityViewController alloc]init];
    [self.navigationController pushViewController:sellerEvaluateVC animated:YES];
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
