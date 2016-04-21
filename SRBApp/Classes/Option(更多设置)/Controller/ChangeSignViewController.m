//
//  ChangeSignViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ChangeSignViewController.h"

@interface ChangeSignViewController ()<UITextViewDelegate>
{
    UILabel * textLabel;
    UILabel * numLabel;
    BOOL _canedit;
}
@property (nonatomic, strong)UIBarButtonItem * item;
@end

@implementation ChangeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改签名";
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    _textField = [[UITextView alloc]initWithFrame:CGRectMake(15, 10 , SCREEN_WIDTH - 30, 80)];
    //_textField.keyboardType = UIKeyboardAppearanceDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    if (_sign.length == 0) {
        _textField.text = @"这个主人很懒...";
    }else{
    _textField.text = self.sign;
    }
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.textColor = [GetColor16 hexStringToColor:@"#434343"];
    _textField.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
    _textField.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    _textField.returnKeyType = UIReturnKeyDone;//返回键的类型
    _textField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textField.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    _textField.inputAccessoryView = finishiView1;
    
    [view addSubview: _textField];//加入到整个页面中

    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH - 30, 16)];
    textLabel.text = @"请填写签名";
    textLabel.hidden = YES;
    textLabel.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    [_textField addSubview:textLabel];
    
    [self.view addSubview:view];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"修 改" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
        [_textField resignFirstResponder];
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_textField resignFirstResponder];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //BOOL bChange =YES;
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    
    const char * ch=[text cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (toBeString.length <= 48) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
    //return bChange;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        textLabel.hidden = YES;
    }else{
        textLabel.hidden = NO;
    }
    
    NSString * toBeString = textView.text;
    
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textView markedTextRange];
        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 20) {
            _canedit = NO;
        }
        if (!position) {
            if (toBeString.length > 48) {
                textView.text = [toBeString substringToIndex:48];
                _canedit = YES;
            }
        }
    }
    else{
        if (toBeString.length > 48) {
            textView.text = [toBeString substringToIndex:48];
            _canedit = NO;
        }
    }
}

- (void)regController:(id)sender
{
    if (_textField.text.length > 48) {
        [AutoDismissAlert autoDismissAlert:@"签名过长,请控制在48字以内"];
        return;
    }
    if ([_signNum isEqualToString:@"0"]) {
        return;
    }else{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":_sex, @"nickname":_nickName, @"sign": self.textField.text, @"birthday": _birthday}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }andFailureBlock:^{
        
    }];
    }
}

- (void)sendMessage:(MyBlock)jgx
{
    self.block = jgx;
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
