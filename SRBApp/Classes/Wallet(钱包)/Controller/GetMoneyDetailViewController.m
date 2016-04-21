//
//  GetMoneyDetailViewController.m
//  SRBApp
//
//  Created by zxk on 15/4/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GetMoneyDetailViewController.h"

@interface GetMoneyDetailViewController ()

@end

@implementation GetMoneyDetailViewController
{
    UIScrollView * mainScrollView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customInit];
    self.title = @"提现详情";
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:mainScrollView];
    
    
    //提现号
    UIView * numView = [self customViewWithImage:@"提现号" andContent:self.drawRecordModel.num ];
    numView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    [mainScrollView addSubview: numView];
    
    //提现状态
    UIView * stateView = [self customViewWithImage:@"状态" andContent:self.drawRecordModel.statusName ];
    stateView.frame = CGRectMake(0, CGRectGetMaxY(numView.frame) + 1, SCREEN_WIDTH, 40);
    [mainScrollView addSubview: stateView];
    
    //提现时间
    UIView * getTimeView = [self customViewWithImage:@"提现时间" andContent:self.drawRecordModel.updatetime];
    getTimeView.frame = CGRectMake(0, CGRectGetMaxY(stateView.frame) + 1, SCREEN_WIDTH, 40);
    [mainScrollView addSubview:getTimeView];
    
    //提现金额
    UIView * moneyView = [self customViewWithImage:@"提现金额" andContent:[NSString stringWithFormat:@"¥ %@",self.drawRecordModel.withdrawCash]];
    moneyView.frame = CGRectMake(0, CGRectGetMaxY(getTimeView.frame) + 1, SCREEN_WIDTH, 40);
    [mainScrollView addSubview:moneyView];
    
    //支付宝
    UIView * aliNumView = [self customViewWithImage:@"支付宝" andContent:self.drawRecordModel.zhifubao];
    aliNumView.frame = CGRectMake(0, CGRectGetMaxY(moneyView.frame) + 1, SCREEN_WIDTH, 40);
    [mainScrollView addSubview:aliNumView];
    
    //提现备注
    UIView * remarkView = [self customViewWithImage:@"提现备注" andContent:self.drawRecordModel.remark];
    remarkView.frame = CGRectMake(0, CGRectGetMaxY(aliNumView.frame) + 1, SCREEN_WIDTH, 40);
    [mainScrollView addSubview: remarkView];
    
    
    if ([self.drawRecordModel.status isEqualToString:@"100"]) {
        //付款时间
        UIView * giveTimeView = [self customViewWithImage:@"付款时间" andContent:self.drawRecordModel.endtime];
        giveTimeView.frame = CGRectMake(0, CGRectGetMaxY(remarkView.frame) + 10, SCREEN_WIDTH, 40);
        [mainScrollView addSubview: giveTimeView];
        
        //付款金额
        UIView * giveMoneyView = [self customViewWithImage:@"付款金额" andContent:[NSString stringWithFormat:@"¥ %@",self.drawRecordModel.payfee]];
        giveMoneyView.frame = CGRectMake(0, CGRectGetMaxY(giveTimeView.frame) + 1, SCREEN_WIDTH, 40);
        [mainScrollView addSubview: giveMoneyView];
        
        //手续费
        UIView * feeView = [self customViewWithImage:@"手续费" andContent:[NSString stringWithFormat:@"¥ %@",self.drawRecordModel.fee]];
        feeView.frame = CGRectMake(0, CGRectGetMaxY(giveMoneyView.frame) + 1, SCREEN_WIDTH, 40);
        [mainScrollView addSubview: feeView];
        
        //付款备注
        UIView * beizhuView = [self customViewWithImage:@"付款备注" andContent:self.drawRecordModel.memo];
        beizhuView.frame = CGRectMake(0, CGRectGetMaxY(feeView.frame) + 1, SCREEN_WIDTH, 40);
        [mainScrollView addSubview: beizhuView];
        mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(beizhuView.frame) + 10);
    }else{
        mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(remarkView.frame) + 10);
    }
    
}

- (UIView *)customViewWithImage:(NSString *)leftTitle andContent:(NSString *)content
{
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = WHITE;
    
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    leftLabel.text = leftTitle;
    leftLabel.textColor = [UIColor grayColor];
    leftLabel.font = SIZE_FOR_14;
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:leftLabel];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH - 50, 20)];
    contentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    contentLabel.font = SIZE_FOR_IPHONE;
    if (content == nil || [content isEqualToString:@""] || content.length == 0) {
        content = @"无";
    }
    contentLabel.text = content;
    contentLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:contentLabel];
    return bgView;
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
