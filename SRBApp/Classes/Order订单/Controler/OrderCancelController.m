//
//  OrderCancelController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/28.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "OrderCancelController.h"
#import "CommonView.h"
#import "WQPickerView.h"
#import "StringHelper.h"

@interface OrderCancelController ()
{
    WQPickerView *_pickerView;
    NSArray *_backArray;
}
@end

@implementation OrderCancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_type == ORDERCANCEL_SP_TYPE) {
        self.title = @"取消求购";
    }else {
        self.title = @"取消代购";
    }
    [self listenKeyboard];
    [self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    self.alertMsgLbl.text = self.alertMsg;
    for (int i=100; i<104; i++) {
        UIView *view = [self.view viewWithTag:i];
        view.layer.cornerRadius = 6.0f;
        if (i == 100) {
            //申请服务
            [view addTapAction:@selector(showServicePicker) forTarget:self];
        }
        if (i==101) {
            //求购原因
            [view addTapAction:@selector(showReasonPickerView) forTarget:self];
        }
    }
    //左导航
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"提 交" Target:self Action:@selector(commintClicked)];
    
    
}
-(void)showServicePicker{
    _backArray = @[@"退押金", @"不退押金"];
    //NSString *s = @"退押金,不退押金";
    [self showPickerView:_backArray ResultTextFiled:self.serviceTypeTF];
}
-(void) showReasonPickerView{
    NSString *s;
    if (_type == ORDERCANCEL_SP_TYPE) {
       s = @"无法与对方取得联系,商品信息严重不符合,商品报价严重不合理,上传信息虚假,图片盗用侵权,怀疑是假货,就是不想要了，任性";
    }else {
        s = @"无法与对方取得联系,要求价格过低无法达成,没找到求购物品,临时更改行程无法完成采购,对方为恶意求购者";
    }
    
    [self showPickerView:[s componentsSeparatedByString:@","] ResultTextFiled:self.reasonTF];
}
-(void)showPickerView:(NSArray *)dataArray ResultTextFiled:(UITextField *)resultTF{
    if (_pickerView) {
        [_pickerView removeFromSuperview];
    }
    
    WQPickerView *pickerView = [[WQPickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) DataArray:dataArray];
    
    _pickerView = pickerView;
    pickerView.confirmBlock = ^(NSString *selectedItem) {
        resultTF.text = selectedItem;
    };
    
    [self.view addSubview:_pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.y = MAIN_NAV_HEIGHT - PICKERVIEW_HEIGHT;
    }];
}
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)commintClicked {
    if ([self.serviceTypeTF.text trim].length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写申请服务"];
        return;
    }
    if ([self.reasonTF.text trim].length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写取消求购原因"];
        return;
    }
    [self uploadRequest];
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
-(void)listenKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    [_pickerView removeFromSuperview];
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        self.contentSV.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.contentSV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark- 网络请求
//付款催单
-(void)uploadRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    //求购人取消
    NSString *requestUrl = @"accountBuyPostCancel";
    if (_type == ORDERCANCEL_SP_TYPE) {
        requestUrl = @"accountBuyPostCancel";
    }else if (_type == ORDERCANCEL_HSP_TYPE) {
        requestUrl = @"accountBidPostCancel";
    }
    NSString *back = @"0";
    if ([_serviceTypeTF.text isEqualToString:_backArray[0]]) {
        //退押金
        back = @"1";
    }
    NSDictionary * param = [self parametersForDic:requestUrl parameters:@{ACCOUNT_PASSWORD, @"id": self.spOrderID, @"note": self.reasonTF.text, @"back": back}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        
        if ([result isEqualToString:@"0"]) {
            if (self.completedBlock) {
                self.completedBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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

- (IBAction)serviceBtn:(id)sender {
    [self showServicePicker];
}

- (IBAction)reasonBtn:(id)sender {
    [self showReasonPickerView];
}
@end
