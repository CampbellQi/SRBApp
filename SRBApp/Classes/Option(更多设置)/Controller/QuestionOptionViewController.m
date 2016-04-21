//
//  QuestionOptionViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "QuestionOptionViewController.h"
#import "SuggestionView2Cell.h"
#import "SuggestionView3Cell.h"
#import "IdSafeViewController.h"
#import "GetMoneyPassWordViewController.h"
#import "CardNumReal.h"
#import "WithdrawActivityViewController.h"
#import "ZZGoPayViewController.h"

@interface QuestionOptionViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate>
{
    UIButton * button;
    UIImageView * theImage;
    UIActionSheet * actionSheet1;
    UIActionSheet * actionSheet2;
    UIButton * button2;
    UIImageView * theImage2;
    
    NSString * question;
    NSString * answer;
    
    NSString * cardType;
    NSString * cardNumber;
    
    UITableView * tableView1;
    UITableView * tableView2;
    
    UIAlertView * alert1;
    UIAlertView * alert2;
}
@property (nonatomic, strong)UITextField * textField;
@property (nonatomic, strong)UITextField * textField2;
@end

@implementation QuestionOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_sign isEqualToString:@"2"]) {
        self.title = @"重设密保问题";
    }else{
        self.title = @"创建支付密码";
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
    if ([self.title isEqualToString: @"重设密保问题"]) {
        [rightBtn setTitle:@"重 置" forState:UIControlStateNormal];
    }else{
        [rightBtn setTitle:@"提 交" forState:UIControlStateNormal];
    }
    
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(createpassword) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, SCREEN_WIDTH, 15)];
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label.text = @"请选择密保问题并给出答案";
    [self.view addSubview:label];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height + 20, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    tableView1.scrollEnabled = NO;
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [self.view addSubview:tableView1];
    
    theImage = [[UIImageView alloc]initWithFrame:CGRectMake(110, 20 + 20 + 30, 10, 6)];
    //    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    _button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button = [[UIButton alloc]initWithFrame:CGRectMake(theImage.frame.origin.x + theImage.frame.size.width , theImage.center.y - 2, 100, 16)];
    [button setTitle:@"请选择问题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    theImage.image = [UIImage imageNamed:@"lakai"];
    [self.view addSubview:theImage];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(theImage.frame.origin.x, theImage.frame.origin.y + theImage.frame.size.height + 60,SCREEN_WIDTH - button.frame.origin.x - 20 , 30)];
    _textField.placeholder = @"请输入答案";
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
    
    if ([self.title isEqualToString: @"重设密保问题"]) {
        actionSheet1 = [[UIActionSheet alloc]initWithTitle:@"选择问题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"你的出生地是哪儿？",@"你的生日是哪天？",@"你最喜欢的颜色？",@"你最喜欢的水果？",@"你最喜欢的明星？",@"你的妈妈叫什么名字？",@"你妈妈的生日是哪天？",@"你的爸爸叫什么名字？",nil];
    }else{
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(25, tableView1.frame.origin.y + tableView1.frame.size.height + 20, SCREEN_WIDTH, 15)];
    label2.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label2.text = @"请选择证件类型并填写证件号码";
    [self.view addSubview:label2];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, label2.frame.origin.y + label2.frame.size.height + 20, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    tableView2.scrollEnabled = NO;
    tableView2.delegate = self;
    tableView2.dataSource = self;
    [self.view addSubview:tableView2];
    
    theImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 20 + 20 + 30 + _textField.frame.size.height + _textField.frame.origin.y + 10, 10, 6)];
    //    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    _button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(theImage2.frame.origin.x + theImage2.frame.size.width , theImage2.center.y - 2, 140, 16)];
    [button2 setTitle:@"请选择证件类型" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    [button2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    theImage2.image = [UIImage imageNamed:@"lakai"];
    [self.view addSubview:theImage2];
    
    _textField2 = [[UITextField alloc]initWithFrame:CGRectMake(theImage2.frame.origin.x, theImage2.frame.origin.y + theImage2.frame.size.height + 60,SCREEN_WIDTH - button2.frame.origin.x - 20 , 30)];
    _textField2.placeholder = @"请输入证件号码";
    _textField2.delegate = self;
    [self.view addSubview:_textField2];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
        
        actionSheet1 = [[UIActionSheet alloc]initWithTitle:@"选择问题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"你的出生地是哪儿？",@"你的生日是哪天？",@"你最喜欢的颜色？",@"你最喜欢的水果？",@"你最喜欢的明星？",@"你的妈妈叫什么名字？",@"你妈妈的生日是哪天？",@"你的爸爸叫什么名字？",nil];
    
    actionSheet2 = [[UIActionSheet alloc]initWithTitle:@"证件类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"中国居民身份证", @"港澳居民回乡证", @"台湾居民台胞证", @"外籍人士护照",nil];
    }
}

- (void)createpassword
{
    NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *text2 = [_textField2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (question.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请选择问题"];
        return;
    }
    if (text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写答案"];
        [_textField becomeFirstResponder];
        return;
    }
    if ([self.title isEqualToString: @"重设密保问题"]) {
        
    }else{
        if (cardType.length == 0) {
            [AutoDismissAlert autoDismissAlert:@"请选择证件类型"];
            return;
        }
        if (text2.length == 0) {
            [AutoDismissAlert autoDismissAlert:@"请填写证件号码"];
            [_textField2 becomeFirstResponder];
            return;
        }
        if (![CardNumReal validateIDCardNumber:text2] && [cardType isEqualToString:@"中国居民身份证"]) {
            [AutoDismissAlert autoDismissAlert:@"请填写正确的身份证号"];
            [_textField2 becomeFirstResponder];
            return;
        }
    }
    if ([_sign isEqualToString:@"2"]) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountSetQuestion" parameters:@{ACCOUNT_PASSWORD,@"question": self.oldQuestion,@"answer": self.oldAnswer,@"newquestion": question,@"newanswer": text
                                                                                       }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"密保问题是: %@  答案是: %@  请牢记!", question, text] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
                [AutoDismissAlert autoDismissAlert:[NSString stringWithFormat:@"密保问题是: %@  答案是: %@  请牢记!", question, text]];
                //            GetMoneyPassWordViewController * vc = [[GetMoneyPassWordViewController alloc]init];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[GetMoneyPassWordViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
                }
                
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }else{
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountSetPaypass" parameters:@{ACCOUNT_PASSWORD,
                                                                                      @"question": question,
                                                                                      @"answer": text,
                                                                                      @"paypass": _paypassword,
                                                                                      @"locality":cardType,
                                                                                      @"idcard":text2}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                
//                alert1 = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"", text2] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定" , nil];
//                [alert1 show];
                [AutoDismissAlert autoDismissAlert:[NSString stringWithFormat:@"密保问题是: %@  答案是: %@  请牢记!你填写的证件号码为:%@, 一旦确定, 将无法更改!", question, _textField.text,text2]];
                if ([_point isEqualToString:@"tixian"]) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[WithdrawActivityViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            break;
                        }
                    }
                }else if([_point isEqualToString:@"fukuan"]){
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[ZZGoPayViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            break;
                        }
                    }
                }else{
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[IdSafeViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            break;
                        }
                    }
                }
                
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:alert1]) {
        if (buttonIndex == 1) {
//            alert2 = [[UIAlertView alloc]initWithTitle: message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert2 show];
            
//            IdSafeViewController * vc = [[IdSafeViewController alloc]init];
            
        }
    }
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [_textField2 resignFirstResponder];
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
    if (textField == _textField2) {
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textField2) {
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
    [actionSheet1 showInView:self.view];
}

- (void)action2
{
    [actionSheet2 showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual: actionSheet1]) {
        NSArray * array = @[@"你的出生地是哪儿？",@"你的生日是哪天？",@"你最喜欢的颜色？",@"你最喜欢的水果？",@"你最喜欢的明星？",@"你的妈妈叫什么名字？",@"你妈妈的生日是哪天？",@"你的爸爸叫什么名字？"];
        if (buttonIndex != 8) {
            UILabel * label = [[UILabel alloc]init];
            label.text = array[buttonIndex];
            [label sizeToFit];
            button.frame = CGRectMake(theImage.frame.origin.x + theImage.frame.size.width , theImage.center.y - 2 , label.frame.size.width, 16);
            [button setTitle:array[buttonIndex] forState:UIControlStateNormal];
            question = array[buttonIndex];
        }
    }
    if ([actionSheet isEqual: actionSheet2]) {
        NSArray * array = @[@"中国居民身份证", @"港澳居民回乡证", @"台湾居民台胞证", @"外籍人士护照"];
        if (buttonIndex != 4) {
            UILabel * label = [[UILabel alloc]init];
            label.text = array[buttonIndex];
            [label sizeToFit];
            button2.frame = CGRectMake(theImage2.frame.origin.x + theImage2.frame.size.width , theImage2.center.y - 2 , label.frame.size.width, 16);
            [button2 setTitle:array[buttonIndex] forState:UIControlStateNormal];
            cardType = array[buttonIndex];
        }
    }
    
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
    if ([tableView isEqual:tableView1]) {
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
    }
    else{
    if (indexPath.section == 0) {
        SuggestionView2Cell * cell = [[SuggestionView2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.label.text = @"证件类型";
        return cell;
    }
    if (indexPath.section == 1) {
        SuggestionView3Cell * cell = [[SuggestionView3Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.label.text = @"证件号码";
        return cell;
    }
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
