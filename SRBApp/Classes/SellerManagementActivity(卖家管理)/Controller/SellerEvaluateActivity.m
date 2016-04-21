//
//  SellerOrderCommentViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SellerEvaluateActivity.h"
#import <UIImageView+WebCache.h>

@interface SellerEvaluateActivity ()

@end

@implementation SellerEvaluateActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];

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

- (void)makeValueToControl
{
    self.logo.layer.cornerRadius = 20;
    self.logo.layer.masksToBounds = YES;
    self.buyerNameLabel.font = SIZE_FOR_IPHONE;
    self.buyerNameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.goodsTitleLabel.font = SIZE_FOR_12;
    self.goodsDescriptionLabel.font = SIZE_FOR_12;
    self.goodsDescriptionLabel.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    self.priceLabel.font = SIZE_FOR_14;
    self.priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.textview.font = SIZE_FOR_IPHONE;
    self.textview.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    
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
    
    UITapGestureRecognizer * goodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodTap:)];
    UITapGestureRecognizer * middleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(middleTap:)];
    UITapGestureRecognizer * badTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(badTap:)];
    UITapGestureRecognizer * fakeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fakeTap:)];
    [self.goodView addGestureRecognizer:goodTap];
    [self.middleView addGestureRecognizer:middleTap];
    [self.badView addGestureRecognizer:badTap];
    [self.fakeView addGestureRecognizer:fakeTap];

}

- (void)goodTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"1";
    self.goodImg.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    self.middleImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.badImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.fakeImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)middleTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"0";
    self.middleImg.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    self.goodImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.fakeImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.badImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)badTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"-1";
    self.badImg.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    self.goodImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.middleImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.fakeImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

- (void)fakeTap:(UITapGestureRecognizer *)tap
{
    orderGrade = @"-5";
    self.fakeImg.image = [UIImage imageNamed:@"radiobutton_evalute_sected"];
    self.middleImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.badImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
    self.goodImg.image = [UIImage imageNamed:@"radiobutton_evalute"];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
