//
//  RegForEmailViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/18.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "RegForEmailViewController.h"
#import "ShoppingViewController.h"
#import "GeneralView.h"
#import "APService.h"
#import "RCIM.h"
#import "AppDelegate.h"
#import "TabButton.h"
#import "HomeTopicListController.h"

@interface RegForEmailViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)GeneralView * passView;     //密码
@end

@implementation RegForEmailViewController
{
    NSString * tempPassword;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户注册";
    
    //初始化控件
    [self customInit];
    NSLog(@"result == %d token == %@ type == %@",self.resultTP,self.token,self.type);
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeText:(UISwitch *)sender
{
    if (!sender.isOn) {
        self.passView.shuRuText.secureTextEntry = YES;
    }else{
        self.passView.shuRuText.secureTextEntry = NO;
    }
}

#pragma mark - 控件初始化
- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    //    //提示文本
    //    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 40, SCREEN_WIDTH - 25, 14)];
    //    textLabel.text = @"本次注册需要短信验证码，已发送验证码至";
    //    textLabel.font = [UIFont systemFontOfSize:14];
    //    [self.view addSubview:textLabel];
    //    //手机号
    //    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, textLabel.frame.size.height + textLabel.frame.origin.y + 30, 260, 14)];
    //    phoneLabel.text = [NSString stringWithFormat:@"+86 %@",self.phoneNum];
    //    phoneLabel.font = [UIFont systemFontOfSize:14];
    //    [self.view addSubview:phoneLabel];
    //    //输入短信验证码
    //    GeneralView * messageView = [[GeneralView alloc]initWithFrame:CGRectMake(0, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 13, SCREEN_WIDTH, 50)];
    //    self.messageVie = messageView;
    //    CGRect frame = messageView.shuRuText.frame;
    //    if (SCREEN_WIDTH > 320) {
    //        frame.size.width = 150;
    //    }else{
    //        frame.size.width = 120;
    //    }
    //    messageView.shuRuText.frame = frame;
    //    messageView.leftImg.image = [UIImage imageNamed:@"regiest_code_nor"];
    //    messageView.shuRuText.delegate = self;
    //    messageView.shuRuText.placeholder = @"请输入收到的验证码";
    //    [self.view addSubview:messageView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 4)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:lineView];
    
    
    UILabel * phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,32,SCREEN_WIDTH/2,14)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.text = @"填写邮箱";
    phoneLabel.font = SIZE_FOR_12;
    phoneLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:phoneLabel];
    
    UILabel * getLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,32,SCREEN_WIDTH/2,14)];
    getLabel.textAlignment = NSTextAlignmentCenter;
    getLabel.text = @"创建密码";
    getLabel.font = SIZE_FOR_12;
    getLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [self.view addSubview:getLabel];
    
    //密码
    tempPassword = @"";
    GeneralView * passView = [[GeneralView alloc]initWithFrame:CGRectMake(0, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 13, SCREEN_WIDTH, 50)];
    self.passView = passView;
    CGRect frames = passView.shuRuText.frame;
    frames.size.width -= 50;
    passView.shuRuText.frame = frames;
    passView.shuRuText.delegate = self;
    passView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
    self.passView.shuRuText.secureTextEntry = YES;
    self.passView.shuRuText.returnKeyType = UIReturnKeyDone;
    self.passView.shuRuText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passView.shuRuText.placeholder = @"创建6-20位密码";
    [self.view addSubview:passView];
    
    TabButton * seeImg = [TabButton buttonWithType:UIButtonTypeCustom];
    seeImg.frame = CGRectMake(passView.frame.size.width - 22 - 15, 16, 22, 17);
    [seeImg setBackgroundImage:[UIImage imageNamed:@"pw_invisible"] forState:UIControlStateNormal];
    [seeImg setBackgroundImage:[UIImage imageNamed:@"pw_visible"] forState:UIControlStateSelected];
    [seeImg addTarget:self action:@selector(seeImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [passView addSubview:seeImg];
    
    
    //提交按钮
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(25, passView.frame.size.height + passView.frame.origin.y + 60, SCREEN_WIDTH - 50, 40);
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 2;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = SIZE_FOR_IPHONE;
    submitBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    UITapGestureRecognizer * viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:viewTap];
    
}

- (void)seeImgClick:(UIButton *)sender
{
    [self.passView.shuRuText resignFirstResponder];
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        self.passView.shuRuText.secureTextEntry = NO;
    }else{
        self.passView.shuRuText.secureTextEntry = YES;
    }
}

- (void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - 提交
- (void)submitBtn:(UIButton *)sender
{

    if (self.passView.shuRuText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写密码"];
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    AppDelegate * appDele = APPDELEGATE;
    //拼接post请求参数
    NSDictionary * dic = [self parametersForDic:@"accountRegister" parameters:@{@"account":self.email,@"username":self.email,@"password":self.passView.shuRuText.text,@"registerType":@"0",@"nickname":self.nickName}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [HUD removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"登录中,请稍后";
            hud.dimBackground = YES;
            [hud show:YES];
            //拼接post请求所需参数
            NSDictionary * loginParam = @{@"method":@"accountLogin",@"parameters":@{@"account":self.email,@"password":self.passView.shuRuText.text,@"deviceID":@"123456",@"deviceName":PHONE_NAME}};
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                [HUD removeFromSuperview];
                NSString * result = [dic objectForKey:@"result"];
                if ([result isEqualToString:@"0"]) {
                    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
                    if (dataDic == nil) {
                        dataDic = [NSMutableDictionary dictionary];
                    }
                    [dataDic setObject:@"1" forKey:@"isLogin"];
                    
                    //将登录状态写入配置文件
                    [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
                    [[NSUserDefaults standardUserDefaults]setObject:self.email forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults]setObject:self.passView.shuRuText.text forKey:@"pwd"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zhifubao"];
                    
                    //设置别名
                    [APService setAlias:self.email callbackSelector:@selector(tagsAliasCallback: tags: alias:) object:self];
                    
                    NSDictionary * tempDic = [dic objectForKey:@"data"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"nickname"] forKey:@"nickname"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"rongCloud"] forKey:@"rongCloud"];
                    [[NSUserDefaults standardUserDefaults]setObject:[tempDic objectForKey:@"avatar"] forKey:@"avatar"];
                    
                    //获取本人token
                    NSString *rongCloudToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
                    NSLog(@"rongCloudTokenOfLogin == %@",rongCloudToken);
                    // 连接融云服务器。
                    [RCIM connectWithToken:rongCloudToken completion:^(NSString *userId) {
                        // 此处处理连接成功。
                        
                    } error:^(RCConnectErrorCode status) {
                        // 此处处理连接错误。
                        
                    }];
                    
                    appDele.mainTab.tabBar.hidden = YES;
                    appDele.customTab.hidden = NO;
                    
                    [appDele.mainTab setSelectedIndex:0];
                    appDele.tabBarBtn1.selected = YES;
                    appDele.tabBarBtn5.selected = NO;
                    ZZNavigationController * nac1 = appDele.mainTab.viewControllers[0];
                    HomeTopicListController * discoverVC = nac1.viewControllers[0];
                    discoverVC.token = self.token;
                    discoverVC.resultTP = self.resultTP;
                    discoverVC.type = self.type;
                    discoverVC.uid = self.uid;
                    NSLog(@"self.resultTP == %d",self.resultTP);
                    appDele.window.rootViewController = appDele.mainTab;
                    [appDele getFriendArr];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadVC" object:nil];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    });
                }else{
                    if (![result isEqualToString:@"4"]) {
                        [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                    }
                }
                [hud removeFromSuperview];
            }];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.passView.shuRuText]){
        self.passView.leftImg.image = [UIImage imageNamed:@"login_pass_pre"];
        textField.text = @"";
        [textField insertText:tempPassword];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passView.shuRuText) {
        tempPassword = textField.text;
    }
    if (textField.text.length == 0) {
        if ([textField isEqual:self.passView.shuRuText]){
            self.passView.leftImg.image = [UIImage imageNamed:@"login_pass_nor"];
            
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    if (textField == self.passView.shuRuText) {
        if (textField.text.length > 19) {
            return NO;
        }
        if (range.location > 0 && range.length == 1 && string.length == 0)
        {
            // Stores cursor position
            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
            NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
            
            // Save the current text, in case iOS deletes the whole text
            NSString *text = textField.text;
            
            // Trigger deletion
            [textField deleteBackward];
            
            
            // iOS deleted the entire string
            if (textField.text.length != text.length - 1)
            {
                textField.text = [text stringByReplacingCharactersInRange:range withString:string];
                
                // Update cursor position
                UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
                UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
                [textField setSelectedTextRange:newSelectedRange];
            }
            return NO;
        }
        return YES;
    }
    return YES;
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
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
