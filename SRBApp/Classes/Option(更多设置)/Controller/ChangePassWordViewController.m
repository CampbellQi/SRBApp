//
//  ChangePassWordViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ChangePassWordViewController.h"

@interface ChangePassWordViewController ()
{
    UIView * oldPassWordView;
    UIView * newPassWordView;
    UIView * rpnewPassWordView;
    
    UITextField * oldTextField;
    UITextField * newTextField;
    UITextField * rpnewTextField;
    
    UIImageView * oldImageView;
    UIImageView * newImageView;
    UIImageView * rpnewImageView;
    
    UIButton * button;
}

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"修改登录密码";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    oldPassWordView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    oldPassWordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oldPassWordView];
    
    oldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
    [oldImageView setImage:[UIImage imageNamed:@"edit_password_nor"]];
    [oldPassWordView addSubview:oldImageView];
    
    oldTextField = [[UITextField alloc]initWithFrame:CGRectMake(oldImageView.frame.origin.x + oldImageView.frame.size.width + 5, oldImageView.frame.origin.y, SCREEN_WIDTH - 55, 30)];
    oldTextField.placeholder = @"当前密码";
    oldTextField.delegate = self;
    oldTextField.tag = 100;
    [oldTextField setSecureTextEntry:YES];
    oldTextField.returnKeyType = UIReturnKeyDone;
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
    oldTextField.inputAccessoryView = finishiView1;
    [oldPassWordView addSubview:oldTextField];
    
    newPassWordView = [[UIView alloc]initWithFrame:CGRectMake(0, oldPassWordView.frame.origin.y + oldPassWordView.frame.size.height + 20, SCREEN_WIDTH, 50)];
    newPassWordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:newPassWordView];
    
    newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
    [newImageView setImage:[UIImage imageNamed:@"login_pass_nor.png"]];
    [newPassWordView addSubview:newImageView];
    
    newTextField = [[UITextField alloc]initWithFrame:CGRectMake(newImageView.frame.origin.x + 5 + newImageView.frame.size.width, newImageView.frame.origin.y, SCREEN_WIDTH - 55, 30)];
    newTextField.placeholder = @"新密码";
    newTextField.delegate = self;
    newTextField.tag = 101;
    [newTextField setSecureTextEntry:YES];
    newTextField.returnKeyType = UIReturnKeyDone;
    FinishView * finishiView2 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView2.buttonFinish.tag = 2;
    finishiView2.buttonBack.tag = 2;
    finishiView2.buttonNext.tag = 2;
    [finishiView2.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonBack setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
    [finishiView2.buttonNext setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
    newTextField.inputAccessoryView = finishiView2;
    [newPassWordView addSubview:newTextField];
    
    rpnewPassWordView = [[UIView alloc]initWithFrame:CGRectMake(0, newPassWordView.frame.origin.y + newPassWordView.frame.size.height, SCREEN_WIDTH, 50)];
    rpnewPassWordView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rpnewPassWordView];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [rpnewPassWordView addSubview:breakView];
    
    rpnewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
    [rpnewImageView setImage:[UIImage imageNamed:@"login_pass_nor.png"]];
    [rpnewPassWordView addSubview:rpnewImageView];
    
    rpnewTextField = [[UITextField alloc]initWithFrame:CGRectMake(rpnewImageView.frame.origin.x + rpnewImageView.frame.size.width + 5, rpnewImageView.frame.origin.y, SCREEN_WIDTH - 55, 30)];
    rpnewTextField.placeholder = @"确认新密码";
    rpnewTextField.delegate = self;
    rpnewTextField.tag = 102;
    [rpnewTextField setSecureTextEntry:YES];
    rpnewTextField.returnKeyType = UIReturnKeyDone;
    FinishView * finishiView3 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView3.buttonFinish.tag = 3;
    finishiView3.buttonBack.tag = 3;
    finishiView3.buttonNext.tag = 3;
    [finishiView3.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView3.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView3.buttonBack setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
    [finishiView3.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    rpnewTextField.inputAccessoryView = finishiView3;
    [rpnewPassWordView addSubview:rpnewTextField];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50,40 )];
    button.center = CGPointMake(SCREEN_WIDTH / 2, rpnewPassWordView.frame.origin.y + rpnewPassWordView.frame.size.height + 40);
    [button setTitle:@"确认修改" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    if (textField.text.length > 20) {
        return NO;
    }
    return YES;
}

- (void)buttonFinish:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 1) {
        [oldTextField resignFirstResponder];
    }
    if (buttona.tag == 2) {
        [newTextField resignFirstResponder];
    }
    if (buttona.tag == 3) {
        [rpnewTextField resignFirstResponder];
    }
}

- (void)buttonBack:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 2) {
        [oldTextField becomeFirstResponder];
    }
    if (buttona.tag == 3) {
        [newTextField becomeFirstResponder];
    }
    
}

- (void)buttonNext:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 1) {
        [newTextField becomeFirstResponder];
    }
    if (buttona.tag == 2) {
        [rpnewTextField becomeFirstResponder];
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [oldTextField resignFirstResponder];
    [newTextField resignFirstResponder];
    [rpnewTextField resignFirstResponder];
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

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)post
{
    NSString * oldStr = [oldTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * newPass = [newTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * newPassAgain = [rpnewTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([oldStr isEqualToString:@""] || oldStr.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写当前密码"];
        [oldTextField becomeFirstResponder];
        return;
    }
    if (![oldStr isEqualToString:PASSWORD_SELF]) {
        [AutoDismissAlert autoDismissAlert:@"当前密码填写错误"];
        [oldTextField becomeFirstResponder];
        return;
    }
    if ([newPass isEqualToString:@""] || newPass.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写新密码"];
        [newTextField becomeFirstResponder];
        return;
    }
    if (newPass.length < 6) {
        [AutoDismissAlert autoDismissAlert:@"新密码长度应在6-20位之间"];
        [newTextField becomeFirstResponder];
        return;
    }
    if (![newPass isEqualToString: newPassAgain]) {
        [AutoDismissAlert autoDismissAlert:@"请确保两次填写的密码相同"];
        [rpnewTextField becomeFirstResponder];
        return;
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountModifyPassword" parameters:@{ACCOUNT_PASSWORD, @"newpwd":newPassAgain}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //        [self post];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [[NSUserDefaults standardUserDefaults]setObject:rpnewTextField.text forKey:@"pwd"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (textField.tag == 100) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_password_nor"]];
            oldImageView.image = image.image;
        }if (textField.tag == 101) {
            newImageView.image = [UIImage imageNamed:@"login_pass_nor"];
        }if (textField.tag == 102) {
            rpnewImageView.image = [UIImage imageNamed:@"login_pass_nor"];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:oldTextField]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_password_pre"]];
        oldImageView.image = image.image;
    }else if ([textField isEqual:newTextField]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pass_pre"]];
        newImageView.image = image.image;
    }else{
        rpnewImageView.image = [UIImage imageNamed:@"login_pass_pre"];
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard1" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,64,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == rpnewTextField) {
        NSTimeInterval animationDuration=0.10f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移n个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-50,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
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
