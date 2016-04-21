//
//  AccountCommentViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/5.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AccountCommentViewController.h"

@interface AccountCommentViewController ()<UITextViewDelegate>
{
    UILabel * labeltext;
    UILabel * numLabel;
    BOOL _canedit;
}
@end

@implementation AccountCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"咨询";
    
    _textField = [[UITextView alloc]initWithFrame:CGRectMake(15, 10 , SCREEN_WIDTH - 30,150)];
    _textField.keyboardType = UIKeyboardAppearanceDefault;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色
    _textField.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
    //        self.textView.delegate = self;//设置它的委托方法
    _textField.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    _textField.returnKeyType = UIReturnKeyDone;//返回键的类型
    _textField.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textField.scrollEnabled = YES;//是否可以拖动
    _textField.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: _textField];//加入到整个页面中
    
//    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, _textField.frame.origin.y + _textField.frame.size.height - 60, 75, 14)];
//    numLabel.text = @"0/140";
//    numLabel.textAlignment = NSTextAlignmentRight;
//    numLabel.textColor = [GetColor16 hexStringToColor:@"#c6c6c6"];
//    [self.view addSubview:numLabel];
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(_textField.frame.origin.x + 4, _textField.frame.origin.y + 10, SCREEN_WIDTH, 16)];
    labeltext.text = @"我要说点什么";
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [self.view addSubview:labeltext];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"发 送" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.layer.masksToBounds = YES;
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, _textField.frame.size.height + _textField.frame.origin.y - 50, 80, 15)];
    numLabel.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.text = @"140";
    [self.view addSubview:numLabel];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
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
            if (toBeString.length > 140) {
                textView.text = [toBeString substringToIndex:140];
                _canedit = YES;
            }
        }
    }
    else{
        if (toBeString.length > 140) {
            textView.text = [toBeString substringToIndex:140];
            _canedit = NO;
        }
    }
    if (textView.text.length > 140) {
        numLabel.text = @"0";
    }else
    {
        numLabel.text = [NSString stringWithFormat:@"%u",140 - textView.text.length];
    }
}

//- (void)timerFired:(id)sender
//{
//    int a = _textField.text.length;
//    numLabel.text = [NSString stringWithFormat:@"%d/140",a];
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSString *textString = textView.text ;
//    NSUInteger length = [textString length];
//    
    BOOL bChange =YES;
    
//    if (length >= 140)
//    {
//        bChange = NO;
//    }
//    
//    if (range.length == 1) {
//        bChange = YES;
//    }
    
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        bChange = NO;
    }
    return bChange;
}
//
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length != 0) {
//        labeltext.hidden = YES;
//    }else{
//        labeltext.hidden = NO;
//    }
//    NSInteger number = [textView.text length];
//    if (number > 140) {
//        textView.text = [textView.text substringToIndex:140];
//    }
//}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_textField resignFirstResponder];
}
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regController:(id)sender
{    
    NSString * tempStr = _textField.text;
    tempStr = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (tempStr.length == 0 || tempStr == nil || [tempStr isEqualToString:@"0"]) {
        [AutoDismissAlert autoDismissAlert:@"请填写咨询内容"];
        [_textField becomeFirstResponder];
        return;
    }
//    if (_textField.text.length > 140) {
//        [AutoDismissAlert autoDismissAlert:@"咨询内容填写过长,请控制在140字以内"];
//        return;
//    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountCommentPost" parameters:@{ACCOUNT_PASSWORD, @"content":_textField.text,@"id":_idNumber}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            self.block(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"%d", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
    }andFailureBlock:^{
        
    }];
    
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
