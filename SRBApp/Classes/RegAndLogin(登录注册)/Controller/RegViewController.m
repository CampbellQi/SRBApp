//
//  RegViewController.m
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import "RegViewController.h"
#import "GeneralView.h"
#import "ZZRegActivityViewController.h"
#import "RegForEmailViewController.h"
#import "YanZhengMaView.h"
#import "SystemInfoViewController.h"

@interface RegViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)GeneralView * phoneView;//手机号输入框
@property (nonatomic,strong)GeneralView * passView; //密码输入框
@property (nonatomic,strong)GeneralView * yanzhengView; //验证码
@property (nonatomic,strong)GeneralView * nickView;
@property (nonatomic,strong)GeneralView * yaoqingView;
@property (nonatomic,strong)UIButton * regBtn;      //注册按钮
@end

@implementation RegViewController
{
    BOOL isSeleted;
    YanZhengMaView * yanzhengmaView;
    UILabel * phoneLabel;
    UILabel * getLabel;
    UIButton * changeBtn;
    BOOL _canedit;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户注册";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSeleted = NO;
    //初始化控件
    [self customInit];
    
    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];
    NSLog(@"result == %d token == %@ type == %@",self.resultTP,self.token,self.type);
}
- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [self.phoneView.shuRuText resignFirstResponder];
    [self.passView.shuRuText resignFirstResponder];
    [self.yanzhengView.shuRuText resignFirstResponder];
    
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化控件
- (void)customInit
{
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
//    //切换按钮
//    changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    changeBtn.frame = CGRectMake(15, 0, 60, 25);
//    changeBtn.layer.cornerRadius = 2;
//    changeBtn.layer.masksToBounds = YES;
//    [changeBtn setTitle:@"切 换" forState:UIControlStateNormal];
//    [changeBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
//    [changeBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
//    [changeBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 4)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:lineView];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 20, SCREEN_WIDTH/2, 4)];
    lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    [self.view addSubview:lineView2];
    
    //提示1
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,32,SCREEN_WIDTH/2,14)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.text = @"填写手机号";
    phoneLabel.font = SIZE_FOR_12;
    phoneLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:phoneLabel];
    
    //提示2
    getLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2,32,SCREEN_WIDTH/2,14)];
    getLabel.textAlignment = NSTextAlignmentCenter;
    getLabel.text = @"输入验证码，创建密码";
    getLabel.font = SIZE_FOR_12;
    getLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [self.view addSubview:getLabel];
    
    //手机号输入框
    GeneralView * phoneView = [[GeneralView alloc]initWithFrame:CGRectMake(0, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 13, SCREEN_WIDTH, 50)];
    phoneView.shuRuText.placeholder = @"请填写手机号";
//    phoneView.shuRuText.autocorrectionType = UIKeyboardTypeNumberPad;
    phoneView.shuRuText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneView.shuRuText.delegate = self;
    phoneView.leftImg.image = [UIImage imageNamed:@"login_accon_nor"];
    phoneView.shuRuText.returnKeyType = UIReturnKeyDone;
    self.phoneView = phoneView;
    [self.view addSubview:phoneView];
    
    //昵称输入框
    GeneralView * nickView = [[GeneralView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame) + 1, SCREEN_WIDTH, 50)];
    nickView.shuRuText.autocorrectionType = UITextAutocorrectionTypeNo;
    nickView.shuRuText.delegate = self;
    nickView.shuRuText.returnKeyType = UIReturnKeyDone;
    [nickView.shuRuText addTarget:self action:@selector(checkLength:) forControlEvents:UIControlEventEditingChanged];
    self.nickView = nickView;
    nickView.leftImg.image = [UIImage imageNamed:@"login_nicknm_nor"];
    nickView.shuRuText.placeholder = @"请填写昵称";
    [self.view addSubview:nickView];
    
    //邀请码输入框
    GeneralView * yaoqingView = [[GeneralView alloc]initWithFrame:CGRectMake(0, nickView.frame.size.height + nickView.frame.origin.y + 1, SCREEN_WIDTH, 50)];
    yaoqingView.shuRuText.autocorrectionType = UITextAutocorrectionTypeNo;
    yaoqingView.shuRuText.delegate = self;
    yaoqingView.shuRuText.returnKeyType = UIReturnKeyDone;
    self.yaoqingView = yaoqingView;
    yaoqingView.leftImg.image = [UIImage imageNamed:@"yaoqing_nor"];
    yaoqingView.shuRuText.placeholder = @"(选填)请填写邀请码";
    [self.view addSubview:yaoqingView];
    
    
    //    //验证码
    //    GeneralView * yanzhengView = [[GeneralView alloc]initWithFrame:CGRectMake(0, passView.frame.size.height + passView.frame.origin.y + 1, SCREEN_WIDTH, 50)];
    //    CGRect frame = yanzhengView.shuRuText.frame;
    //    frame.size.width = 120;
    //    yanzhengView.leftImg.image = [UIImage imageNamed:@"login_regiest_code_nor"];
    //    self.yanzhengView = yanzhengView;
    //    yanzhengView.shuRuText.frame = frame;
    //    yanzhengView.shuRuText.delegate = self;
    //    yanzhengView.shuRuText.placeholder = @"填写右图中的数字";
    //    [self.view addSubview:yanzhengView];
    //
    //    //输入框添加监听事件
    //    [yanzhengView.shuRuText addTarget:self action:@selector(textFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    //    [yanzhengView.shuRuText addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    //
    //    yanzhengmaView = [[YanZhengMaView alloc]initWithFrame:CGRectMake(yanzhengView.frame.size.width - 132, 10, 70, 30)];
    //    [yanzhengView addSubview:yanzhengmaView];
    //    UITapGestureRecognizer * seeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeYanzhen:)];
    //    [yanzhengmaView addGestureRecognizer:seeTap];
    //
    //
    //    //看不清按钮
    //    UIButton * seeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    seeBtn.frame = CGRectMake(yanzhengView.frame.size.width - 52, 17, 42, 16);
    //    [seeBtn setTitle:@"看不清" forState:UIControlStateNormal];
    //    seeBtn.tintColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    //    seeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    //    seeBtn.layer.masksToBounds = YES;
    //    seeBtn.layer.cornerRadius = 2;
    //    seeBtn.titleLabel.font = SIZE_FOR_14;
    //    [seeBtn addTarget:self action:@selector(seeTap:) forControlEvents:UIControlEventTouchUpInside];
    //    [yanzhengView addSubview:seeBtn];
    
    //注册协议
    UILabel * regLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2 + 19, yaoqingView.frame.size.height + yaoqingView.frame.origin.y + 15, 130, 16)];
    regLabel.text = @"《熟人邦注册协议》";
    regLabel.textAlignment = NSTextAlignmentCenter;
    regLabel.font = SIZE_FOR_14;
    regLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    regLabel.userInteractionEnabled = YES;
    [self.view addSubview:regLabel];
    
    //
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake(regLabel.frame.origin.x - 20, regLabel.frame.origin.y - 2, 19, 19);
    regButton.selected = YES;
    isSeleted = YES;
    [regButton setImage:[UIImage imageNamed:@"not__choose"] forState:UIControlStateNormal];
    [regButton setImage:[UIImage imageNamed:@"had__choose"] forState:UIControlStateSelected];
    [regButton addTarget:self action:@selector(agreeToReg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regButton];
    
    UITapGestureRecognizer * regTextTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(regText)];
    [regLabel addGestureRecognizer:regTextTap];
    
    //注册按钮
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setTitle:@"下一步" forState:UIControlStateNormal];
    regBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.frame = CGRectMake(25, yaoqingView.frame.size.height + yaoqingView.frame.origin.y + 60, SCREEN_WIDTH - 50, 40);
    self.regBtn = regBtn;
    [regBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = 2;
    [regBtn addTarget:self action:@selector(userReg:) forControlEvents:UIControlEventTouchUpInside];
    [regBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:regBtn];
    
}

- (void)changeBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        phoneLabel.text = @"填写邮箱";
        getLabel.text = @"创建密码";
        self.phoneView.shuRuText.placeholder = @"请填写邮箱";
    }else{
        phoneLabel.text = @"填写手机号";
        getLabel.text = @"输入验证码,创建密码";
        self.phoneView.shuRuText.placeholder = @"请填写手机号";
    }
}

- (void)agreeToReg:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        isSeleted = YES;
    }else
    {
        isSeleted = NO;
    }
}



#pragma mark - 注册协议
- (void)regText
{
    SystemInfoViewController * vc = [[SystemInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 监听验证码输入框键盘
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneView.shuRuText]) {
        self.phoneView.leftImg.image = [UIImage imageNamed:@"login_accon_pre"];
    }else if ([textField isEqual:self.nickView.shuRuText]) {
        self.nickView.leftImg.image = [UIImage imageNamed:@"login_nicknm_pre"];
    }else{
        self.yaoqingView.leftImg.image = [UIImage imageNamed:@"yaoqing_pre"];
        [self moveView:-20];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if ([textField isEqual:self.phoneView.shuRuText]) {
            self.phoneView.leftImg.image = [UIImage imageNamed:@"login_accon_nor"];
        }else if ([textField isEqual:self.nickView.shuRuText]) {
            self.nickView.leftImg.image = [UIImage imageNamed:@"login_nicknm_nor"];
        }else{
            self.yaoqingView.leftImg.image = [UIImage imageNamed:@"yaoqing_nor"];
        }
    }
    if ([textField isEqual:self.yaoqingView.shuRuText]) {
        [self moveView:20];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    if ([textField isEqual:self.nickView.shuRuText]) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([ChangeSizeOfNSString convertToInts:toBeString] <= 12) {
            _canedit = YES;
        }
        if (_canedit == NO) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)checkLength:(UITextField *)text
{
    NSString * toBeString = text.text;
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    //    NSString * lang = textfield.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [text markedTextRange];
        UITextPosition * position = [text positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 6) {
            _canedit = NO;
        }
        if (!position) {
            if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
                NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
                text.text = [toBeString substringToIndex:tempIndex];
                _canedit = YES;
            }
        }
    }
    else{
        if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
            NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
            text.text = [toBeString substringToIndex:tempIndex];
            _canedit = NO;
        }
    }
}



- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;//view的x轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 用户注册
- (void)userReg:(UIButton *)sender
{
    if (isSeleted) {
        NSString * registerType;
//        if (changeBtn.selected == YES) {
//            registerType = @"0";
//        }else{
//            //判断输入是否合法
//            if (self.phoneView.shuRuText.text.length == 0) {
//                [AutoDismissAlert autoDismissAlert:@"请填写手机号"];
//                return;
//            }
//            registerType = @"1";
//        }
        
        NSString * phoneText = [self.phoneView.shuRuText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //    NSDictionary * guarantorDic = self.toSellerModel.guarantor;
        if ([phoneText isEqualToString:@""] || phoneText.length == 0 || phoneText == nil) {
            [AutoDismissAlert autoDismissAlert:@"请填写手机号"];
            return;
        }
        
        registerType = @"1";
        
        NSString * nickName = self.nickView.shuRuText.text;
        if (nickName == nil || [nickName isEqualToString:@""] || nickName.length == 0) {
            nickName = @"";
        }
        
        NSString * yaoqingToken = self.yaoqingView.shuRuText.text;
        if (yaoqingToken == nil || [yaoqingToken isEqualToString:@""] || yaoqingToken.length == 0) {
            yaoqingToken = @"";
        }
        
//        ZZRegActivityViewController * regActivityVC = [[ZZRegActivityViewController alloc]init];
//        [self.navigationController pushViewController:regActivityVC animated:YES];
        
        [HUD removeFromSuperview];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"获取中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountRegisterVerify" parameters:@{@"account":phoneText,@"username":phoneText,@"nickname":nickName,@"registerType":registerType}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                NSDictionary * tempDic = [dic objectForKey:@"data"];
                if (changeBtn.selected == YES) {
                    RegForEmailViewController * regActivityVC = [[RegForEmailViewController alloc]init];
                    regActivityVC.userName = [tempDic objectForKey:@"username"];
                    regActivityVC.email = [tempDic objectForKey:@"account"];
                    regActivityVC.nickName = nickName;
                    regActivityVC.resultTP = self.resultTP;
                    regActivityVC.type = self.type;
                    regActivityVC.token = self.token;
                    regActivityVC.uid = self.uid;
                    
                    [self.view endEditing:YES];
                    [self.navigationController pushViewController:regActivityVC animated:YES];
                }else{
                    ZZRegActivityViewController * regActivityVC = [[ZZRegActivityViewController alloc]init];
                    regActivityVC.userName = [tempDic objectForKey:@"username"];
                    regActivityVC.phoneNum = [tempDic objectForKey:@"account"];
                    regActivityVC.nickName = nickName;
                    regActivityVC.resultTP = self.resultTP;
                    regActivityVC.type = self.type;
                    regActivityVC.token = self.token;
                    regActivityVC.uid = self.uid;
                    regActivityVC.yaoqingToken = yaoqingToken;
                    [self.view endEditing:YES];
                    [self.navigationController pushViewController:regActivityVC animated:YES];
                }
            }else if ([result isEqualToString:@"20201"]){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"该手机号已经注册" message:nil delegate:self cancelButtonTitle:@"换个手机" otherButtonTitles:@"去登录", nil];
                [alert show];
            }else{
                if (![result isEqualToString:@"4"]) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }
            [HUD hide:YES];
            [HUD removeFromSuperview];
        } andFailureBlock:^{
            [HUD hide:YES];
            [HUD removeFromSuperview];
        }];
    }else{
        [AutoDismissAlert autoDismissAlert:@"请同意《熟人邦注册协议》"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//#pragma mark - 看不清
//- (void)seeTap:(UIButton *)tap
//{
//    [yanzhengmaView removeFromSuperview];
//    yanzhengmaView = [[YanZhengMaView alloc]initWithFrame:CGRectMake(self.yanzhengView.frame.size.width - 132, 10, 70, 30)];
//    [self.yanzhengView addSubview:yanzhengmaView];
//    UITapGestureRecognizer * seeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeYanzhen:)];
//    [yanzhengmaView addGestureRecognizer:seeTap];
//    
//}


//- (void)changeYanzhen:(UITapGestureRecognizer *)tap
//{
//    [yanzhengmaView removeFromSuperview];
//    yanzhengmaView = [[YanZhengMaView alloc]initWithFrame:CGRectMake(self.yanzhengView.frame.size.width - 132, 10, 70, 30)];
//    [self.yanzhengView addSubview:yanzhengmaView];
//    UITapGestureRecognizer * seeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeYanzhen:)];
//    [yanzhengmaView addGestureRecognizer:seeTap];
//    
//}

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
