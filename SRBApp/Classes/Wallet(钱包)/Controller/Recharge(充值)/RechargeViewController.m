//
//  RechargeViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeListViewController.h"
#import "UITextField+MyText.h"
#import "RechargeListModel.h"
#import "AlipayWrapper.h"

@interface RechargeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chargeNumText;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;

@end

@implementation RechargeViewController
{
    BOOL isHaveDian;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"账户充值";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self customInit];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    self.chargeNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.chargeNumText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.chargeNumText.borderStyle = UITextBorderStyleNone;
    [self.chargeNumText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.chargeNumText.returnKeyType = UIReturnKeyDone;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 110/2, 50/2);
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame)*0.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"充 值" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];

}

- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [self.chargeNumText resignFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange tempRange = [textField selectedRange];
    
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    
    if(*ch == 0)
        return YES;
    if( *ch != 46 && ( *ch<48 || *ch>57) )
        return NO;
    
    if([textField.text rangeOfString:@"."].length==1)
    {
        if(*ch == 0)
            return YES;
        NSUInteger length=[textField.text rangeOfString:@"."].location;
        

        //小数点后面两位小数 且不能再是小数点

        if([[textField.text substringFromIndex:length] length]>2 || *ch ==46){   //3表示后面小数位的个数。。
            if (tempRange.location <= length) {
                if ([[textField.text substringToIndex:length] length] < 5 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                    return YES;
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            if (tempRange.location > length) {
                return YES;
            }else{
                if ([[textField.text substringToIndex:length] length] < 5 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                    return YES;
                }else{
                    return NO;
                }
            }
            
        }
    }

    if(range.location>4){
        if ([string isEqualToString:@"."]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(id)sender
{
//    UITextField * field = (UITextField *)sender;
//    const char * ch = [[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)] cStringUsingEncoding:NSUTF8StringEncoding];
//
//    if ([[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)]isEqualToString:@" "] || ((*ch < 48) && *ch != 46) || ((*ch > 57) && *ch != 46)) {
//        if (field.text.length > 0) {
//            field.text = [field.text substringToIndex:field.text.length - 1];
//        }
//    }
//    if (field.text.length > 5 && [field.text rangeOfString:@"."].location==NSNotFound) {
//        field.text = [field.text substringToIndex:field.text.length - 1];
//    }
}

- (void)sendBtn:(UIButton *)send
{
    if ([_chargeNumText.text isEqualToString:@""] || _chargeNumText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写充值金额"];
        [_chargeNumText becomeFirstResponder];
        return;
    }
    [HUD removeFromSuperview];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    NSDictionary * tempdic = [self parametersForDic:@"getRechargeOrder" parameters:@{ACCOUNT_PASSWORD,@"value":self.chargeNumText.text}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
//            RechargeListViewController * rechargeListVC = [[RechargeListViewController alloc]init];
//            [self.navigationController pushViewController:rechargeListVC animated:YES];
            [self urlRequestPost];
        }else{
//            [AutoDismissAlert autoDismissAlert:@"充值失败,请确认充值金额填写是否正确"];
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD removeFromSuperview];
    }];
}

//- (void)goPayBtn:(ZZGoPayBtn *)goPay
//{
//    RechargeListModel * rechargeModel = dataArray[goPay.indexpath.row];
//    [AlipayWrapper alipaySyncRecharge:rechargeModel.orderNum orderID:rechargeModel.orderId amount:[rechargeModel.price floatValue] success:^(NSDictionary *resultDic) {
//        [self urlRequestPost];
//        [AutoDismissAlert autoDismissAlert:@"充值成功"];
//    } failure:^(NSDictionary *resultDic) {
//        [AutoDismissAlert autoDismissAlert:@"充值失败"];
//    } ];
//}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetRechargeRecords" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":@"1"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSDictionary * tempdic = [temparrs firstObject];
            RechargeListModel * rechargeModel = [[RechargeListModel alloc]init];
            [rechargeModel setValuesForKeysWithDictionary:tempdic];
            [AlipayWrapper alipaySyncRecharge:rechargeModel.orderNum orderID:rechargeModel.orderId amount:[rechargeModel.price floatValue] success:^(NSDictionary *resultDic) {
                [AutoDismissAlert autoDismissAlert:@"充值成功"];
                _chargeNumText.text = @"";
                [self.navigationController popViewControllerAnimated:YES];
                if (self.backBlock) {
                    self.backBlock();
                }
            } failure:^(NSDictionary *resultDic) {
                [AutoDismissAlert autoDismissAlert:@"充值失败"];
            } ];
        }else if([result isEqualToString:@"4"]){

        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
    } andFailureBlock:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.leftImg.image = [UIImage imageNamed:@"recharge_edit_pre"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.leftImg.image = [UIImage imageNamed:@"recharge_edit_nor"];
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
