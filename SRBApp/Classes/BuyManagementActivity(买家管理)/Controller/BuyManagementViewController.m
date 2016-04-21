//
//  BuyManagementViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BuyManagementViewController.h"
#import "CircleView.h"
#import "AppDelegate.h"
#import "ReceiveGoodsTableViewController.h"
#import "MyPublishViewController.h"
#import "SellerManagementTablView.h"
#import "SellerEvaluateListActivityViewController.h"
#import "MyEvaluateListViewController.h"
#import "ZZMyOrderViewController.h"
#import "ZZOrderCustomBtn.h"

@interface BuyManagementViewController ()
//@property (nonatomic,strong)CircleView * waitPayView;
//@property (nonatomic,strong)CircleView * waitSendGoodsView;
//@property (nonatomic,strong)CircleView * waitReGoodsView;
//@property (nonatomic,strong)CircleView * waitCommentView;
/** 待付款 */
@property (nonatomic,weak) UILabel * waitPayNumLabel;
/** 待发货 */
@property (nonatomic,weak) UILabel * waitSendNumLabel;
/** 待收货 */
@property (nonatomic,weak) UILabel * waitReceiveNumLabel;
@end

@implementation BuyManagementViewController
{
    BOOL isBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我是买家";
    isBack = NO;
    [self giveDataToControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self urlRequest];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}

- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
{
    isBack = YES;

    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)hideTabBar {
//    if (self.tabBarController.tabBar.hidden == YES) {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
//    self.tabBarController.tabBar.hidden = YES;
//    
//}
//
//- (void)showTabBar
//
//{
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    
//    else
//        
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
//    self.tabBarController.tabBar.hidden = NO;
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [self hideTabBar];
//}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

#pragma mark - 控件赋值
- (void)giveDataToControl{

    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:scrollView];
    scrollView.delaysContentTouches = NO;

    UIView * orderManagmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    orderManagmentView.backgroundColor = WHITE;
    [scrollView addSubview:orderManagmentView];
    
    //顶部button
    CGFloat btnW = SCREEN_WIDTH / 3;
    CGFloat btnH = 50;
    
    /** 待付款 */
    UIButton * waitPayBtn = [[UIButton alloc]init];
    waitPayBtn.frame = CGRectMake(0, 0, btnW, btnH);
    waitPayBtn.tag = 1000;
    
    [waitPayBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [waitPayBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    [waitPayBtn addTarget:self action:@selector(btnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderManagmentView addSubview:waitPayBtn];
    
    UILabel * waitPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, btnW, 20)];
    waitPayLabel.font = SIZE_FOR_IPHONE;
    waitPayLabel.text = @"待付款";
    waitPayLabel.textColor = [GetColor16 hexStringToColor:@"#999999"];
    waitPayLabel.textAlignment = NSTextAlignmentCenter;
    [waitPayBtn addSubview:waitPayLabel];
    
    UILabel * waitPayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, btnW, 20)];
    waitPayNumLabel.font = SIZE_FOR_IPHONE;
    waitPayNumLabel.text = @"0";
    waitPayNumLabel.textColor = [GetColor16 hexStringToColor:@"#666666"];
    waitPayNumLabel.textAlignment = NSTextAlignmentCenter;
    [waitPayBtn addSubview:waitPayNumLabel];
    self.waitPayNumLabel = waitPayNumLabel;
    
    /** 待发货 */
    UIButton * waitSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    waitSendBtn.frame = CGRectMake(btnW, 0, btnW, btnH);
    waitSendBtn.tag = 1001;
    
    [waitSendBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [waitSendBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    [waitSendBtn addTarget:self action:@selector(btnClickTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderManagmentView addSubview:waitSendBtn];
    
    UILabel * waitSendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, btnW, 20)];
    waitSendLabel.font = SIZE_FOR_IPHONE;
    waitSendLabel.text = @"待发货";
    waitSendLabel.textColor = [GetColor16 hexStringToColor:@"#999999"];
    waitSendLabel.textAlignment = NSTextAlignmentCenter;
    [waitSendBtn addSubview:waitSendLabel];
    
    UILabel * waitSendNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, btnW, 20)];
    waitSendNumLabel.font = SIZE_FOR_IPHONE;
    waitSendNumLabel.text = @"0";
    waitSendNumLabel.textColor = [GetColor16 hexStringToColor:@"#666666"];
    waitSendNumLabel.textAlignment = NSTextAlignmentCenter;
    [waitSendBtn addSubview:waitSendNumLabel];
    self.waitSendNumLabel = waitSendNumLabel;
    
    /** 待收货 */
    UIButton * waitReceiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    waitReceiveBtn.frame = CGRectMake(btnW * 2, 0, btnW, btnH);
    waitReceiveBtn.tag = 1002;
    
    [waitReceiveBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [waitReceiveBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    [waitReceiveBtn addTarget:self action:@selector(btnClickTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderManagmentView addSubview:waitReceiveBtn];
    
    UILabel * waitReceiveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, btnW, 20)];
    waitReceiveLabel.font = SIZE_FOR_IPHONE;
    waitReceiveLabel.text = @"待收货";
    waitReceiveLabel.textColor = [GetColor16 hexStringToColor:@"#999999"];
    waitReceiveLabel.textAlignment = NSTextAlignmentCenter;
    [waitReceiveBtn addSubview:waitReceiveLabel];
    
    UILabel * waitReceiveNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, btnW, 20)];
    waitReceiveNumLabel.font = SIZE_FOR_IPHONE;
    waitReceiveNumLabel.text = @"0";
    waitReceiveNumLabel.textColor = [GetColor16 hexStringToColor:@"#666666"];
    waitReceiveNumLabel.textAlignment = NSTextAlignmentCenter;
    [waitReceiveBtn addSubview:waitReceiveNumLabel];
    self.waitReceiveNumLabel = waitReceiveNumLabel;
    
    for (int i = 0; i < 2; i++) {
        UIImageView * lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(btnW * (i + 1), 12, 1, 25)];
        lineImgView.image = [UIImage imageNamed:@"btnLine"];
        [orderManagmentView addSubview:lineImgView];
    }
    
    
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 80, SCREEN_WIDTH, 50);
    [publishBtn addTarget:self action:@selector(publishTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    UIButton * orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(0, CGRectGetMaxY(publishBtn.frame)+1, SCREEN_WIDTH, 50);
    orderBtn.tag = 1006;
    [orderBtn addTarget:self action:@selector(btnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [orderBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(0, CGRectGetMaxY(orderBtn.frame)+1, SCREEN_WIDTH, 50);
    [commentBtn addTarget:self action:@selector(sellerEvaluateList:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    UIButton * addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, CGRectGetMaxY(commentBtn.frame)+1, SCREEN_WIDTH, 50);
    [addressBtn addTarget:self action:@selector(addressTap:) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateNormal];
    [addressBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateHighlighted];
    
    [scrollView addSubview:publishBtn];
    [scrollView addSubview:orderBtn];
    [scrollView addSubview:commentBtn];
    [scrollView addSubview:addressBtn];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(addressBtn.frame) + 10);

    
    UIImageView * publishImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    publishImg.image = [UIImage imageNamed:@"wodefabu"];
    [publishBtn addSubview:publishImg];
    UILabel * publishLabel = [[UILabel alloc]initWithFrame:CGRectMake(publishImg.frame.size.width + publishImg.frame.origin.x+25, 17, 100, 16)];
    publishLabel.text = @"我的求购";
    publishLabel.font = [UIFont systemFontOfSize:15];
    [publishBtn addSubview:publishLabel];
    UIImageView * detailPublishImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailPublishImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [publishBtn addSubview:detailPublishImg];
    
    
    UIImageView * orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    orderImg.image = [UIImage imageNamed:@"wodedingdan"];
    [orderBtn addSubview:orderImg];
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderImg.frame.size.width + orderImg.frame.origin.x+25, 17, 100, 16)];
    orderLabel.text = @"订单管理";
    orderLabel.font = [UIFont systemFontOfSize:15];
    [orderBtn addSubview:orderLabel];
    UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [orderBtn addSubview:detailImg];
    orderBtn.tag = 1006;
    
    UIImageView * commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    commentImg.image = [UIImage imageNamed:@"wodepingjia"];
    [commentBtn addSubview:commentImg];
    UILabel * commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderImg.frame.size.width + orderImg.frame.origin.x+25, 17, 100, 16)];
    commentLabel.text = @"评价管理";
    commentLabel.font = [UIFont systemFontOfSize:15];
    [commentBtn addSubview:commentLabel];
    UIImageView * detailImgComment = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailImgComment.image = [UIImage imageNamed:@"friendnew_jt"];
    [commentBtn addSubview:detailImgComment];
    
    UIImageView * addressImg = [[UIImageView alloc]initWithFrame:CGRectMake(25, 12.5, 25, 25)];
    addressImg.image = [UIImage imageNamed:@"shouhuodizhi"];
    [addressBtn addSubview:addressImg];
    UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderImg.frame.size.width + orderImg.frame.origin.x+25, 17, 100, 16)];
    addressLabel.text = @"收货地址";
    addressLabel.font = [UIFont systemFontOfSize:15];
    [addressBtn addSubview:addressLabel];
    UIImageView * detailImgAdd = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 18, 5, 10)];
    detailImgAdd.image = [UIImage imageNamed:@"friendnew_jt"];
    [addressBtn addSubview:detailImgAdd];
    
    
    
//    CircleView * waitPayView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2, addressBtn.frame.size.height + addressBtn.frame.origin.y + 40, 88, 88)];
//    waitPayView.backgroundColor = [GetColor16 hexStringToColor:@"#8dc21f"];
//    waitPayView.titleLabel.text = @"待付款";
//    waitPayView.tag = 1000;
//    waitPayView.layer.masksToBounds = YES;
//    waitPayView.layer.cornerRadius = 44;
//    self.waitPayView = waitPayView;
    
    
//    CircleView * waitSendGoodsView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2 + SCREEN_WIDTH/2, addressBtn.frame.size.height + addressBtn.frame.origin.y + 40, 88, 88)];
//    waitSendGoodsView.backgroundColor = [GetColor16 hexStringToColor:@"#2ca6e0"];
//    waitSendGoodsView.titleLabel.text = @"待发货";
//    waitSendGoodsView.tag = 1001;
//    waitSendGoodsView.layer.masksToBounds = YES;
//    waitSendGoodsView.layer.cornerRadius = 44;
//    self.waitSendGoodsView = waitSendGoodsView;
//    
//    CircleView * waitReGoodsView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2, waitPayView.frame.size.height + waitPayView.frame.origin.y + 40, 88, 88)];
//    waitReGoodsView.backgroundColor = [GetColor16 hexStringToColor:@"#c860f4"];
//    waitReGoodsView.titleLabel.text = @"待收货";
//    waitReGoodsView.tag = 1002;
//    waitReGoodsView.layer.masksToBounds = YES;
//    waitReGoodsView.layer.cornerRadius = 44;
//    self.waitReGoodsView = waitReGoodsView;
//    
//    CircleView * waitCommentView= [[CircleView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 88)/2 + SCREEN_WIDTH/2, waitPayView.frame.size.height + waitPayView.frame.origin.y + 40, 88, 88)];
//    waitCommentView.backgroundColor = [GetColor16 hexStringToColor:@"#f29600"];
//    waitCommentView.titleLabel.text = @"待退款";
//    waitCommentView.tag = 1005;
//    waitCommentView.layer.masksToBounds = YES;
//    waitCommentView.layer.cornerRadius = 44;
//    self.waitCommentView = waitCommentView;
//    
//    [scrollView addSubview:waitPayView];
//    [scrollView addSubview:waitSendGoodsView];
//    [scrollView addSubview:waitReGoodsView];
//    [scrollView addSubview:waitCommentView];
//    
//    UITapGestureRecognizer * btnClickTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
//    [waitPayView addGestureRecognizer:btnClickTap];
//    
//    UITapGestureRecognizer * btnClickTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
//    [waitSendGoodsView addGestureRecognizer:btnClickTap2];
//    
//    UITapGestureRecognizer * btnClickTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
//    [waitReGoodsView addGestureRecognizer:btnClickTap3];
//    
//    UITapGestureRecognizer * btnClickTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClickTap:)];
//    [waitCommentView addGestureRecognizer:btnClickTap4];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求
- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"accountGetOrderCount" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        NSDictionary * tempdic = [dic objectForKey:@"data"];
        if ([result isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.waitPayNumLabel.text = [NSString stringWithFormat:@"%@",[tempdic objectForKey:@"nodepositCount"]];
                self.waitSendNumLabel.text = [NSString stringWithFormat:@"%@",[tempdic objectForKey:@"depositCount"]];
                self.waitReceiveNumLabel.text = [NSString stringWithFormat:@"%@",[tempdic objectForKey:@"takeCount"]];
            });
        }else{
            if (![result isEqualToString:@"4"]) {
              [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
}

- (void)addressTap:(UIButton *)clickTap
{
    ReceiveGoodsTableViewController * vc = [[ReceiveGoodsTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)publishTap:(UIButton *)clickTap
{
    MyPublishViewController * vc = [[MyPublishViewController alloc]init];
    vc.dealType = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClickBtn:(UIButton *)sender
{
    ZZMyOrderViewController * sellerManageVC = [[ZZMyOrderViewController alloc]init];
    sellerManageVC.status = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    [self.navigationController pushViewController:sellerManageVC animated:YES];
}

- (void)btnClickTap:(UIButton *)btn
{
    ZZMyOrderViewController * sellerManageVC = [[ZZMyOrderViewController alloc]init];
    sellerManageVC.status = [NSString stringWithFormat:@"%ld",btn.tag - 1000];
    [self.navigationController pushViewController:sellerManageVC animated:YES];
}

- (void)sellerEvaluateList:(UIButton *)clickTap
{
    MyEvaluateListViewController * sellerEvaluateVC = [[MyEvaluateListViewController alloc]init];
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
