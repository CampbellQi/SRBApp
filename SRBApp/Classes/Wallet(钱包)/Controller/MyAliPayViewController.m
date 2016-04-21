//
//  MyAliPayViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyAliPayViewController.h"
#import "GetColor16.h"
#import "AutoDismissAlert.h"
#import "AppDelegate.h"

@interface MyAliPayViewController ()<UITextFieldDelegate>
{
    UIView *AccountView;
    UIView *PresentView;
    UIImageView * aliPayImageV;
    UIImageView * aliPayImageV1;
}

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *accountTFAgain;
@end

@implementation MyAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
    self.title = @"我的支付宝";
    [self creatBGView1];
    [self.view addSubview:AccountView];
    
    [self creatBGView2];
    [self.view addSubview:PresentView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(25, PresentView.frame.size.height + PresentView.frame.origin.y + 30, SCREEN_WIDTH - 50, 40);
    [btn setTitle:@"确 认" forState:UIControlStateNormal];
    [btn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 2;
    [btn addTarget:self action:@selector(yes:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];
}

- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [self.accountTF resignFirstResponder];
    [self.accountTFAgain resignFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.customTab.hidden = NO;
    }
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)creatBGView1
{
    if (!AccountView) {
        AccountView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 82)];
        AccountView.backgroundColor = [UIColor whiteColor];
        
        aliPayImageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        aliPayImageV.image = [UIImage imageNamed:@"edit_alipay_nor"];
        [AccountView addSubview:aliPayImageV];
        
        self.accountTF = [[UITextField alloc] initWithFrame:CGRectMake(aliPayImageV.frame.origin.x + aliPayImageV.frame.size.width + 12, 0, SCREEN_WIDTH - aliPayImageV.frame.size.width - 32 - 20, 40)];
        self.accountTF.placeholder = @"支付宝账号";
        self.accountTF.delegate = self;
        if ([self.aliPayAccount isEqualToString:@""]) {
            self.accountTF.text = @"";
        }else {
        self.accountTF.text = self.aliPayAccount;
        }
        self.accountTF.returnKeyType = UIReturnKeyDone;
        self.accountTF.font = [UIFont systemFontOfSize:12];
        [AccountView addSubview:self.accountTF];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.accountTF.frame.size.height, SCREEN_WIDTH, 1)];
        line.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [AccountView addSubview:line];
        
        aliPayImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10+42, 20, 20)];
        aliPayImageV1.image = [UIImage imageNamed:@"edit_alipay_nor"];
        [AccountView addSubview:aliPayImageV1];
        
        self.accountTFAgain = [[UITextField alloc] initWithFrame:CGRectMake(aliPayImageV.frame.origin.x + aliPayImageV.frame.size.width + 12, 42, SCREEN_WIDTH - aliPayImageV.frame.size.width - 32 - 20, 40)];
        _accountTFAgain.returnKeyType = UIReturnKeyDone;
        self.accountTFAgain.placeholder = @"请再输入一次支付宝账号";
        if ([self.aliPayAccount isEqualToString:@""]) {
            self.accountTFAgain.text = @"";
        }else {
            self.accountTFAgain.text = self.aliPayAccount;
        }
        self.accountTFAgain.delegate = self;
        self.accountTFAgain.font = [UIFont systemFontOfSize:12];
        [AccountView addSubview:self.accountTFAgain];
        
        return AccountView;
    }
    return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (textField == _accountTF) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_nor"]];
            aliPayImageV.image = image.image;
        }if (textField == _accountTFAgain) {
            aliPayImageV1.image = [UIImage imageNamed:@"edit_alipay_nor"];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_accountTF]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_pre"]];
        aliPayImageV.image = image.image;
    }else if ([textField isEqual:_accountTFAgain]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_pre"]];
        aliPayImageV1.image = image.image;
    }
}

- (UIView *)creatBGView2
{
    if (!PresentView) {
        PresentView = [[UIView alloc] initWithFrame:CGRectMake(15, AccountView.frame.size.height+AccountView.frame.origin.y + 18, SCREEN_WIDTH-30, 60)];
        PresentView.backgroundColor = [UIColor clearColor];
        PresentView.layer.masksToBounds = YES;
        PresentView.layer.cornerRadius = 2;
        
        UIImageView *trigonImageV = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 20, 10)];
        trigonImageV.image = [UIImage imageNamed:@"notice"];
        [PresentView addSubview:trigonImageV];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 6, PresentView.frame.size.width, PresentView.frame.size.height-trigonImageV.frame.size.height + 5)];
        view.backgroundColor = [GetColor16 hexStringToColor:@"#ff7bac"];
        [PresentView addSubview:view];
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label1.text = @"温馨提示:";
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, label1.frame.size.height+5, PresentView.frame.size.width-10, 30)];
        label2.text = @"支付宝账号必须确认无误，否则无法收到余额提现。";
        label2.font = [UIFont systemFontOfSize:12];
        label2.lineBreakMode = NSLineBreakByWordWrapping;
        label2.numberOfLines = 0;
        label2.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        [view addSubview:label2];
        
        

        return PresentView;
    }
    return nil;
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (void)yes:(UIButton *)sender
{
    NSString * account = [self.accountTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![self.accountTFAgain.text isEqualToString:self.accountTF.text]) {
        [AutoDismissAlert autoDismissAlert:@"两次输入的账号不一致"];
        [self.accountTFAgain becomeFirstResponder];
        return;
    }
    NSString * str = [[NSString alloc]init];
    str = _accountTFAgain.text;
    if ([account isEqualToString:@""] || account.length == 0 || [account isEqualToString:@"(null)"])
    {
        str = @"0";
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetUserAlipay" parameters:@{ACCOUNT_PASSWORD, @"zhifubao":str}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            if ([str isEqualToString:@"0"]) {
                [AutoDismissAlert autoDismissAlert:@"解除绑定成功"];
            }else{
                [AutoDismissAlert autoDismissAlert:@"绑定成功"];
            }
            [[NSUserDefaults standardUserDefaults]setObject:_accountTFAgain.text forKey:@"zhifubao"];
            [self back];
            
        }else{
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"绑定失败,请检查支付宝账户是否正确!"];
        }
    }];
}

- (void)back
{
    isBack = YES;
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

#pragma mark - UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
