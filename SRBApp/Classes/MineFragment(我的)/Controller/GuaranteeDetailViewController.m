//
//  GuaranteeDetailViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeDetailViewController.h"
#import "PersonalViewController.h"
#import "SubViewController.h"
#import "SubSublPersonalViewController.h"

@interface GuaranteeDetailViewController ()<UITextViewDelegate>

@end

@implementation GuaranteeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要担保";
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    [self urlRequestPost];
}

#pragma mark - 控件初始化
- (void)customInit
{
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
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 15 , SCREEN_WIDTH , 120)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    //卖家
    publishiMan = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH , 30)];
    publishiMan.font = [UIFont systemFontOfSize:14];
    publishiMan.textColor = [GetColor16 hexStringToColor:@"#434343"];
    publishiMan.userInteractionEnabled = YES;
    [self.view addSubview:publishiMan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotopush)];
    [publishiMan addGestureRecognizer:tap];
    //分割线1
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, publishiMan.frame.origin.y + publishiMan.frame.size.height + 1, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView];
    //商品图片
    image = [[UIImageView alloc]initWithFrame:CGRectMake(15, breakView.frame.origin.y + 15, 60, 60)];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.clipsToBounds = YES;
    [self.view addSubview:image];
    
    bussinessInformation = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 10, image.frame.origin.y, 200, 14)];
    bussinessInformation.font = SIZE_FOR_12;
    bussinessInformation.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:bussinessInformation];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(bussinessInformation.frame.origin.x, bussinessInformation.frame.origin.y + bussinessInformation.frame.size.height + 10, 100, 14)];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    priceLabel.font = SIZE_FOR_14;
    //    [priceLabel sizeToFit];
    [self.view addSubview:priceLabel];
    
    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 80, priceLabel.frame.origin.y, 80, 25)];
    stateLabel.layer.masksToBounds = YES;
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.layer.cornerRadius = 2;
    stateLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:stateLabel];
    
    sendLabel =[[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x, image.frame.origin.y + image.frame.size.height - 14, 220, 14)];
    sendLabel.font = SIZE_FOR_12;
    sendLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    sendLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sendLabel];
    
    UIView * breakView1 = [[UIView alloc]initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 15, SCREEN_WIDTH, 60)];
    breakView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView1];
    
    //担保赏金view
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, image.frame.origin.y + image.frame.size.height + 30, SCREEN_WIDTH, 30)];
    moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:moneyView];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 30)];
    moneyLabel.font = SIZE_FOR_14;
    moneyLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    moneyLabel.text = @"担保赏金:";
    [moneyView addSubview:moneyLabel];
    
    assureLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 100, 30)];
    assureLabel.font = SIZE_FOR_14;
    assureLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    assureLabel.textAlignment = NSTextAlignmentLeft;
    [moneyView addSubview:assureLabel];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, breakView1.frame.origin.y + breakView1.frame.size.height , SCREEN_WIDTH , 80)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 30, 80)];
    detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色不含邮费百家包邮
    detailTV.font = SIZE_FOR_IPHONE;//设置字体名字和字体大小
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    detailTV.returnKeyType = UIReturnKeyDone;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [view addSubview: detailTV];//加入到整个页面中
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH, 14)];
    labeltext.text = @"我给TA担保的理由是...";
    labeltext.font = SIZE_FOR_IPHONE;
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [detailTV addSubview:labeltext];
    
    smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view.frame.origin.y + view.frame.size.height + 10, 15, 6)];
    smallV.image = [UIImage imageNamed:@"notice"];
    [self.view addSubview:smallV];
    
    bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 85)];
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
    
//    backGViwe  = [[UIView alloc] initWithFrame:CGRectMake(0, breakView1.frame.origin.y + breakView1.frame.size.height , SCREEN_WIDTH , 80)];
//    backGViwe.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backGViwe];
    
    //担保理由
    self.sanjiaoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(35, breakView1.frame.origin.y + breakView1.frame.size.height, 15, 6)];
    self.sanjiaoImageV.hidden = YES;
    self.sanjiaoImageV.image = [UIImage imageNamed:@"assure_reason"];
    [self.view addSubview:self.sanjiaoImageV];
    //理由背景
    self.assureReasonView = [[UIView alloc] initWithFrame:CGRectMake(15, self.sanjiaoImageV.frame.origin.y + self.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 80)];
    self.assureReasonView.hidden = YES;
    self.assureReasonView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [self.view addSubview:self.assureReasonView];
    
    self.assureLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 80, 16)];
    self.assureLable.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.assureLable.text = @"担保理由:";
    self.assureLable.font = SIZE_FOR_14;
    [self.assureReasonView addSubview:self.assureLable];
    //理由内容
    self.reasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.assureLable.frame.origin.x, self.assureLable.frame.origin.y + self.assureLable.frame.size.height + 7, self.assureReasonView.frame.size.width - 30, 40)];
    self.reasonContentLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.reasonContentLabel.font = SIZE_FOR_12;
    self.reasonContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.reasonContentLabel.numberOfLines = 0;
    [self.assureReasonView addSubview:self.reasonContentLabel];
    
    //日期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.assureReasonView.frame.size.width - 135, 9, 120, 15)];
    self.dateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.dateLabel.font = SIZE_FOR_12;
    [self.assureReasonView addSubview:self.dateLabel];
    
    UITapGestureRecognizer *tapReturnKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard:)];
    [self.view addGestureRecognizer:tapReturnKB];
    
    
    [self makeData];
}

#pragma mark - 进入商品详情
- (void)gotopush
{
    SubViewController * vc = [[SubViewController alloc]init];
    vc.account = [[[dataDic objectForKey:@"goods"]firstObject] objectForKey:@"account"];
    vc.myRun = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 返回按钮
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 担保请求
- (void)regController:(id)sender
{
    if (detailTV.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填写担保理由"];
        [detailTV becomeFirstResponder];
        return;
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGuaranteeOrder" parameters:@{ACCOUNT_PASSWORD,@"grade":@"0",@"orderId":self.orderID,@"title": bussinessInformation.text,@"content": detailTV.text}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
    
}

//点击屏幕回收键盘
- (void)returnKeyBoard:(UITapGestureRecognizer *)sender
{
    [detailTV resignFirstResponder];
}

#pragma mark - 控件赋值
- (void)makeData
{
    NSDictionary * goodsDic = [[dataDic objectForKey:@"goods"] objectAtIndex:0];
    publishiMan.text = [NSString stringWithFormat:@"    买家: %@",[dataDic objectForKey:@"buyernick"]];
    assureLabel.text = [NSString stringWithFormat:@"￥ %@", [dataDic objectForKey:@"guaranteeAmount"]];
    [image sd_setImageWithURL:[NSURL URLWithString:[goodsDic objectForKey:@"cover"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    bussinessInformation.text = [goodsDic objectForKey:@"title"];
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",[goodsDic objectForKey:@"bangPrice"]];
    sendLabel.text = [NSString stringWithFormat:@"卖家:%@",[goodsDic objectForKey:@"nickname"]];
    NSString * guarantorname = [dataDic objectForKey:@"guarantorname"];
    if (guarantorname.length != 0 && ![guarantorname isEqualToString:ACCOUNT_SELF]) {
        self.sanjiaoImageV.hidden = NO;
        self.assureReasonView.hidden = NO;
        view.hidden = YES;
        bigV.hidden = YES;
        smallV.hidden = YES;
        stateLabel.hidden = NO;
        self.reasonContentLabel.text = @"订单已被抢了";
        stateLabel.text = @"已被抢了";
        stateLabel.backgroundColor = RGBCOLOR(248, 249, 248, 1);
        stateLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        self.reasonContentLabel.frame = CGRectMake(self.assureLable.frame.origin.x, self.assureLable.frame.origin.y + self.assureLable.frame.size.height + 7, self.assureReasonView.frame.size.width - 30, 14);
        self.assureReasonView.frame = CGRectMake(15, self.sanjiaoImageV.frame.origin.y + self.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + 14);
        self.dateLabel.text = [dataDic objectForKey:@"guaranteeTime"];
        self.navigationItem.rightBarButtonItem = nil;
    }else if (guarantorname.length != 0 && [guarantorname isEqualToString:ACCOUNT_SELF]){
        self.sanjiaoImageV.hidden = NO;
        self.assureReasonView.hidden = NO;
        view.hidden = YES;
        bigV.hidden = YES;
        smallV.hidden = YES;
        stateLabel.hidden = NO;
        stateLabel.text = @"担保成功";
        stateLabel.backgroundColor = RGBCOLOR(197, 197, 197, 1);
        stateLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        CGRect rect = [[dataDic objectForKey:@"guaranteeNote"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
        self.reasonContentLabel.text = [dataDic objectForKey:@"guaranteeNote"];
        self.reasonContentLabel.frame = CGRectMake(self.assureLable.frame.origin.x, self.assureLable.frame.origin.y + self.assureLable.frame.size.height + 7, self.assureReasonView.frame.size.width - 30, rect.size.height);
        self.assureReasonView.frame = CGRectMake(15, self.sanjiaoImageV.frame.origin.y + self.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
        self.dateLabel.text = [dataDic objectForKey:@"guaranteeTime"];
        self.navigationItem.rightBarButtonItem = nil;
    }else if (guarantorname == nil|| [guarantorname isEqualToString:@""] || guarantorname.length == 0){
        stateLabel.hidden = YES;
        self.sanjiaoImageV.hidden = YES;
        self.assureReasonView.hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    return YES;
}

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

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
    }
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.orderID == nil) {
        self.orderID = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"guarantorGetOrder" parameters:@{ACCOUNT_PASSWORD, @"orderId":self.orderID}];
    [loadImg removeFromSuperview];
    loadImg = [[LoadImg alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadImg.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.view addSubview:loadImg];
    [loadImg imgStart];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            dataDic = [dic objectForKey:@"data"];
            [self customInit];
            
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    } andFailureBlock:^{
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    }];
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
