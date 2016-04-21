//
//  ZZCancelOrderViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZCancelOrderViewController.h"
#import "ZZResonViewController.h"
#import "SGActionView.h"

@interface ZZCancelOrderViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@end

@implementation ZZCancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取消订单";
    // Do any additional setup after loading the view.
    //控件初始化
    [self customInit];
}


- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 控件初始化
- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //取消按钮
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 15, 55, 25);
    cancelBtn.backgroundColor = WHITE;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = CGRectGetHeight(cancelBtn.frame)*0.5;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"提 交" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    //订单号
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 91)];
    bgView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self.view addSubview:bgView];
    
    UILabel * orderIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 65, 14)];
    orderIDLabel.font = SIZE_FOR_14;
    orderIDLabel.text = @"订单号:";
    [bgView addSubview:orderIDLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, orderIDLabel.frame.size.height + orderIDLabel.frame.origin.y + 13, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [bgView addSubview:lineView];
    
    //价格
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, lineView.frame.size.height + lineView.frame.origin.y + 18, 135, 14)];
    priceLabel.font = SIZE_FOR_14;
    priceLabel.text = @"实付款（含运费）：";
    [bgView addSubview:priceLabel];
    
    UILabel * orderIDContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180 - 15, 13, 180, 14)];
    orderIDContentLabel.font = SIZE_FOR_14;
    orderIDContentLabel.text = [self.dataDic objectForKey:@"orderNum"];
    self.orderIDLabel = orderIDContentLabel;
    orderIDContentLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:orderIDContentLabel];
    
    UILabel * priceContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180 - 15, lineView.frame.size.height + lineView.frame.origin.y + 17, 180, 16)];
    priceContentLabel.font = SIZE_FOR_IPHONE;
    priceContentLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.priceLabel = priceContentLabel;
    priceContentLabel.textAlignment = NSTextAlignmentRight;
    priceContentLabel.text = [NSString stringWithFormat:@"¥ %@",[self.dataDic objectForKey:@"orderAmount"]];
    [bgView addSubview:priceContentLabel];
    
//    //分割线
//    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, priceLabel.frame.size.height + priceLabel.frame.origin.y + 15, SCREEN_WIDTH, 1)];
//    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
//    [self.view addSubview:lineView];
    
    //取消理由
    UIView * cancelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height + bgView.frame.origin.y + 20, SCREEN_WIDTH, 50)];
    cancelBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self.view addSubview:cancelBGView];
    
    UILabel * cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 18, 70, 14)];
    cancelLabel.font = SIZE_FOR_14;
    cancelLabel.text = @"取消理由:";
    self.cancelLabel = cancelLabel;
    [cancelBGView addSubview:cancelLabel];
    //选择理由
    UIView * resonView = [[UIView alloc]initWithFrame:CGRectMake(85, cancelLabel.frame.origin.y, SCREEN_WIDTH - 85, 14)];
    [cancelBGView addSubview:resonView];
    
    //理由Label
    UILabel * resonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, resonView.frame.size.width - 15 - 15 - 5, 14)];
    self.resonLabel = resonLabel;
    resonLabel.font = SIZE_FOR_14;
    resonLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    resonLabel.text = @"请选择";
    resonLabel.textAlignment = NSTextAlignmentRight;
    [resonView addSubview:resonLabel];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(resonLabel.frame.size.width + resonLabel.frame.origin.x + 5, 5, 9, 4)];
    self.imgView = imgView;
    imgView.image = [UIImage imageNamed:@"bg_spinner"];
    [resonView addSubview:imgView];
    
    //选择理由点击事件
    UITapGestureRecognizer * resonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resonTap:)];
    [resonView addGestureRecognizer:resonTap];
    
    //其他理由
    UIView * textBGView = [[UIView alloc]initWithFrame:CGRectMake(0, cancelBGView.frame.size.height + cancelBGView.frame.origin.y + 5, SCREEN_WIDTH, 80)];
    textBGView.hidden = YES;
    self.textBGView = textBGView;
    textBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self.view addSubview:textBGView];
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 80)];
    textView.font = SIZE_FOR_14;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    self.textView = textView;
    [textBGView addSubview:textView];
    
    UILabel * otherResonLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 120, 14)];
    otherResonLabel.text = @"请填写理由...";
    otherResonLabel.font = [UIFont systemFontOfSize:14];
    otherResonLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.otherResonLabel = otherResonLabel;
    [textView addSubview:otherResonLabel];
    
    UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:viewTap];
}

- (void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveView:80];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL bChange =YES;
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        bChange = NO;
    }
    return bChange;
}

- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;//view的x轴上移
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        self.otherResonLabel.hidden = YES;
    }else{
        self.otherResonLabel.hidden = NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveView:-80];

}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.view endEditing:YES];
        
        NSString * resonText = self.textView.text;
        if (resonText == nil || [resonText isEqualToString:@""] || resonText.length == 0) {
            resonText = self.resonLabel.text;
        }
        if ([resonText isEqualToString:@"请选择"]) {
            [AutoDismissAlert autoDismissAlert:@"请选择取消理由"];
            return;
        }
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"提交中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        NSDictionary * dic = [self parametersForDic:@"accountSetOrderCancel" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderID,@"note":resonText}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [self.navigationController popViewControllerAnimated:YES];
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
}

#pragma mark - 提交按钮
- (void)cancelBtn:(UIButton *)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定取消该订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    
    [SGActionView showSheetWithTitle:@"退款理由" itemTitles:CANCEL_ORDER_RESON selectedIndex:100 selectedHandle:^(NSInteger index) {
        if (index == 3) {
            self.textBGView.hidden = NO;
            self.otherResonLabel.hidden = NO;
            self.resonLabel.text = @"其他";
        }else{
            self.textBGView.hidden = YES;
            self.otherResonLabel.hidden = YES;
            self.resonLabel.text = CANCEL_ORDER_RESON[index];
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
