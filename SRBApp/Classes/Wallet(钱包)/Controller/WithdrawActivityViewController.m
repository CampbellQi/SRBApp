//
//  WithdrawActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/21.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "WithdrawActivityViewController.h"
#import "WithdrawCell.h"
#import "UITextField+MyText.h"
#import "MyAliPayViewController.h"
#import "SubOfAliPayViewController.h"
#import "CreateGetMoneyViewController.h"
#import "WritePassWordView.h"
#import "SubofclassDrawRecordsViewController.h"
#import "AppDelegate.h"

@interface WithdrawActivityViewController ()<UITextViewDelegate>
{
    UITableView * _tableView;
    UITextField * _textField1;//提现金额
    UITextField * _textField2;//联系电话
    UITextField * _textField3;//备注
    UITextView * detailTV;
    UILabel * labeltext;
    
    UIImageView * image1;
    UIImageView * image2;
    UIImageView * image3;
    
    NSString * balance;
    MBProgressHUD * HUD;
    
    WritePassWordView * passwordView;
    UITextField * textFieldPass;
    
    UIView * blackView;
    UIView *AccountView;
    UIView *PresentView;
    UIImageView * aliPayImageV;
    UIImageView * aliPayImageV1;
}

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *accountTFAgain;
@property (nonatomic, strong)NSString * aliPayAccount;
@end

@implementation WithdrawActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账户提现";
    
    [self post];
    [self urlRequestPost];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"提 现" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self.view addSubview:_tableView];
    
    
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35 + 69 , 20, 20)];
    image1.image = [UIImage imageNamed:@"recharge_edit_nor.png"];
    [self.view addSubview:image1];
    
    textFieldPass = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 30, SCREEN_WIDTH - 50, 30)];
    textFieldPass.delegate = self;
    textFieldPass.font = SIZE_FOR_14;
    textFieldPass.keyboardType = UIKeyboardTypeNumberPad;
    textFieldPass.returnKeyType = UIReturnKeyDone;
    [textFieldPass addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_tableView addSubview:textFieldPass];
    
    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH - 50, 30)];
    _textField1.placeholder = @"提现金额";
    [_textField1 addTarget:self action:@selector(textfield1Status:) forControlEvents:UIControlEventEditingChanged];
    _textField1.font = SIZE_FOR_14;
    _textField1.delegate = self;
    _textField1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _textField1.returnKeyType = UIReturnKeyDone;
    [_textField1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
//    finishiView1.buttonFinish.tag = 1;
//    finishiView1.buttonBack.tag = 1;
//    finishiView1.buttonNext.tag = 1;
//    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView1.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//    _textField1.inputAccessoryView = finishiView1;
    [_tableView addSubview:_textField1];
    
    
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(_textField1.frame.origin.x, _textField1.frame.origin.y + _textField1.frame.size.height + 20, _textField1.frame.size.width, _textField1.frame.size.height)];
    _textField2.placeholder = @"联系电话";
    _textField2.delegate = self;
    _textField2.font = SIZE_FOR_14;
    _textField2.keyboardType = UIKeyboardTypeNumberPad;
    _textField2.returnKeyType = UIReturnKeyDone;
//    FinishView * finishiView2 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
//    finishiView2.buttonFinish.tag = 2;
//    finishiView2.buttonBack.tag = 2;
//    finishiView2.buttonNext.tag = 2;
//    [finishiView2.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView2.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView2.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView2.buttonBack setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//    [finishiView2.buttonNext setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//    _textField2.inputAccessoryView = finishiView2;
    [_tableView addSubview:_textField2];
    
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, _textField2.frame.origin.y + 5 + 69, 20, 20)];
    image2.image = [UIImage imageNamed:@"edit_phone_nor.png"];
    [self.view addSubview:image2];
    
    
    
    
    
    self.accountTF = [[UITextField alloc] initWithFrame:CGRectMake(_textField2.frame.origin.x, _textField2.frame.origin.y + _textField2.frame.size.height + 40, _textField2.frame.size.width, _textField2.frame.size.height)];
    self.accountTF.placeholder = @"支付宝账号";
    self.accountTF.delegate = self;
    self.accountTF.returnKeyType = UIReturnKeyDone;
    self.accountTF.font = [UIFont systemFontOfSize:14];
    [_tableView addSubview:self.accountTF];
    
    aliPayImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, _accountTF.frame.origin.y + 5 + 69, 20, 20)];
    aliPayImageV.image = [UIImage imageNamed:@"edit_alipay_nor"];
    [self.view addSubview:aliPayImageV];
    
    
    self.accountTFAgain = [[UITextField alloc] initWithFrame:CGRectMake(_accountTF.frame.origin.x, _accountTF.frame.origin.y + _accountTF.frame.size.height + 20, _accountTF.frame.size.width, _accountTF.frame.size.height)];
    _accountTFAgain.returnKeyType = UIReturnKeyDone;
    self.accountTFAgain.placeholder = @"请再输入一次支付宝账号";
    self.accountTFAgain.delegate = self;
    self.accountTFAgain.font = [UIFont systemFontOfSize:14];
    [_tableView addSubview:self.accountTFAgain];
    
    aliPayImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, _accountTFAgain.frame.origin.y + 5 + 69, 20, 20)];
    aliPayImageV1.image = [UIImage imageNamed:@"edit_alipay_nor"];
    [self.view addSubview:aliPayImageV1];
    
    
    
    
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(_accountTFAgain.frame.origin.x, _accountTFAgain.frame.origin.y + _accountTFAgain.frame.size.height + 30, _accountTFAgain.frame.size.width, 60)];
    detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色
    detailTV.font = [UIFont systemFontOfSize:14];//设置字体名字和字体大小
    //        self.textView.delegate = self;//设置它的委托方法
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    detailTV.returnKeyType = UIReturnKeyDefault;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    detailTV.scrollEnabled = YES;
    detailTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    detailTV.returnKeyType = UIReturnKeyDone;
//    FinishView * finishiView3 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
//    finishiView3.buttonFinish.tag = 3;
//    finishiView3.buttonBack.tag = 3;
//    finishiView3.buttonNext.tag = 3;
//    [finishiView3.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView3.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView3.buttonBack setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//    [finishiView3.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    detailTV.inputAccessoryView = finishiView3;
    [_tableView addSubview: detailTV];//加入到整个页面中
    
    image3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, detailTV.frame.origin.y + 5 + 69, 20, 20)];
    image3.image = [UIImage imageNamed:@"edit_account_nor.png"];
    [self.view addSubview:image3];
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(detailTV.frame.origin.x+5, detailTV.frame.origin.y + 10, SCREEN_WIDTH, 16)];
    labeltext.text = @"备注";
    labeltext.font = [UIFont systemFontOfSize:14];
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [_tableView addSubview:labeltext];
    
    
    
   
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIImageView * smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, 19, 15, 6 )];
//    smallV.image = [UIImage imageNamed:@"notice"];
    [theView addSubview:smallV];
    
//    UIView * bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height, SCREEN_WIDTH - 30, 70)];
//    bigV.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
//    [theView addSubview:bigV];
//    
//    UILabel * bigL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 14)];
//    bigL.text = @"温馨提示:";
//    bigV.layer.cornerRadius = 2;
//    bigL.font = [UIFont systemFontOfSize:14];
//    bigL.textColor = [UIColor whiteColor];
//    [bigV addSubview:bigL];
//    
//    UILabel * smallL = [[UILabel alloc]initWithFrame:CGRectMake(10, bigL.frame.origin.y + bigL.frame.size.height, bigV.frame.size.width - 10, 50)];
//    smallL.text = @"金额少于100元人民币是不可以提现的呢,请努力多积累点银子再来吧。";
//    smallL.numberOfLines = 0;
//    smallL.textColor = [UIColor whiteColor];
//    smallL.font = [UIFont systemFontOfSize:12];
//    [bigV addSubview:smallL];
    
    _tableView.tableFooterView = theView;
    
    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    swipeGestureUp.direction =  UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    swipeGestureDown.direction =  UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureDown];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"asd" object:nil];
    
    AppDelegate * app = APPDELEGATE;
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
    blackView.alpha = 0.7;
    [app.window addSubview:blackView];
    
    passwordView = [[WritePassWordView alloc]initWithFrame:CGRectMake(0, 0, 240, 150)];
    [passwordView.yesButton addTarget:self action:@selector(yesaction) forControlEvents:UIControlEventTouchUpInside];
    [passwordView.noButton addTarget:self action:@selector(noaction) forControlEvents:UIControlEventTouchUpInside];
    [app.window addSubview:passwordView];
    
    blackView.hidden = YES;
    passwordView.hidden = YES;
}

- (void)refresh
{
    [self urlRequestPost];
}

//post请求
- (void)post
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetInfo" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            balance = [NSString stringWithFormat:@"%@", [self objectForKeyNew:dic1 key:@"balance"]];
            [self upView];
        }else{
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}

//没有数据记录时的判断
- (NSString *)objectForKeyNew:(NSDictionary *)dic key:(NSString *)key
{
    if ([dic objectForKey:key] == nil) {
        return @"0.00";
    }
    return [dic objectForKey:key];
}

- (void)upView
{
    UIView * upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 69)];
    upView.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    [self.view addSubview:upView];
    
    UIImageView * moneyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    moneyImage.image = [UIImage imageNamed:@"mywallet_money"];
    [upView addSubview:moneyImage];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    label.text = [NSString stringWithFormat:@"可提现金额：￥ %@",balance];
    [label sizeToFit];
    label.center = CGPointMake(SCREEN_WIDTH / 2  +  20, upView.frame.size.height / 2 + 15);
    [upView addSubview:label];
    
    moneyImage.center = CGPointMake(label.frame.origin.x - 9 - 17, label.center.y);
}

- (void)buttonFinish:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 1) {
        [_textField1 resignFirstResponder];
    }
    if (buttona.tag == 2) {
        [_textField2 resignFirstResponder];
    }
    if (buttona.tag == 3) {
        [detailTV resignFirstResponder];
    }
}
- (void)buttonBack:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 2) {
        [_textField1 becomeFirstResponder];
    }
    if (buttona.tag == 3) {
        [_textField2 becomeFirstResponder];
    }
    
}
- (void)buttonNext:(id)sender
{
    UIButton * buttona = sender;
    if (buttona.tag == 1) {
        [_textField2 becomeFirstResponder];
    }
    if (buttona.tag == 2) {
        [detailTV becomeFirstResponder];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if ([textField isEqual: _textField1]) {
            image1.image = [UIImage imageNamed:@"recharge_edit_nor.png"];
        }if ([textField isEqual: _textField2]) {
            image2.image = [UIImage imageNamed:@"edit_phone_nor.png"];
        }
        if (textField == _accountTF) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_nor"]];
            aliPayImageV.image = image.image;
            
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
        if (textField == _accountTFAgain) {
            aliPayImageV1.image = [UIImage imageNamed:@"edit_alipay_nor"];
            
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
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual: _textField1]) {
            image1.image = [UIImage imageNamed:@"recharge_edit_pre.png"];
    }
    if ([textField isEqual: _textField2]) {
            image2.image = [UIImage imageNamed:@"edit_phone_pre.png"];
    }
    if ([textField isEqual:_accountTF]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_pre"]];
        aliPayImageV.image = image.image;
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
    if ([textField isEqual:_accountTFAgain]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"edit_alipay_pre"]];
        aliPayImageV1.image = image.image;
        NSTimeInterval animationDuration=0.10f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移n个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-70,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
    
}

- (void)textfield1Status:(UITextField *)textField
{
    const char * ch = [[textField.text substringWithRange:NSMakeRange(textField.text.length - 1, 1)] cStringUsingEncoding:NSUTF8StringEncoding];
    if ([[textField.text substringWithRange:NSMakeRange(textField.text.length - 1, 1)]isEqualToString:@" "] || ((*ch < 48) && *ch != 46) || ((*ch > 57) && *ch != 46)) {
        if (textField.text.length > 0) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    image3.image = [UIImage imageNamed:@"edit_account_pre.png"];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (detailTV.text.length == 0) {
        image3.image = [UIImage imageNamed:@"edit_account_nor.png"];
    }
}

- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [_textField1 resignFirstResponder];
    [_textField2 resignFirstResponder];
    [_accountTF resignFirstResponder];
    [_accountTFAgain resignFirstResponder];
    [detailTV resignFirstResponder];
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

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.leftImg.image = [UIImage imageNamed:@"recharge_edit_pre"];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField.text.length == 0) {
//        self.leftImg.image = [UIImage imageNamed:@"recharge_edit_nor"];
//    }
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        if ([textField isEqual:textFieldPass]) {
            const char * ch=[textFieldPass.text cStringUsingEncoding:NSUTF8StringEncoding];
            if (*ch == 0){
                return YES;
            }
            if (textFieldPass.text.length > 7) {
                return NO;
            }else{
                return YES;
            }
        }
    NSRange tempRange = [textField selectedRange];
    
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    
    if(*ch == 0)
        return YES;
    if ([textField isEqual:_textField1]) {
        if( *ch != 46 && ( *ch<48 || *ch>57) )
            return NO;
        
        if([textField.text rangeOfString:@"."].length==1)
        {
            if(*ch == 0)
                return YES;
            NSUInteger length=[textField.text rangeOfString:@"."].location;
            
            
            //小数点后面两位小数 且不能再是小数点
            
            if([[textField.text substringFromIndex:length] length]>2 || *ch ==46){   //3表示后面小数位的个数。。
                if (tempRange.location <= length) {
                    if ([[textField.text substringToIndex:length] length] < 5 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return NO;
                }
            }else{
                if (tempRange.location > length) {
                    return YES;
                }else{
                    if ([[textField.text substringToIndex:length] length] < 5 && (*ch >= 48 && *ch <= 57) && *ch != 46) {
                        return YES;
                    }else{
                        return NO;
                    }
                }
            }
        }
        
        if(range.location>4){
            if ([string isEqualToString:@"."]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

- (void)textFieldDidChange:(id)sender
{
    //    const char * ch = [[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)] cStringUsingEncoding:NSUTF8StringEncoding];
    //
    //    if ([[field.text substringWithRange:NSMakeRange(field.text.length - 1, 1)]isEqualToString:@" "] || ((*ch < 48) && *ch != 46) || ((*ch > 57) && *ch != 46)) {
    //        if (field.text.length > 0) {
    //            field.text = [field.text substringToIndex:field.text.length - 1];
    //        }
    //    }
    //    if (field.text.length > 5 && [field.text rangeOfString:@"."].location==NSNotFound) {
    //        field.text = [field.text substringToIndex:field.text.length - 1];
    //    }
    UITextField * field = (UITextField *)sender;
    if ([field isEqual:textFieldPass]) {
        NSString * str = textFieldPass.text;
        if (textFieldPass.text.length > 6) {
            str = [str substringToIndex:6];
        }
        NSInteger i = 0;
        i = str.length;
        for(UIImageView *view in [passwordView.theView subviews])
        {
            [view removeFromSuperview];
        }
        textFieldPass.text = str;
        for (int i = 0; i < 5; i++) {
            UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * passwordView.a, 0, 1, passwordView.a)];
            view1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
            [passwordView.theView addSubview:view1];
        }
        NSInteger x = 6 < str.length ? 6:str.length;
        for (int j = 0; j < x; j++) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            view.layer.cornerRadius = 5;
            view.layer.masksToBounds = YES;
            view.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
            view.center = CGPointMake( passwordView.a / 2 + j * passwordView.a, passwordView.a / 2);
            [passwordView.theView addSubview:view];
        }
    }else{
    if ([field.text doubleValue] > 20000.00) {
        field.text = @"20000.00";
    }}
}

- (void)regController:(id)sender
{
//    if ([self.aliPayAccount isEqualToString: @""]) {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请先绑定支付宝账号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去绑定", nil];
//        [alert show];
//        return;
//    }
    if (_textField1.text.length == 0 ) {
        [AutoDismissAlert autoDismissAlert:@"请填写提现金额"];
        [_textField1 becomeFirstResponder];
        return;
    }
    if (_textField2.text.length == 0 ) {
        [AutoDismissAlert autoDismissAlert:@"请填写电话"];
        [_textField2 becomeFirstResponder];
        return;
    }
    if ([_textField1.text intValue] < 100 ) {
        [AutoDismissAlert autoDismissAlert:@"提现金额不得少于100元"];
        [_textField1 becomeFirstResponder];
        return;
    }
    if ([_textField1.text intValue] > 20000) {
        [AutoDismissAlert autoDismissAlert:@"提现金额不得多于20000元"];
        [_textField1 becomeFirstResponder];
        return;
    }
    if (_accountTF.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写支付宝账号"];
        [_accountTF becomeFirstResponder];
        return;
    }
    if (_accountTFAgain.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请再次填写支付宝账号"];
        [_accountTFAgain becomeFirstResponder];
        return;
    }
    if (![_accountTF.text isEqualToString:_accountTFAgain.text]) {
        [AutoDismissAlert autoDismissAlert:@"请确保两次填写的支付宝账号相同"];
        [_accountTFAgain becomeFirstResponder];
        return;
    }
    if ([_textField1.text intValue] > [balance intValue]) {
        [AutoDismissAlert autoDismissAlert:@"余额不足"];
        [_textField1 becomeFirstResponder];
        return;
    }
    [self havepassword];
}

//获取支付密码
- (void)havepassword
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetQuestion" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [HUD removeFromSuperview];
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            if ([[dic1 objectForKey:@"question"] isEqualToString:@""]) {
                CreateGetMoneyViewController * vc = [[CreateGetMoneyViewController alloc]init];
                vc.point = @"tixian";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self shurumima];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

- (void)shurumima
{
    [textFieldPass becomeFirstResponder];
    blackView.hidden = NO;
    passwordView.hidden = NO;
    passwordView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.33);
}

- (void)yesaction
{

//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"处理中,请稍后";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
//    //拼接post参数
//    NSDictionary * dic = [self parametersForDic:@"accountApplyWithdraw" parameters:@{ACCOUNT_PASSWORD, @"remark":detailTV.text, @"mobile":_textField2.text,@"withdrawCash":_textField1.text,@"paypass":textFieldPass.text,@"zhifubao":account}];
//    //发送post请求
//    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSLog(@"%@",[dic objectForKey:@"message"]);
//        int result = [[dic objectForKey:@"result"]intValue];
//        if (result == 0) {
//            [passwordView setHidden:YES];
//            [blackView setHidden: YES];
//            [AutoDismissAlert autoDismissAlert:@"提现成功"];
//            SubofclassDrawRecordsViewController * vc = [[SubofclassDrawRecordsViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        [HUD hide:YES];
//        [HUD removeFromSuperview];
//    }];

    NSString *text = [_accountTFAgain.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountApplyWithdraw" parameters:@{ACCOUNT_PASSWORD, @"remark":detailTV.text, @"mobile":_textField2.text,@"withdrawCash":_textField1.text,@"paypass":textFieldPass.text,@"zhifubao":text}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [passwordView setHidden:YES];
            [blackView setHidden: YES];
            [AutoDismissAlert autoDismissAlert:@"提现成功"];
            SubofclassDrawRecordsViewController * vc = [[SubofclassDrawRecordsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD hide:YES];
        [HUD removeFromSuperview];
    }];

}

- (void)noaction
{
    for(UIImageView *view in [passwordView.theView subviews])
    {
        [view removeFromSuperview];
    }
    for (int i = 0; i < 5; i++) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((i + 1) * passwordView.a, 0, 1, passwordView.a)];
        view1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [passwordView.theView addSubview:view1];
    }
    textFieldPass.text = @"";
    blackView.hidden = YES;
    passwordView.hidden = YES;
    [textFieldPass resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
    }
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        SubOfAliPayViewController * vc = [[SubOfAliPayViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetInfo" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic)
     {
         NSDictionary *dataDic = [dic objectForKey:@"data"];
         self.aliPayAccount = [dataDic objectForKey:@"zhifubao"];
         NSLog(@"self.aliPayAccount = %@",self.aliPayAccount);
     } andFailureBlock:^{
         
     }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawCell * cell = [[WithdrawCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        return 50;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    if (textView == textViewPass) {
//        return NO;
//    }
    [detailTV resignFirstResponder];
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

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if (textView == textViewPass) {
//        return NO;
//    }
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-140,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        
        if ([text isEqualToString:@"\n"]) {//检测到“完成”
            [textView resignFirstResponder];//释放键盘
            return NO;
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
