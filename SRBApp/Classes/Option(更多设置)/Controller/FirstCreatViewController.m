//
//  FirstCreatViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FirstCreatViewController.h"
#import "SecondCreatViewController.h"

@interface FirstCreatViewController ()<UITextViewDelegate>
{
    float a;
    UIView * theview;
}
@property (nonatomic , strong)UITextView * textField;
@end

@implementation FirstCreatViewController
- (void)viewDidAppear:(BOOL)animated
{
    [_textField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_textField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建支付密码";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH, 15)];
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label.text = @"请输入6位数字密码";
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
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_textField];
    
    [_textField becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    int i = 0;
    i = (int)textView.text.length;
    for(UIImageView *view in [theview subviews])
    {
        [view removeFromSuperview];
    }
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
        SecondCreatViewController * vc = [[SecondCreatViewController alloc]init];
        vc.string = textView.text;
        vc.point = _point;
        vc.sign = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    if (_textField.text.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃创建?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
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
