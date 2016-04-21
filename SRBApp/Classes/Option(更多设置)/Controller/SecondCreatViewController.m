//
//  SecondCreatViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SecondCreatViewController.h"
#import "QuestionOptionViewController.h"
#import "IdSafeViewController.h"
#import "GetMoneyPassWordViewController.h"


@interface SecondCreatViewController ()<UITextViewDelegate, UIAlertViewDelegate>
{
    float a;
    UIView * theview;
    UILabel * wrongLabel;
}
@property (nonatomic , strong)UITextView * textField;
@end

@implementation SecondCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.sign isEqualToString:@"1"]) {
        self.title = @"创建支付密码";
    }else
    {
        self.title = @"重置支付密码";
    }
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH, 15)];
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label.text = @"请再次输入6位数字密码";
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
    a = (SCREEN_WIDTH - 50) / 6;
    theview = [[UIView alloc]initWithFrame:CGRectMake(25, label.frame.size.height + label.frame.origin.y + 20, SCREEN_WIDTH - 50, a)];
    theview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:theview];
    
    for (int i = 0; i < 5; i++) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * a, 0, 1, a)];
        view1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [theview addSubview:view1];
    }
    
    _textField = [[UITextView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 100, 20)];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textField];
    
    [_textField becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger i = 0;
    i = textView.text.length;
    for(UIImageView *view in [theview subviews])
    {
        [view removeFromSuperview];
    }
    [wrongLabel removeFromSuperview];
    for (int i = 0; i < 5; i++) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * a, 0, 1, a)];
        view1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [theview addSubview:view1];
    }
    for (int j = 0; j < i; j++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
        view.center = CGPointMake( a / 2 + j * a, a / 2);
        [theview addSubview:view];
    }
    if (textView.text.length == 6) {
    if ([textView.text isEqualToString:_string]) {
        if ([self.sign isEqualToString:@"1"]) {
            QuestionOptionViewController * vc = [[QuestionOptionViewController alloc]init];
            vc.paypassword = _string;
            vc.point = _point;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self createpassword];
        }
    }else{
        wrongLabel = [[UILabel alloc]initWithFrame:CGRectMake(theview.frame.origin.x, theview.frame.origin.y + theview.frame.size.height + 6, SCREEN_WIDTH, 11)];
        wrongLabel.text = @"您前后两次输入密码不一致,请重新输入";
        wrongLabel.textColor = [GetColor16 hexStringToColor:@"e4005d"];
        wrongLabel.font = [UIFont systemFontOfSize:11];
        [self.view addSubview:wrongLabel];
    }
    }
}

- (void)createpassword
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountModifyPaypass" parameters:@{ACCOUNT_PASSWORD,@"question": self.question,
                                                                                     @"answer": self.answer,
                                                                                     @"newpaypass": self.string
                                                                                  }];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"支付密码重置成功,请牢记!"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //[alert show];
            [AutoDismissAlert autoDismissAlert:@"支付密码重置成功，请牢记"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[GetMoneyPassWordViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    break;
                }
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    const char * ch=[text cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        return YES;
    if (textView.text.length > 5) {
        return NO;
    }
    return YES;
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
