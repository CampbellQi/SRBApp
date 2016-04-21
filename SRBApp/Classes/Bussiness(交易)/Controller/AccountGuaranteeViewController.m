//
//  AccountGuaranteeViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/28.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "AccountGuaranteeViewController.h"
#import "PersonalViewController.h"
#import "SubViewController.h"
#import "HelpViewController.h"

@interface AccountGuaranteeViewController ()
@end

@implementation AccountGuaranteeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要担保";

    xinxinnumber = @"3";
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 60, 25);
    [regBtn setTitle:@"提 交" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = 2;
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:scrollView];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 15 , SCREEN_WIDTH , 120)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:whiteView];
    
    publishiMan = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH , 30)];
    publishiMan.font = [UIFont systemFontOfSize:14];
    publishiMan.textColor = [GetColor16 hexStringToColor:@"#434343"];
    publishiMan.text = [NSString stringWithFormat:@"    卖家: %@", _nickname];
    publishiMan.userInteractionEnabled = YES;
    [scrollView addSubview:publishiMan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotopush)];
    [publishiMan addGestureRecognizer:tap];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, publishiMan.frame.origin.y + publishiMan.frame.size.height + 1, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [scrollView addSubview:breakView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(15, breakView.frame.origin.y + 15, 60, 60)];
    [image sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [scrollView addSubview:image];
    
    bussinessInformation = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 12, image.frame.origin.y, 200, 12)];
    bussinessInformation.text =  _thetitle;
    bussinessInformation.font = [UIFont systemFontOfSize:14];
    bussinessInformation.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [scrollView addSubview:bussinessInformation];
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(bussinessInformation.frame.origin.x, bussinessInformation.frame.origin.y + bussinessInformation.frame.size.height + 10, 100, 14)];
    priceLabel.text = [NSString stringWithFormat:@"￥ %@", _bangPrice];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    priceLabel.font = SIZE_FOR_14;
//    [priceLabel sizeToFit];
    [scrollView addSubview:priceLabel];
    
    UILabel * postLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 8, 30, 16)];
    postLabel.font = [UIFont systemFontOfSize:12];
    postLabel.textAlignment = NSTextAlignmentCenter;
    postLabel.layer.cornerRadius = 2;
    postLabel.layer.masksToBounds = YES;
    postLabel.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
    postLabel.textColor = [UIColor whiteColor];
    [scrollView addSubview:postLabel];
    if ([self.freeShipment isEqualToString:@"0"]) {
        postLabel.hidden = YES;
        UILabel * postPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 8, 100, 16)];
        postPriceLabel.text = [NSString stringWithFormat:@"运费:￥ %@", self.postPrice];
        postPriceLabel.font = [UIFont systemFontOfSize:12];
        postPriceLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [scrollView addSubview:postPriceLabel];
    }
    else{
        postLabel.text = @"包邮";
//        postLabel.frame = CGRectMake(priceLabel.frame.origin.x + priceLabel.frame.size.width + 20, priceLabel.frame.origin.y + 5, 30, 16);
    }
    
    UILabel *sendLabel =[[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 10, 100, 14)];
    sendLabel.font = SIZE_FOR_12;
    sendLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    
    sendLabel.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:sendLabel];
    
    UILabel * postLable = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 10, 100, 12)];
    postLable.text = _postString;
    postLable.textColor = [GetColor16 hexStringToColor:@"#959595"];
    postLable.font = SIZE_FOR_12;
    [scrollView addSubview:postLable];
    
    UIView * breakView1 = [[UIView alloc]initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 15, SCREEN_WIDTH, 60)];
    breakView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [scrollView addSubview:breakView1];
    
    //担保赏金view
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 30, SCREEN_WIDTH, 30)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:moneyView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 30)];
    moneyLabel.font = SIZE_FOR_14;
    moneyLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    moneyLabel.text = @"担保赏金:";
    [moneyView addSubview:moneyLabel];
    
    self.assureLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 100, 30)];
    self.assureLabel.font = SIZE_FOR_14;
    self.assureLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.assureLabel.textAlignment = NSTextAlignmentLeft;
    self.assureLabel.text = [NSString stringWithFormat:@"￥ %@", self.guaranteePrice];
    [moneyView addSubview:self.assureLabel];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, breakView1.frame.origin.y + breakView1.frame.size.height , SCREEN_WIDTH , 80)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 30, 80)];
    detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色不含邮费百家包邮
    detailTV.font = SIZE_FOR_IPHONE;//设置字体名字和字体大小
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    detailTV.returnKeyType = UIReturnKeyDone;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    detailTV.inputAccessoryView = finishiView1;
    
    [view addSubview: detailTV];//加入到整个页面中
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH, 14)];
    labeltext.text = @"我给TA担保的理由是...";
    labeltext.font = SIZE_FOR_IPHONE;
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [detailTV addSubview:labeltext];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(detailTV.frame.origin.x, detailTV.frame.origin.y + detailTV.frame.size.height + 10, 120, 16)];
//    label.text = @"商品信心指数:";
//    label.textColor = [UIColor blackColor];
//    [self.view addSubview:label];
//    
//    button1 = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y , 16, 12)];
//    [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
//    button1.tag = 100;
//    [self.view addSubview:button1];
//    
//    button2 = [[UIButton alloc]initWithFrame:CGRectMake(button1.frame.origin.x + button1.frame.size.width, label.frame.origin.y, 16, 12)];
//    [button2 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
//    [button2 addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
////    button2.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
//    button2.tag = 101;
//    [self.view addSubview:button2];
//    
//    button3 = [[UIButton alloc]initWithFrame:CGRectMake(button2.frame.origin.x + button2.frame.size.width, label.frame.origin.y, 16, 12)];
//    [button3 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
//    [button3 addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
////    button3.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
//    button3.tag = 102;
//    [self.view addSubview:button3];
//    
//    button4 = [[UIButton alloc]initWithFrame:CGRectMake(button3.frame.origin.x + button3.frame.size.width, label.frame.origin.y, 16, 12)];
//    [button4 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
//    [button4 addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
////    button4.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
//    button4.tag = 103;
//    [self.view addSubview:button4];
//    
//    button5 = [[UIButton alloc]initWithFrame:CGRectMake(button4.frame.origin.x + button4.frame.size.width, label.frame.origin.y, 16, 12)];
//    [button5 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
//    [button5 addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
////    button5.backgroundColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
//    button5.tag = 104;
//    [self.view addSubview:button5];

    UIImageView * smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view.frame.origin.y + view.frame.size.height + 10, 15, 6)];
    smallV.image = [UIImage imageNamed:@"notice"];
    [scrollView addSubview:smallV];
    
    UIView * bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 85)];
    bigV.layer.cornerRadius = 2;
    bigV.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
    [scrollView addSubview:bigV];
    
    UILabel * bigL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 14)];
    bigL.text = @"温馨提示:";
    bigL.font = [UIFont systemFontOfSize:14];
    bigL.textColor = [UIColor whiteColor];
    [bigV addSubview:bigL];
    
    UILabel * smallL = [[UILabel alloc]initWithFrame:CGRectMake(10, bigL.frame.origin.y + bigL.frame.size.height + 8, bigV.frame.size.width - 15, 45)];
    smallL.text = @"在为熟人提供担保后, 交易成功会获得赏金, 如果担保交易出现问题, 同样会扣减您的信用, 买卖出现问题由担保人出面调解。";
    smallL.numberOfLines = 0;
    smallL.textColor = [UIColor whiteColor];
    smallL.font = [UIFont systemFontOfSize:12];
    [bigV addSubview:smallL];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130,bigV.frame.size.height + bigV.frame.origin.y + 5, 115, 14)];
    [button setTitle:@"查看更多帮助 >>" forState:UIControlStateNormal];
    [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(askHelp) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = SIZE_FOR_14;
    [scrollView addSubview:button];
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, button.frame.origin.y + button.frame.size.height + 5);
    
    UITapGestureRecognizer *tapReturnKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard:)];
    [self.view addGestureRecognizer:tapReturnKB];
    
}

- (void)askHelp
{
    HelpViewController * vc = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotopush
{
    SubViewController * vc = [[SubViewController alloc]init];
    vc.account = _account;
    vc.myRun = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1)
    {
        [detailTV resignFirstResponder];
    }
}

//点击屏幕回收键盘
- (void)returnKeyBoard:(UITapGestureRecognizer *)sender
{
    [detailTV resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    NSTimeInterval animationDuration = 0.10f;
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
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-100,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}



- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonaction:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 100) {
        [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        xinxinnumber = @"1";
    }else if (button.tag == 101){
        [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        xinxinnumber = @"2";
    }else if (button.tag == 102){
        [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        xinxinnumber = @"3";
    }else if (button.tag == 103){
        [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"kpzs_1.png"] forState:UIControlStateNormal];
        xinxinnumber = @"4";
    }else
    {
        [button1 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button3 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button4 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"kpzs_3.png"] forState:UIControlStateNormal];
        xinxinnumber = @"5";
    }
}

- (void)regController:(id)sender
{
    if (detailTV.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写担保理由"];
        [detailTV becomeFirstResponder];
        return;
    }
    //拼接post参数
    NSLog(@"%@, %@!!!!!!!!!!!!!",_idNumber, detailTV.text);
    NSDictionary * dic = [self parametersForDic:@"accountGuaranteePost" parameters:@{ ACCOUNT_PASSWORD,
                                                                                      @"id":_idNumber,
                                                                                      @"title": @"我来担保",
                                                                                      @"content": detailTV.text}
                          ];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"asd" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(result == 200){
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
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

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
    }
}

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
