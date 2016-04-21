//
//  AnswerQuestionViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "SuggestionView2Cell.h"
#import "SuggestionView3Cell.h"
#import "RenewPasswordViewController.h"
#import "QuestionOptionViewController.h"
#import "MyChatViewController.h"

@interface AnswerQuestionViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    UILabel * button;
    UIImageView * theImage;
    UIActionSheet * actionSheet;
    UIWebView * phoneCallWebView;
}
@property (nonatomic, strong)UITextField * textField;
@end

@implementation AnswerQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_sign isEqualToString:@"1"]) {
        self.title = @"重置支付密码";
    }else{
        self.title = @"重设密保问题";
    }
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 110/2, 50/2);
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame)*0.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(checkAnswer) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH, 15)];
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label.text = @"请回答密保问题";
    [self.view addSubview:label];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height + 20, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, tableView.frame.origin.y + tableView.frame.size.height + 25, SCREEN_WIDTH, 14)];
    label1.text = @"忘记密保答案";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [self.view addSubview:label1];
    
    UIButton * button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, label1.frame.origin.y + label1.frame.size.height + 5, SCREEN_WIDTH, 14)];
    [button1 setTitle:@"点击此处联系客服: bang" forState:UIControlStateNormal];
    [button1 setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
    button1.titleLabel.font = SIZE_FOR_14;
    [button1 addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    
    theImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 20 + 20 + 30, 10, 6)];
    //    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    _button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button = [[UILabel alloc]initWithFrame:CGRectMake(theImage.frame.origin.x + theImage.frame.size.width - 10, theImage.center.y - 2, 180, 16)];
    [self havepassword];
//    [button setTitle:@"请选择问题" forState:UIControlStateNormal];
    button.textColor = [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1];
    button.font = [UIFont systemFontOfSize:16];
    button.text = @"";
    [self.view addSubview:button];
    
    
    theImage.image = [UIImage imageNamed:@"lakai"];
//    [self.view addSubview:theImage];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(theImage.frame.origin.x, theImage.frame.origin.y + theImage.frame.size.height + 60,SCREEN_WIDTH - button.frame.origin.x - 20 , 30)];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.placeholder = @"请输入答案";
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate * app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)checkAnswer
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountCheckAnswer" parameters:@{ACCOUNT_PASSWORD, @"question":button.text, @"answer":text}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self gotochange];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)gotochange
{
    if ([_sign isEqualToString:@"1"]) {
        RenewPasswordViewController * vc = [[RenewPasswordViewController alloc]init];
        vc.question = button.text;
        NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        if (text.length == 0) {
            [AutoDismissAlert autoDismissAlert:@"请填写答案"];
            [_textField becomeFirstResponder];
            return;
        }
        vc.answer = text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        QuestionOptionViewController * vc = [[QuestionOptionViewController alloc]init];
        vc.sign = @"2";
        vc.oldQuestion = button.text;
        NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        if (text.length == 0) {
            [AutoDismissAlert autoDismissAlert:@"请填写答案"];
            [_textField becomeFirstResponder];
            return;
        }
        vc.oldAnswer = text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//获取问题
- (void)havepassword
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"处理中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];

    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetQuestion" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            button.text = [dic1 objectForKey:@"question"];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
    
}

- (void)call
{
//    NSString *phoneNum = @"13390065920";// 电话号码
//    
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
//    
//    if ( !phoneCallWebView ) {
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
//    }
//    
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
//    NSDictionary * tempDic = @{@"account": @"bang", @"nickname":@"bang", @"avatar":@"http://testapi.shurenbang.net/upload/face/20141129/6657b634-4dbc-442a-aff1-f508f0a57b32_sm.png"};
    
    NSDictionary * tempDic = @{@"account": @"bang", @"nickname":@"bang", @"avatar":@"http://mapi.shurenbang.net/upload/face/20141129/6657b634-4dbc-442a-aff1-f508f0a57b32_sm.png"};
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = [tempDic objectForKey:@"account"];
    user.name = [tempDic objectForKey:@"nickname"];
    user.portraitUri = [tempDic objectForKey:@"avatar"];
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myChatVC animated:YES];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_textField resignFirstResponder];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textField) {
        NSTimeInterval animationDuration=0.10f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移n个单位，按实际情况设置
        CGRect rect=CGRectMake(0.0f,-64,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
    return YES;
}


- (void)action
{
    [actionSheet showInView:self.view];
}


- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SuggestionView2Cell * cell = [[SuggestionView2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.label.text = @"密保问题";
        return cell;
    }
    if (indexPath.section == 1) {
        SuggestionView3Cell * cell = [[SuggestionView3Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.label.text = @"问题答案";
        return cell;
    }
    return nil;
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
