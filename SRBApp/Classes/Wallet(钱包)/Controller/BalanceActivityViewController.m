//
//  BalanceActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BalanceActivityViewController.h"
#import "RechargeViewController.h"
#import "WithdrawActivityViewController.h"

@interface BalanceActivityViewController ()
{
    UILabel * _labelPrice;
    UILabel * _labelDongJiew;
    UILabel * _labelTotalChongZhi;
    UILabel * _labelTotalTiXian;
    UILabel * yueTitleLabel;
    UILabel * dongjieLabel;
    MyImgView * titleImg;
}
@end

@implementation BalanceActivityViewController

- (void)viewDidAppear:(BOOL)animated
{
    [self post];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账户余额";
    
    titleImg = [[MyImgView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 70)/2, 45, 70, 70)];
    titleImg.image = [UIImage imageNamed:@"mywallet_money"];
    [self.view addSubview:titleImg];
    

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    yueTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, titleImg.frame.origin.y + titleImg.frame.size.height + 28, 80, 17)];
    yueTitleLabel.text = @"账户余额：";
    yueTitleLabel.textAlignment = NSTextAlignmentCenter;
    yueTitleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    yueTitleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:yueTitleLabel];
    
    _labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(yueTitleLabel.frame.size.width + yueTitleLabel.frame.origin.x, titleImg.frame.origin.y + titleImg.frame.size.height + 24, SCREEN_WIDTH, 28)];
    [_labelPrice setTextColor:[GetColor16 hexStringToColor:@"#e5005d"]];
    _labelPrice.font = [UIFont systemFontOfSize:25];
    _labelPrice.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_labelPrice];
    
    dongjieLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, _labelPrice.frame.origin.y + _labelPrice.frame.size.height + 13, 80, 17)];
    dongjieLabel.text = @"等待结款：";
    dongjieLabel.textAlignment = NSTextAlignmentCenter;
    dongjieLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    dongjieLabel.font = SIZE_FOR_14;
    [self.view addSubview:dongjieLabel];
    
    _labelDongJiew = [[UILabel alloc]initWithFrame:CGRectMake(dongjieLabel.frame.size.width + dongjieLabel.frame.origin.x, _labelPrice.frame.origin.y + _labelPrice.frame.size.height + 12, SCREEN_WIDTH, 18)];
    [_labelDongJiew setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    _labelDongJiew.font = [UIFont systemFontOfSize:15];
    _labelDongJiew.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_labelDongJiew];
    
    
    UIButton * chongzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chongzhiBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#e5005d"]];
    [chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    chongzhiBtn.frame = CGRectMake(25, _labelDongJiew.frame.size.height + _labelDongJiew.frame.origin.y + 27, SCREEN_WIDTH - 50, 40);
    chongzhiBtn.layer.masksToBounds = YES;
    chongzhiBtn.layer.cornerRadius = 2;
    [chongzhiBtn addTarget:self action:@selector(chongzhi:) forControlEvents:UIControlEventTouchUpInside];
    [chongzhiBtn setTitle:@"充 值" forState:UIControlStateNormal];
    [chongzhiBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:chongzhiBtn];
    
    UIButton * tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tixianBtn setBackgroundImage:[UIImage imageNamed:@"button_pink(1)"] forState:UIControlStateNormal];
    [tixianBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateHighlighted];
    tixianBtn.frame = CGRectMake(25, chongzhiBtn.frame.size.height + chongzhiBtn.frame.origin.y + 15, SCREEN_WIDTH - 50, 40);
    tixianBtn.layer.masksToBounds = YES;
    tixianBtn.layer.cornerRadius = 2;
    [tixianBtn addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    [tixianBtn setTitle:@"提 现" forState:UIControlStateNormal];
    [tixianBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    tixianBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:tixianBtn];
    
    UILabel * chongzhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, tixianBtn.frame.origin.y + tixianBtn.frame.size.height + 40, 70, 17)];
    chongzhiLabel.font = SIZE_FOR_14;
    [chongzhiLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    chongzhiLabel.text = @"累计充值：";
    [self.view addSubview:chongzhiLabel];
    
    _labelTotalChongZhi = [[UILabel alloc]initWithFrame:CGRectMake(chongzhiLabel.frame.size.width + chongzhiLabel.frame.origin.x + 30, chongzhiLabel.frame.origin.y, 150, 17)];
    _labelTotalChongZhi.font = SIZE_FOR_14;
    [_labelTotalChongZhi setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    _labelTotalChongZhi.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_labelTotalChongZhi];
    
    UILabel * tixianLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, chongzhiLabel.frame.origin.y + chongzhiLabel.frame.size.height + 10, 70, 17)];
    tixianLabel.font = SIZE_FOR_14;
    [tixianLabel setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    tixianLabel.text = @"累计提现：";
    [self.view addSubview:tixianLabel];
    
    _labelTotalTiXian = [[UILabel alloc]initWithFrame:CGRectMake(tixianLabel.frame.size.width + tixianLabel.frame.origin.x + 30, tixianLabel.frame.origin.y, 150, 17)];
    _labelTotalTiXian.font = SIZE_FOR_14;
    [_labelTotalTiXian setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    _labelTotalTiXian.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_labelTotalTiXian];
    
}

- (void)chongzhi:(UIButton *)sender
{
    RechargeViewController * rechargeVC = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)tixian:(UIButton *)sender
{
    WithdrawActivityViewController * withdrawVC = [[WithdrawActivityViewController alloc]init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//post请求
- (void)post
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];

    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetInfo" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            _labelPrice.text = [NSString stringWithFormat:@"￥ %@", [self objectForKeyNew:dic1 key:@"balance"]];
            [_labelPrice sizeToFit];
            CGFloat tempFloat = _labelPrice.frame.size.width;
            yueTitleLabel.frame = CGRectMake((SCREEN_WIDTH - tempFloat - 80)/2, titleImg.frame.size.height + titleImg.frame.origin.y + 28, 80, 17);
            _labelPrice.frame = CGRectMake(yueTitleLabel.frame.size.width + yueTitleLabel.frame.origin.x, titleImg.frame.size.height + titleImg.frame.origin.y + 24, tempFloat, 27);
            
            _labelDongJiew.text = [NSString stringWithFormat:@"￥ %@", [self objectForKeyNew:dic1 key:@"freeze"]];
            [_labelDongJiew sizeToFit];
            
            CGFloat dongjieRect = _labelDongJiew.frame.size.width;
            dongjieLabel.frame = CGRectMake((SCREEN_WIDTH - dongjieRect - 70)/2, _labelPrice.frame.origin.y + _labelPrice.frame.size.height + 13, 70, 17);
            _labelDongJiew.frame = CGRectMake(dongjieLabel.frame.size.width + dongjieLabel.frame.origin.x, _labelPrice.frame.origin.y + _labelPrice.frame.size.height + 12, dongjieRect, 18);
            
            _labelTotalChongZhi.text = [NSString stringWithFormat:@"￥ %@", [self objectForKeyNew:dic1 key:@"totalMoneyAddPay"]];
            _labelTotalTiXian.text = [NSString stringWithFormat:@"￥ %@", [self objectForKeyNew:dic1 key:@"totalMoneyToCash"]];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}

//没有数据记录时的判断
- (NSString *)objectForKeyNew:(NSDictionary *)dic key:(NSString *)key
{
    if ([dic objectForKey:key] == nil) {
        return @"0.00";
    }
    return [dic objectForKey:key];
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
