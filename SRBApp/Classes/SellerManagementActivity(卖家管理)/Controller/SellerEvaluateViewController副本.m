//
//  SellerEvaluateViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerEvaluateViewController.h"
#import <UIImageView+WebCache.h>
#import "CommentView.h"

@interface SellerEvaluateViewController ()<UITextViewDelegate>

@end

@implementation SellerEvaluateViewController
{
    CommentView * goodComment;
    CommentView * middleComment;
    CommentView * badComment;
    CommentView * fakeComment;
    UILabel * saySomeThing;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    [self customInit];
    //控件设置
    [self makeValueToControl];
}

- (void)urlRequest
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderComment" parameters:@{@"account":name,@"password":pass,@"orderId":self.toSellerModel.orderId,@"itemId":self.toSellerModel.itemId,@"grade":@"",@"content":self.textview.text}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        
    }];
}

- (void)customInit
{
    //顶部view
    UIView * topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 120)];
    topBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self.view addSubview:topBGView];
    
    //头像
    UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    logoImg.layer.masksToBounds = YES;
    logoImg.layer.cornerRadius = 20;
    self.logo = logoImg;
    [topBGView addSubview:logoImg];
    
    //姓名
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 5,12,120,16)];
    nameLabel.font = SIZE_FOR_IPHONE;
    nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.buyerNameLabel = nameLabel;
    [topBGView addSubview:nameLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 80,nameLabel.frame.origin.y,80,12)];
    timeLabel.font = SIZE_FOR_12;
    timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.timeLabel = timeLabel;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [topBGView addSubview:timeLabel];
    

    //商品背景
    UIView * goodBGView = [[UIView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 8, SCREEN_WIDTH - 15 - 5 - 15 - 40, 72)];
    goodBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [topBGView addSubview:goodBGView];
    //商品图片
    UIImageView * goodImg = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 60, 60)];
    self.goodsImg = goodImg;
    [goodBGView addSubview:goodImg];
    //商品标题
    UILabel * goodsTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodImg.frame.origin.x + goodImg.frame.size.width + 12,6,goodBGView.frame.size.width - 6 - 12 - 60 - 6,12)];
    goodsTitleLabel.font = SIZE_FOR_12;
    goodsTitleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.goodsTitleLabel = goodsTitleLabel;
    [goodBGView addSubview:goodsTitleLabel];
    
    //商品详情
    MyLabel * goodsDescriptionLabel = [[MyLabel alloc]initWithFrame:CGRectMake(goodsTitleLabel.frame.origin.x,goodsTitleLabel.frame.origin.y + goodsTitleLabel.frame.size.height + 3,goodBGView.frame.size.width - 6 - 12 - 60 - 6,30)];
    goodsDescriptionLabel.font = SIZE_FOR_12;
    goodsDescriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    goodsDescriptionLabel.numberOfLines = 0;
    goodsDescriptionLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [goodsDescriptionLabel setVerticalAlignment:VerticalAlignmentTop];
    self.goodsDescriptionLabel = goodsDescriptionLabel;
    [goodBGView addSubview:goodsDescriptionLabel];
    
    //价格
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsTitleLabel.frame.origin.x,goodsDescriptionLabel.frame.origin.y + goodsDescriptionLabel.frame.size.height + 3,120,14)];
    priceLabel.font = SIZE_FOR_14;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.priceLabel = priceLabel;
    [goodBGView addSubview:priceLabel];
    
    //评价
    UITextView * textview = [[UITextView alloc]initWithFrame:CGRectMake(0, topBGView.frame.origin.y + topBGView.frame.size.height + 20, SCREEN_WIDTH, 100)];
    textview.font = SIZE_FOR_IPHONE;
    textview.delegate = self;
    [self.view addSubview:textview];
    
    saySomeThing = [[UILabel alloc]initWithFrame:CGRectMake(15,12,100,16)];
    saySomeThing.font = SIZE_FOR_IPHONE;
    saySomeThing.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    saySomeThing.text = @"写下点什么吧...";
    [textview addSubview:saySomeThing];
    
    //对TA评分
    UILabel * toHeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,textview.frame.origin.y + textview.frame.size.height + 15,100,14)];
    toHeLabel.font = SIZE_FOR_14;
    toHeLabel.text = @"对TA评分：";
    toHeLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:toHeLabel];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, 60, 25);
    submitBtn.layer.cornerRadius = 2;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    
    
    goodComment = [[CommentView alloc]initWithFrame:CGRectMake(10, self.toHeLabel.frame.size.height + self.toHeLabel.frame.origin.y + 30, 48, 45)];
    middleComment = [[CommentView alloc]initWithFrame:CGRectMake(30, goodComment.frame.origin.y, 48, 45)];
    badComment = [[CommentView alloc]initWithFrame:CGRectMake(100, goodComment.frame.origin.y, 48, 45)];
    fakeComment = [[CommentView alloc]initWithFrame:CGRectMake(150, goodComment.frame.origin.y, 48, 45)];
    goodComment.gradeLabel.text = @"好评";
    middleComment.gradeLabel.text = @"中评";
    badComment.gradeLabel.text = @"差评";
    fakeComment.gradeLabel.text = @"假货";
    
    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected.png"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    
    goodComment.gradeImgview.image = [UIImage imageNamed:@"b_good.png"];
    middleComment.gradeImgview.image = [UIImage imageNamed:@"b_middle.png"];
    badComment.gradeImgview.image = [UIImage imageNamed:@"b_negative.png"];
    fakeComment.gradeImgview.image = [UIImage imageNamed:@"b_fake.png"];
    
    CGPoint goodCenter = goodComment.center;
    goodCenter.x = SCREEN_WIDTH / 4 / 2;
    goodComment.center = goodCenter;
    middleComment.center = CGPointMake(SCREEN_WIDTH/4 + SCREEN_WIDTH /4 / 2, goodCenter.y);
    badComment.center = CGPointMake(SCREEN_WIDTH/4*2 + SCREEN_WIDTH/4/ 2, goodCenter.y);
    fakeComment.center = CGPointMake(SCREEN_WIDTH/4*3 + SCREEN_WIDTH/4/ 2, goodCenter.y);
    
    [self.view addSubview:goodComment];
    [self.view addSubview:middleComment];
    [self.view addSubview:badComment];
    [self.view addSubview:fakeComment];
    
    UITapGestureRecognizer * goodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodTap:)];
    UITapGestureRecognizer * middleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(middleTap:)];
    UITapGestureRecognizer * badTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(badTap:)];
    UITapGestureRecognizer * fakeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fakeTap:)];
    [goodComment.selectImgview addGestureRecognizer:goodTap];
    [middleComment.selectImgview addGestureRecognizer:middleTap];
    [badComment.selectImgview addGestureRecognizer:badTap];
    [fakeComment.selectImgview addGestureRecognizer:fakeTap];
    
    orderGrade = @"1";
}

- (void)makeValueToControl
{
    self.logo.layer.cornerRadius = 20;
    self.logo.layer.masksToBounds = YES;
    self.buyerNameLabel.font = SIZE_FOR_IPHONE;
    self.buyerNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.goodsTitleLabel.font = SIZE_FOR_12;
    self.goodsDescriptionLabel.font = SIZE_FOR_12;
    self.goodsDescriptionLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.priceLabel.font = SIZE_FOR_14;
    self.priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.textview.font = SIZE_FOR_IPHONE;
    self.textview.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    self.topBgView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, 60, 25);
    submitBtn.layer.cornerRadius = 2;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    
    NSDictionary * buyerDic = self.toSellerModel.buyer;
    //设置买家头像
    [self.logo sd_setImageWithURL:[NSURL URLWithString:[buyerDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    //设置买家姓名
    self.buyerNameLabel.text = [NSString stringWithFormat:@"买家：%@",[buyerDic objectForKey:@"nickname"]];
    //设置商品图片
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:self.toSellerModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    //设置商品标题
    self.goodsTitleLabel.text = self.toSellerModel.title;
    //设置商品详情
    self.goodsDescriptionLabel.text = self.toSellerModel.descriptions;
    //设置价格
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.toSellerModel.bangPrice];
    
    goodComment = [[CommentView alloc]initWithFrame:CGRectMake(10, self.toHeLabel.frame.size.height + self.toHeLabel.frame.origin.y + 30, 48, 45)];
    middleComment = [[CommentView alloc]initWithFrame:CGRectMake(30, goodComment.frame.origin.y, 48, 45)];
    badComment = [[CommentView alloc]initWithFrame:CGRectMake(100, goodComment.frame.origin.y, 48, 45)];
    fakeComment = [[CommentView alloc]initWithFrame:CGRectMake(150, goodComment.frame.origin.y, 48, 45)];
    
    goodComment.gradeLabel.text = @"好评";
    middleComment.gradeLabel.text = @"中评";
    badComment.gradeLabel.text = @"差评";
    fakeComment.gradeLabel.text = @"假货";

    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected.png"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute.png"];
    
    goodComment.gradeImgview.image = [UIImage imageNamed:@"b_good.png"];
    middleComment.gradeImgview.image = [UIImage imageNamed:@"b_middle.png"];
    badComment.gradeImgview.image = [UIImage imageNamed:@"b_negative.png"];
    fakeComment.gradeImgview.image = [UIImage imageNamed:@"b_fake.png"];
    
    CGPoint goodCenter = goodComment.center;
    goodCenter.x = SCREEN_WIDTH / 4 / 2;
    goodComment.center = goodCenter;
    middleComment.center = CGPointMake(SCREEN_WIDTH/4 + SCREEN_WIDTH /4 / 2, goodCenter.y);
    badComment.center = CGPointMake(SCREEN_WIDTH/4*2 + SCREEN_WIDTH/4/ 2, goodCenter.y);
    fakeComment.center = CGPointMake(SCREEN_WIDTH/4*3 + SCREEN_WIDTH/4/ 2, goodCenter.y);
    
    [self.view addSubview:goodComment];
    [self.view addSubview:middleComment];
    [self.view addSubview:badComment];
    [self.view addSubview:fakeComment];
    
    
    UITapGestureRecognizer * goodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodTap:)];
    UITapGestureRecognizer * middleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(middleTap:)];
    UITapGestureRecognizer * badTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(badTap:)];
    UITapGestureRecognizer * fakeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fakeTap:)];
    [goodComment.selectImgview addGestureRecognizer:goodTap];
    [middleComment.selectImgview addGestureRecognizer:middleTap];
    [badComment.selectImgview addGestureRecognizer:badTap];
    [fakeComment.selectImgview addGestureRecognizer:fakeTap];
    
    orderGrade = @"1";
}

#pragma mark - 提交按钮
- (void)submit:(UIButton *)submit
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSString * sayStr = [self.textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([sayStr isEqualToString:@""] || sayStr.length == 0) {
        sayStr = @"0";
    }
    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderComment" parameters:@{@"account":name,@"password":pass,@"orderId":self.toSellerModel.orderId,@"itemId":self.toSellerModel.itemId,@"grade":orderGrade,@"content":sayStr}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
        [HUD removeFromSuperview];
    }];
}

#pragma mark - 四种评价对应的方法
- (void)goodTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"1";
    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)middleTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"0";
    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)badTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"-1";
    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)fakeTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"-5";
    goodComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    middleComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    badComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute"];
    fakeComment.selectImgview.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
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
