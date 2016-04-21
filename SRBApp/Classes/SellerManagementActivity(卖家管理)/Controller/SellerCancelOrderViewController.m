//
//  SellerCancelOrderViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SellerCancelOrderViewController.h"
#import "SGActionView.h"

@interface SellerCancelOrderViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@end

@implementation SellerCancelOrderViewController

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    // Do any additional setup after loading the view.
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.orderIDLabel.text = [self.dataDic objectForKey:@"orderNum"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",[self.dataDic objectForKey:@"orderAmount"]];
    self.cancelLabel.text = @"退款理由";
}

- (void)customInit
{
    [super customInit];
    self.resonLabel.text = @"请选择";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.view endEditing:YES];
        
        NSString * cancelNote = self.textView.text;
        if (cancelNote == nil || [cancelNote isEqualToString:@""] || cancelNote.length == 0) {
            cancelNote = self.resonLabel.text;
        }
        if ([cancelNote isEqualToString:@"请选择"]) {
            [AutoDismissAlert autoDismissAlert:@"请选择退款理由"];
            return;
        }
        [HUD removeFromSuperview];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"提交中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        //过滤空格,以及判断留言是否为空
        NSDictionary * dic = [self parametersForDic:@"sellerSetOrderBack" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID,@"note":cancelNote}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [self.navigationController popViewControllerAnimated:YES];
                //[self.sellerOrderVC urlRequest];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } andFailureBlock:^{
            [HUD hide:YES];
            [HUD removeFromSuperview];
        }];
    }
}

#pragma mark - 提交按钮
- (void)cancelBtn:(UIButton *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定申请退款?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
    
}

#pragma mark - 退货理由点击事件
- (void)resonTap:(UITapGestureRecognizer *)click
{
    //    ZZResonViewController * resonVC = [[ZZResonViewController alloc]init];
    //    resonVC.array = CANCEL_ORDER_RESON;
    //    [[[UIApplication sharedApplication].windows lastObject]addSubview:resonVC.view];
    //    [self addChildViewController:resonVC];
    
    [SGActionView showSheetWithTitle:@"退款理由" itemTitles:SELLER_Cancel_Reson selectedIndex:100 selectedHandle:^(NSInteger index) {
        if (index == 4) {
            self.textBGView.hidden = NO;
            self.otherResonLabel.hidden = NO;
            self.resonLabel.text = @"其他";
        }else{
            self.textBGView.hidden = YES;
            self.otherResonLabel.hidden = YES;
            self.resonLabel.text = SELLER_Cancel_Reson[index];
        }
    }];
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
