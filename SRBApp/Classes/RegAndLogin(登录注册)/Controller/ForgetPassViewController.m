//
//  ForgetPassViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/17.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "GeneralView.h"
static int second = 60;
@interface ForgetPassViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)GeneralView * phoneView;    //电话
@property (nonatomic,strong)GeneralView * passView;     //密码
@property (nonatomic,strong)GeneralView * passAgainView;//再次输入密码
@property (nonatomic,strong)GeneralView * yanzhengView; //验证码
@property (nonatomic,strong)UIButton * getYanzhengBtn;
@end

@implementation ForgetPassViewController
{
    NSTimer * timer;
    UILabel * huoquLabel;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"重置密码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    //控件初始化
    [self customInit];
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化控件
- (void)customInit
{
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    NSString * tempName = [dataDic objectForKey:@"account"];
    
    //手机号
    GeneralView * phoneView = [[GeneralView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 50)];
    if (tempName != nil) {
        phoneView.shuRuText.text = [dataDic objectForKey:@"account"];
    }
    phoneView.leftImg.image = [UIImage imageNamed:@"login_num_nor"];
    phoneView.shuRuText.placeholder = @"请填写手机号";
    phoneView.shuRuText.delegate = self;
    phoneView.shuRuText.keyboardType = UIKeyboardTypeNumberPad;
    phoneView.shuRuText.returnKeyType = UIReturnKeyDone;
    self.phoneView = phoneView;
    [self.view addSubview:phoneView];
    
    //密码
    GeneralView * passView = [[GeneralView alloc]initWithFrame:CGRectMake(0, phoneView.frame.size.height + phoneView.frame.origin.y + 1, SCREEN_WIDTH, 50)];
    self.passView = passView;
    passView.shuRuText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passView.shuRuText.delegate = self;
    passView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
    self.passView.shuRuText.secureTextEntry = YES;
    passView.shuRuText.placeholder = @"请填写新的密码";
    passView.shuRuText.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passView];
    
    //再次输入密码
    GeneralView * passAgainView = [[GeneralView alloc]initWithFrame:CGRectMake(0, passView.frame.size.height + passView.frame.origin.y + 1, SCREEN_WIDTH, 50)];
    passAgainView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
    self.passAgainView = passAgainView;
    passAgainView.shuRuText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passAgainView.shuRuText.delegate = self;
    self.passAgainView.shuRuText.secureTextEntry = YES;
    passAgainView.shuRuText.placeholder = @"请再次填写新的密码";
    passAgainView.shuRuText.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passAgainView];
    
    //验证码
    GeneralView * yanzhengView = [[GeneralView alloc]initWithFrame:CGRectMake(0, passAgainView.frame.size.height + passAgainView.frame.origin.y + 1, SCREEN_WIDTH, 50)];
    self.yanzhengView = yanzhengView;
    yanzhengView.shuRuText.delegate = self;
    yanzhengView.leftImg.image = [UIImage imageNamed:@"regiest_code_nor"];
    yanzhengView.shuRuText.placeholder = @"验证码";
    yanzhengView.shuRuText.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:yanzhengView];
    CGRect frame = yanzhengView.shuRuText.frame;
    frame.size.width = 100;
    yanzhengView.shuRuText.frame = frame;
    
    
    //获取验证码按钮
    UIButton * getYanzhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getYanzhengBtn.frame = CGRectMake(yanzhengView.frame.size.width - 115, 10, 100, 30);
    [getYanzhengBtn setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateNormal];
    self.getYanzhengBtn = getYanzhengBtn;
    [getYanzhengBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateHighlighted];
    getYanzhengBtn.layer.masksToBounds = YES;
    getYanzhengBtn.layer.cornerRadius = 2;
    getYanzhengBtn.tag = 110;
    getYanzhengBtn.titleLabel.font = SIZE_FOR_IPHONE;
    [getYanzhengBtn addTarget:self action:@selector(getYanzheng:) forControlEvents:UIControlEventTouchUpInside];
    [yanzhengView addSubview:getYanzhengBtn];
    
    huoquLabel = [[UILabel alloc]initWithFrame:CGRectMake(yanzhengView.frame.size.width - 115,10,100,30)];
    huoquLabel.font = SIZE_FOR_IPHONE;
    huoquLabel.textAlignment = NSTextAlignmentCenter;
    huoquLabel.text = @"获取验证码";
    huoquLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [yanzhengView addSubview:huoquLabel];
    
    
    //提交按钮
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(25, yanzhengView.frame.size.height + yanzhengView.frame.origin.y + 60, SCREEN_WIDTH - 50, 40);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 2;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = SIZE_FOR_IPHONE;
    submitBtn.backgroundColor = [GetColor16 hexStringToColor:@"e5005d"];
    [self.view addSubview:submitBtn];
}
#pragma mark - 提交
- (void)submit
{
    
    if (self.phoneView.shuRuText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写手机号"];
        return;
    }
    
    NSString * passStr = [self.passView.shuRuText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * passAgaingStr = [self.passAgainView.shuRuText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * yanzhengStr =[self.yanzhengView.shuRuText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([passStr isEqualToString:@""] || passStr.length == 0 || passStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请填写新的密码"];
        return;
    }
    if ([passAgaingStr isEqualToString:@""] || passAgaingStr.length == 0 || passAgaingStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请再次填写新的密码"];
        return;
    }
    
    if (![passStr isEqualToString:passAgaingStr]) {
        [AutoDismissAlert autoDismissAlert:@"两次密码不一致"];
        return;
    }
    if (yanzhengStr == nil || [yanzhengStr length] == 0 || [yanzhengStr isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"请填写验证码"];
        return;
    }
    
    NSDictionary * dic = [self parametersForDic:@"accountConfirmCode" parameters:@{@"account":self.phoneView.shuRuText.text,@"code":self.yanzhengView.shuRuText.text}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKeyedSubscript:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dic = [self parametersForDic:@"accountFindPasswordSetPassword" parameters:@{@"account":self.phoneView.shuRuText.text,@"password":self.passAgainView.shuRuText.text,@"code":self.yanzhengView.shuRuText.text}];
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                int result = [[dic objectForKeyedSubscript:@"result"] intValue];
                if (result == 0) {
                    [[NSUserDefaults standardUserDefaults]setObject:self.passAgainView.shuRuText.text forKey:@"pwd"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];

}

#pragma mark - 获取验证码button
- (void)getYanzheng:(UIButton *)sender
{
    if (self.phoneView.shuRuText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请输入手机号!"];
        return;
    }
    //拼接post请求参数
    NSDictionary * dic = [self parametersForDic:@"accountRequestCode" parameters:@{@"account":self.phoneView.shuRuText.text,@"registerType":@"1"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKeyedSubscript:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.getYanzhengBtn setTitle:@"" forState:UIControlStateNormal];
            huoquLabel.text = @"获取验证码";
            second = 60;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            self.getYanzhengBtn.enabled = NO;
            [self.getYanzhengBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateNormal];
        }else{
            self.getYanzhengBtn.enabled = YES;
            [self.getYanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.getYanzhengBtn setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateNormal];
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
}

- (void)daojishi
{
    UIButton * btn = (UIButton *)[self.view viewWithTag:110];
    second --;
    huoquLabel.text = [NSString stringWithFormat:@"%ds 重新获取",second];
    huoquLabel.hidden = NO;
    //    [self.getYanzhengBtn setTitle:[NSString stringWithFormat:@"%ds 重新获取",second] forState:UIControlStateNormal];
    if (second == 0) {
        [timer invalidate];
        huoquLabel.hidden = YES;
        [btn setTitle:@"重新获取" forState:UIControlStateNormal];
        btn.enabled = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateNormal];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneView.shuRuText]) {
        self.phoneView.leftImg.image = [UIImage imageNamed:@"login_num_pre"];
    }else if ([textField isEqual:self.passView.shuRuText]){
        self.passView.leftImg.image = [UIImage imageNamed:@"login_pass_pre"];
    }else if ([textField isEqual:self.passAgainView.shuRuText]){
        self.passAgainView.leftImg.image = [UIImage imageNamed:@"login_pass_pre"];
    }else{
        self.yanzhengView.leftImg.image = [UIImage imageNamed:@"regiest_code_pre"];
    }
    if ([textField isEqual:self.yanzhengView.shuRuText]) {
        NSTimeInterval animationDuration=0.10f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移n个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-40,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if ([textField isEqual:self.phoneView.shuRuText]) {
            self.phoneView.leftImg.image = [UIImage imageNamed:@"login_num_nor"];
        }else if ([textField isEqual:self.passView.shuRuText]){
            self.passView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
        }else if ([textField isEqual:self.passAgainView.shuRuText]){
            self.passAgainView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
        }else{
            self.yanzhengView.leftImg.image = [UIImage imageNamed:@"regiest_code_nor"];
        }
    }
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard1" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,64,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    if (textField == self.passView.shuRuText || textField == self.passAgainView.shuRuText) {
        if (textField.text.length > 19) {
            return NO;
        }
    }
//    if (textField == self.phoneView.shuRuText || textField == self.phoneView.shuRuText) {
//        if (textField.text.length > 10) {
//            return NO;
//        }
//    }
    return YES;
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
