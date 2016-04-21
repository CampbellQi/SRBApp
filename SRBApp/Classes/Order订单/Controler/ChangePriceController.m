//
//  ChangePriceController.m
//  SRBApp
//
//  Created by fengwanqi on 15/12/1.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ChangePriceController.h"
#import "CommonView.h"

@interface ChangePriceController ()

@end

@implementation ChangePriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改价格";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    //self.confirmBtn.layer.cornerRadius = 4.0f;
    
    self.totalView.layer.masksToBounds = YES;
    self.totalView.layer.cornerRadius = 4.0f;
    self.totalView.layer.borderColor = GRAYCOLOR.CGColor;
    self.totalView.layer.borderWidth = 0.5f;
    
    [_priceTF addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    [_freightTF addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"确 定" Target:self Action:@selector(confirmBtnClicked)];
    
    [self loadSPOrderDetail];
}

-(void)valueChanged{
    NSString * totalprice = [NSString stringWithFormat:@"%.2f",[self.priceTF.text floatValue] + [self.freightTF.text floatValue]];
    self.totalpriceTF.text = totalprice;
}
-(void)fillData {
    if (self.sourceModel) {
        self.priceTF.text = self.sourceModel.goodsAmount;
        self.freightTF.text =self.sourceModel.transportPrice;
//        NSString * totalprice = [NSString stringWithFormat:@"%.2f",[self.sourceModel.goodsAmount floatValue] + [self.sourceModel.transportPrice floatValue]];
        self.totalpriceTF.text = self.sourceModel.orderAmount;
    }
}
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadSPOrderDetail {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"sellerGetOrder" parameters:@{ACCOUNT_PASSWORD, @"orderId": self.sourceModel.taskOrderFormId}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
            self.sourceModel = model;
            [self fillData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
            
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
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

//- (IBAction)confirmBtnClicked:(id)sender {
//    [self uploadRequest];
//}

-(void)confirmBtnClicked {
    [self uploadRequest];
}
#pragma mark- 网络请求
//付款催单
-(void)uploadRequest {
    NSString *price = self.priceTF.text;
    NSString *freight = self.freightTF.text;
//    NSString * totalprice = [NSString stringWithFormat:@"%.2f",[price floatValue] + [freight floatValue]];
//    self.totalpriceTF.text = totalprice;
    if ([price floatValue] == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写价格"];
        return;
    }
//    if ([freight floatValue] == 0) {
//        [AutoDismissAlert autoDismissAlertSecond:@"请填写运费"];
//        return;
//    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    NSDictionary * param = [self parametersForDic:@"sellerSetOrderModify" parameters:@{ACCOUNT_PASSWORD, @"orderId": self.sourceModel.orderId, @"goodsAmount": price, @"transportPrice": freight, @"confirm": @"1"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.reloadTableDataBlock) {
                self.reloadTableDataBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            if (self.backBlock) {
                self.backBlock();
            }
            
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
    
}
@end
