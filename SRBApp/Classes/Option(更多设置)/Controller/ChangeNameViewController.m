//
//  ChangeNameViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ChangeNameViewController.h"
#import "IdSafeViewController.h"
#import "AppDelegate.h"

@interface ChangeNameViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UIBarButtonItem * item;
@end

@implementation ChangeNameViewController
{
    int totalLength;
    BOOL _canedit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 20, 40)];
    _textField.placeholder = @"请填写昵称";
    _textField.text = self.nickName;
    _textField.delegate = self;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.returnKeyType = UIReturnKeyDone;
    [_textField addTarget:self action:@selector(checkLength:) forControlEvents:UIControlEventEditingChanged];
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    _textField.inputAccessoryView = finishiView1;
    
    [view addSubview:_textField];
    
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
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)checkLength:(UITextField *)text
{
    NSString * toBeString = text.text;
    
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([ChangeSizeOfNSString convertToInts:toBeString] <= 12) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)regController:(id)sender
{
    if ([ChangeSizeOfNSString convertToInts: _textField.text]  > 12) {
        [AutoDismissAlert autoDismissAlert:@"昵称过长,请控制字数"];
        return;
    }
    if ([_signNum isEqualToString:@"0"]) {
        return;
    }else{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":_sex, @"nickname":self.textField.text, @"sign": _sign, @"birthday": _birthday}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
            [[NSUserDefaults standardUserDefaults] setObject:self.textField.text forKey:@"nickname"];
        }else{
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }andFailureBlock:^{
        
    }];
    
    }
}


- (void)sendMessage1:(MyBlock)jgx
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
