//
//  ZZGoPayViewController2.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/19.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//
#define MARGIN 20
#define SP_URL @"http://mapi.shurenbang.net/pay/bang.action"

#import "ZZGoPayViewController.h"
#import "PersonalSPController.h"
#import "NewsCenterViewController.h"
#import "OrderDetailController.h"
#import "CreateGetMoneyViewController.h"
#import "MJRefresh.h"
#import "WQPasswordInput.h"
#import "AppDelegate.h"
#import "AlipayWrapper.h"
#import "WQAlertView.h"
#import "ZZOrderModel.h"
#import "RechargeViewController.h"
#import "WXApi.h"
#import "NewsCenterMainViewController.h"

@interface ZZGoPayViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
{
    //UITextField *_textFieldPass;
    WQPasswordInput *_passwordView;
    MBProgressHUD *_hud;
    NSString * _balance;
    
    NSDictionary * _userAccountDic;
    
    ZZOrderModel *_orderModel;
}
@end

@implementation ZZGoPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess) name:@"WXSuccess" object:nil];
    [self listenKeyboard];
    
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    //导航
    self.title = @"我的订单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    //内容
    [self.contentSV addSubview:self.logisticsView];
    self.logisticsView.hidden = YES;
    [self.contentSV addSubview:self.orderView];
    self.orderView.hidden = YES;
    [self.contentSV addSubview:self.payStyleView];
    self.payStyleView.hidden = YES;
    //下拉
    [self.contentSV addHeaderWithTarget:self action:@selector(headerReferensh)];
    [self.contentSV headerBeginRefreshing];
    
    //密码输入
    _passwordView = [[WQPasswordInput alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 150)];
    [_passwordView.confirmBtn addTarget:self action:@selector(balancePayRequest) forControlEvents:UIControlEventTouchUpInside];
    [_passwordView.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passwordView];
    _passwordView.hidden = YES;
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.logisticsView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentSV.frame), CGRectGetHeight(self.logisticsView.frame));
    self.orderView.frame = CGRectMake(0, CGRectGetMaxY(self.logisticsView.frame) + MARGIN, CGRectGetWidth(self.contentSV.frame), CGRectGetHeight(self.orderView.frame));
    self.payStyleView.frame = CGRectMake(0, CGRectGetMaxY(self.orderView.frame) + MARGIN, CGRectGetWidth(self.contentSV.frame), CGRectGetHeight(self.orderView.frame));
    
    self.contentSV.contentSize = CGSizeMake(0, CGRectGetMaxY(self.payStyleView.frame) + MARGIN);
}
#pragma mark- 数据
-(void)fillData {
    self.logisticsView.hidden = NO;
    self.orderView.hidden = NO;
    self.payStyleView.hidden = NO;
    
    //地址
    self.userLbl.text = [NSString stringWithFormat:@"%@  %@", _orderModel.contacterName, _orderModel.mobile];
    self.addressLbl.text = _orderModel.address;
    
    //订单
    if (_orderModel.goods && _orderModel.goods > 0) {
        NSDictionary *goodsDic = _orderModel.goods[0];
        self.brandLbl.text = goodsDic[@"brand"];
        self.nameLbl.text = goodsDic[@"title"];
        self.priceLbl.text = goodsDic[@"price"];
        self.countLbl.text = [NSString stringWithFormat:@"x %@", goodsDic[@"num"]];
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:goodsDic[@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    }
    self.orderNum.text = [NSString stringWithFormat:@"订单号  %@", _orderModel.orderNum];
    self.transPriceLbl.text = [NSString stringWithFormat:@"￥%@", _orderModel.transportPrice];
    self.orderPriceLbl.text = [NSString stringWithFormat:@"￥%@", _orderModel.orderAmount];    
    //用户个人
    self.balanceLbl.text = [NSString stringWithFormat:@"￥%@", _balance];
}
#pragma mark- 事件
- (IBAction)payselBtnClicked:(UIButton *)sender {
    self.balanceBtn.selected = NO;
    self.alipayBtn.selected = NO;
    self.weixinBtn.selected = NO;
    sender.selected = YES;
}
- (IBAction)payLaterBtnClicked:(id)sender {
    [self showLaterOnPayAlert];
}

- (IBAction)confirmPayClicked:(id)sender {
    if (self.balanceBtn.selected) {
        [self vertifyPayRequst];
    }else if (self.alipayBtn.selected) {
        [self goAlipay];
    }else {
        [self goWeiXinPay];
    }
}
-(void)backToVC {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PersonalSPController class]]) {
            //刷新代购单
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPOrderPaySuccessNF" object:nil];
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }else if ([vc isKindOfClass:[NewsCenterMainViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)headerReferensh {
    [self loadOrderDetail];
}
//显示密码输入框
-(void)showPasswordView {
    [_passwordView.inputPwdTF becomeFirstResponder];
}
//取消密码输入框
-(void)cancelBtnClicked {
    [_passwordView.inputPwdTF resignFirstResponder];
}
//微信支付成功
-(void)weixinPaySuccess {
    [AutoDismissAlert autoDismissAlert:@"支付成功"];
    [self backToVC];
}
#pragma mark- 稍后支付
//稍后支付
-(void)showLaterOnPayAlert {
    NSString *message = @"请尽快完成支付！代购人可能会改价，请注意核对金额";
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:nil Message:message ConfirmName:@"确认" CancelName:@"取消" ConfirmBlock:^{
        [self laterOnPayClicked];
    } CancelBlock:nil];
}
-(void)laterOnPayClicked {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[OrderDetailController class]] || [vc isKindOfClass:[PersonalSPController class]]){
            if ([vc isKindOfClass:[PersonalSPController class]]) {
                PersonalSPController *pvc = (PersonalSPController *)vc;
                [pvc reloadCurrentViewData];
            }
            if ([vc isKindOfClass:[OrderDetailController class]]) {
                OrderDetailController *pvc = (OrderDetailController *)vc;
                [pvc loadSPOrderDetail];
            }
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }else if([vc isKindOfClass:[NewsCenterViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
            return ;
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12345) {
        if (buttonIndex == 1) {
            CreateGetMoneyViewController * createGetMoneyVC = [[CreateGetMoneyViewController alloc]init];
            [self.navigationController pushViewController:createGetMoneyVC animated:YES];
        }
    }else if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            [self laterOnPayClicked];
        }
    }else{
        if (buttonIndex == 1) {
            [self showPasswordView];
        }
    }
    
}
#pragma mark- 网络请求
//验证是否可以支付
- (void)vertifyPayRequst
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在验证，请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountGetInfo" parameters:@{@"account":name,@"password":pass}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            if ([_balance doubleValue] < [_orderModel.orderAmount doubleValue]) {
                [AutoDismissAlert autoDismissAlert:@"余额不足"];
                return;
            }
            if ([[[dic objectForKey:@"data"]objectForKey:@"paypass"]isEqualToString:@"1"]) {
                [self showPayAlert:[NSString stringWithFormat:@"您要支付的金额为%@元，付款后剩余%.2f元",_orderModel.orderAmount,[_balance doubleValue] - [_orderModel.orderAmount doubleValue]]];
            }else{
                CreateGetMoneyViewController * vc = [[CreateGetMoneyViewController alloc]init];
                vc.point = @"fukuan";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }

    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
    
}
-(void)showPayAlert:(NSString *)message {
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:nil Message:message ConfirmName:@"确认" CancelName:@"取消" ConfirmBlock:^{
        [self showPasswordView];
    } CancelBlock:nil];
}
//余额支付
- (void)balancePayRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    NSDictionary * dic = [self parametersForDic:@"accountPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID, @"paypass": _passwordView.inputPwdTF.text, @"value": _orderModel.orderAmount}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [self backToVC];
        }else if ([result isEqualToString:@"4030001"]){
            //余额不足
            [self showChargeAlert];
        }else {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [hud removeFromSuperview];
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
}
-(void)showChargeAlert {
    NSString *message = [NSString stringWithFormat:@"您的账户余额￥%@元，不足以支付押金，立即充值？", _balance];
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:@"提示" Message:message ConfirmName:@"确认" CancelName:@"取消" ConfirmBlock:^{
        RechargeViewController *vc = [[RechargeViewController alloc] init];
        vc.backBlock = ^(void){
            [self.contentSV headerBeginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } CancelBlock:nil];
}
//获取用户账户信息
- (void)loadUserAccountRequest
{
    //[activity startAnimating];
    NSDictionary * tempdic = [self parametersForDic:@"accountGetInfo" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [_contentSV headerEndRefreshing];
        if ([result isEqualToString:@"0"]) {
            _userAccountDic = [dic objectForKey:@"data"];
            _balance = _userAccountDic[@"balance"];
            [self fillData];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        [_hud removeFromSuperview];
        //[activity stopAnimating];
    } andFailureBlock:^{
        //[activity stopAnimating];
        [_contentSV headerEndRefreshing];
        [_hud removeFromSuperview];
    }];
}
//获取订单详情
-(void)loadOrderDetail {
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.labelText = @"获取信息中,请稍后";
//    _hud.dimBackground = YES;
//    [_hud show:YES];
    
    NSDictionary * param = [self parametersForDic:@"accountGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            ZZOrderModel *model = [[ZZOrderModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
            _orderModel = model;
            [self loadUserAccountRequest];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[_hud removeFromSuperview];
        }
        
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
- (void) goAlipay {
    
    NSDictionary * goodsDic = [_orderModel.goods objectAtIndex:0];
    //支付
    [AlipayWrapper alipaySyncPay:_orderModel.orderNum amount:[_orderModel.orderAmount floatValue] productName:[goodsDic objectForKey:@"title"] desc:[goodsDic objectForKey:@"title"] orderID:@"" success:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
        [AutoDismissAlert autoDismissAlert:@"支付成功"];
        [self backToVC];
    } failure:^(NSDictionary *resultDic) {
        [AutoDismissAlert autoDismissAlert:@"支付失败"];
        NSLog(@"%@",resultDic);
    }];
}
-(void)goWeiXinPay {
    //从服务器获取支付参数，服务端自定义处理逻辑和格式
    //订单标题
    //NSString *ORDER_NAME    = @"Ios服务器端签名支付 测试";
    //订单金额，单位（元）
    //NSString *ORDER_PRICE   = @"0.01";
    
    //根据服务器端编码确定是否转码
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取信息中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *urlString = [NSString stringWithFormat:@"%@?orderPayId=%@&payAccess=%@",
                           SP_URL,
                           _orderModel.orderId,
                           @"weipayapp"];
    
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        [hud hide:YES];
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            //NSMutableString *retcode = [dict objectForKey:@"retcode"];
            //if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            //            }else{
            //                //[self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
            //                [MBProgressHUD showError:[dict objectForKey:@"retmsg"]];
            //            }
        }else{
            //[hud hide:YES];
            //[self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
            //[MBProgressHUD showError:@"服务器返回错误，未获取到json对象"];
        }
    }else{
        [hud hide:YES];
        //[MBProgressHUD showError:@"服务器返回错误"];
        //[self alert:@"提示信息" msg:@"服务器返回错误"];
    }
}

#pragma mark - Keyboard NSNotification
-(void)listenKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _passwordView.hidden = NO;
    self.blackView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _passwordView.y = keyBoardRect.origin.y-_passwordView.height-64;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    _blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _passwordView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _passwordView.hidden = YES;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
