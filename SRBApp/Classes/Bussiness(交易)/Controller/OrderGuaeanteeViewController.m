//
//  OrderGuaeanteeViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "OrderGuaeanteeViewController.h"
@class OrderAssureViewController;

@interface OrderGuaeanteeViewController ()

@end

@implementation OrderGuaeanteeViewController

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
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 15 , SCREEN_WIDTH , 120)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    publishiMan = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH , 30)];
    publishiMan.font = [UIFont systemFontOfSize:14];
    publishiMan.textColor = [GetColor16 hexStringToColor:@"#434343"];
    publishiMan.text = [NSString stringWithFormat:@"    买家: %@", self.buyernick];
    [self.view addSubview:publishiMan];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, publishiMan.frame.origin.y + publishiMan.frame.size.height + 1, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(15, breakView.frame.origin.y + 15, 60, 60)];
    [image sd_setImageWithURL:[NSURL URLWithString:_photoUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    
    bussinessInformation = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 12, image.frame.origin.y, 200, 17)];
    bussinessInformation.text =  _thetitle;
    bussinessInformation.font = [UIFont systemFontOfSize:14];
    bussinessInformation.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:bussinessInformation];
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(bussinessInformation.frame.origin.x, bussinessInformation.frame.origin.y + bussinessInformation.frame.size.height + 10, 100, 17)];
    priceLabel.text = [NSString stringWithFormat:@"￥ %@", _bangPrice];
    priceLabel.center = CGPointMake(bussinessInformation.frame.origin.x + priceLabel.frame.size.width / 2, image.frame.origin.y + image.frame.size.height / 2);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    priceLabel.font = SIZE_FOR_14;
    [self.view addSubview:priceLabel];
    
    UILabel *sendLabel =[[UILabel alloc] initWithFrame:CGRectMake( priceLabel.frame.origin.x, image.frame.origin.y + image.frame.size.height - 14, 220, 14)];
    sendLabel.font = SIZE_FOR_12;
    sendLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    sendLabel.text = [NSString stringWithFormat:@"卖家：%@",self.sellernick];
    sendLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sendLabel];
    
    UILabel * postLable = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 10, 100, 14)];
    postLable.text = _postString;
    postLable.textColor = [GetColor16 hexStringToColor:@"#959595"];
    postLable.font = SIZE_FOR_12;
    [self.view addSubview:postLable];
    
    UIView * breakView1 = [[UIView alloc]initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 15, SCREEN_WIDTH, 60)];
    breakView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView1];
    
    //担保赏金view
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 30, SCREEN_WIDTH, 30)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:moneyView];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 30)];
    moneyLabel.font = SIZE_FOR_14;
    moneyLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    moneyLabel.text = @"担保赏金：";
    [moneyView addSubview:moneyLabel];
    
    self.assureLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 100, 30)];
    self.assureLabel.font = SIZE_FOR_14;
    self.assureLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.assureLabel.textAlignment = NSTextAlignmentLeft;
    self.assureLabel.text = [NSString stringWithFormat:@"￥ %@", self.guaranteePrice];
    [moneyView addSubview:self.assureLabel];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, breakView1.frame.origin.y + breakView1.frame.size.height , SCREEN_WIDTH , 120)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(15, view.frame.origin.y + 5, SCREEN_WIDTH - 30, 170)];
    detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色不含邮费百家包邮
    detailTV.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
    //        self.textView.delegate = self;//设置它的委托方法
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    //        self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容
    detailTV.returnKeyType = UIReturnKeyDone;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    detailTV.scrollEnabled = YES;//是否可以拖动
    detailTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    detailTV.inputAccessoryView = finishiView1;
    
    [self.view addSubview: detailTV];//加入到整个页面中
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(detailTV.frame.origin.x + 5, detailTV.frame.origin.y + 10, SCREEN_WIDTH, 17)];
    labeltext.text = @"我给TA担保的理由是...";
    labeltext.font = SIZE_FOR_14;
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [self.view addSubview:labeltext];
    
    UIImageView * smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view.frame.origin.y + view.frame.size.height + 10, 15, 6)];
    smallV.image = [UIImage imageNamed:@"notice"];
    [self.view addSubview:smallV];
    
    UIView * bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 85)];
    bigV.layer.cornerRadius = 2;
    bigV.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
    [self.view addSubview:bigV];
    
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
    
    UITapGestureRecognizer *tapReturnKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard:)];
    [self.view addGestureRecognizer:tapReturnKB];
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
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
    NSDictionary * dic = [self parametersForDic:@"accountGuaranteeOrder" parameters:@{ACCOUNT_PASSWORD,@"grade":@"0",@"orderId":_idNumber,@"title": _thetitle,@"content": detailTV.text}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [self.orderAssureVC urlRequestPost];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (detailTV.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            labeltext.hidden=NO;//隐藏文字
        }else{
            labeltext.hidden=YES;
        }
    }else{//textview长度不为0
        if (detailTV.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                labeltext.hidden=NO;
            }else{//不是删除
                labeltext.hidden=YES;
            }
        }else{//长度不为1时候
            labeltext.hidden=YES;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
