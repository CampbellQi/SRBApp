//
//  SaleViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SaleViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface SaleViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    UITableView * tableView;
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    UIImageView * imageView4;
    UIImageView * imageView5;
    UIImageView * imageView6;
    UIImageView * imageView7;
    UIButton * imageButton;
    
    UILabel * thingTitle;
    UILabel * thingDetail;
    UITextView * detailTV;
    UITextField * titleTT;
    
    UITextField * thingPrice;
    UITextField * proPrice;
    
    UITextField * howMany;
    
    UIImageView * canPost;
    UIImageView * notPost;
    
    UILabel * positionLB;
    UIImageView * chooseImage;
    
    UILabel * labeltext;
    
    UILabel * labelP;
    
    AVCaptureDevice *device;
    
    NSString * uuid1;
    NSString * uuid2;
    NSString * uuid3;
    NSString * uuid4;
    
    int imageNumber;
    
    NSString * postNumber;
    
    UIView * theView;
    
    NSString * positionsign;
    UIButton * positionbutton;
    
    NSMutableString * myphotos;
    
    UIImageView * imaV1;
    UIImageView * imaV2;
    
}
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSString *detailAddress;//具体地址

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"我要卖";
    myphotos = [NSMutableString stringWithFormat:@""];
    positionsign = @"1";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 55, 25);
    [regBtn setTitle:@"发 布" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.layer.masksToBounds = YES;
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    uuid1 = @"0";
    uuid2 = @"0";
    uuid3 = @"0";
    uuid4 = @"0";
    
    imageNumber = 0;
    positionsign = @"1";
    postNumber = @"1";
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.2);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 667 * 105)];
    [view1 addSubview: [self addPhoto]];
    [_scrollView addSubview:view1];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height + 20, SCREEN_WIDTH, 160)];
    [view2 addSubview:[self detail]];
    [_scrollView addSubview:view2];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, view2.frame.origin.y + view2.frame.size.height + 20, SCREEN_WIDTH, 100)];
    [view3 addSubview:[self price]];
    [_scrollView addSubview:view3];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, view3.frame.origin.y + view3.frame.size.height + 17, 100, 16)];
    [label setTextColor:[GetColor16 hexStringToColor:@"959595"]];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"最终成交价:";
    [_scrollView addSubview:label];
    
    labelP = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 120, view3.frame.origin.y + view3.frame.size.height + 14, 120, 20)];
    labelP.text = @"￥ 0.00";
    labelP.textAlignment = NSTextAlignmentRight;
    labelP.font = [UIFont systemFontOfSize:20];
    [labelP setTextColor:[GetColor16 hexStringToColor:@"#e5005d"]];
    [_scrollView addSubview:labelP];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, view3.frame.origin.y + view3.frame.size.height + 50, SCREEN_WIDTH, 100)];
    [view4 addSubview:[self totalCount]];
    [_scrollView addSubview:view4];
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, view4.frame.origin.y + view4.frame.size.height + 20, SCREEN_WIDTH, 80)];
    [view5 addSubview:[self position]];
    [_scrollView addSubview:view5];
    
//    UIView * smallV = [[UIView alloc]initWithFrame:CGRectMake(60, view5.frame.origin.y + view5.frame.size.height + 10, 16, 16)];
//    smallV.layer.cornerRadius = 16;
//    smallV.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
//    [_scrollView addSubview:smallV];
    
    UIImageView * smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view5.frame.origin.y + view5.frame.size.height + 16, 15, 6)];
    smallV.image = [UIImage imageNamed:@"notice"];
    [_scrollView addSubview:smallV];
    
    UIView * bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 85)];
    bigV.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
    bigV.layer.cornerRadius = 2;
    bigV.layer.masksToBounds = YES;
    [_scrollView addSubview:bigV];
    
    
    
    UILabel * bigL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 14)];
    bigL.text = @"温馨提示:";
    bigL.font = [UIFont systemFontOfSize:14];
    bigV.layer.cornerRadius = 2;
    bigL.textColor = [UIColor whiteColor];
    [bigV addSubview:bigL];
    
    UILabel * smallL = [[UILabel alloc]initWithFrame:CGRectMake(10, bigL.frame.origin.y + bigL.frame.size.height + 8, bigV.frame.size.width - 15, 45)];
    smallL.text = @"如果有熟人为您担保商品, TA的熟人就可以购买您的宝贝了!交易成功后,您的担保人也将会根据TA的指数获得相应的赏金哦~";
    smallL.numberOfLines = 0;
    smallL.textColor = [UIColor whiteColor];
    smallL.font = [UIFont systemFontOfSize:12];
    [bigV addSubview:smallL];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bigV.frame.origin.y + bigV.frame.size.height + 10);
    
    [self.locMgr startUpdatingLocation];

}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [detailTV resignFirstResponder];
    [titleTT resignFirstResponder];
    [thingPrice resignFirstResponder];
    [proPrice resignFirstResponder];
    [howMany resignFirstResponder];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regController:(id)sender
{
    [self post];
}

- (void)timerFired:(id)sender
{
//    labelP.text = [nsstring]
    if ([thingPrice.text intValue] >= 100000) {
        thingPrice.text = [NSString stringWithFormat:@"%d",99999];
    }else if ([proPrice.text intValue] >= 100000) {
        proPrice.text = [NSString stringWithFormat:@"%d", 99999];
    }else  if ([thingPrice.text intValue] < 100000 || [proPrice.text intValue]< 1000000) {
        NSString * str = [NSString stringWithFormat:@"￥ %.2f",([thingPrice.text floatValue] + [proPrice.text floatValue]) * 1.00];
        labelP.text = str;
    }
}

- (void)canpost
{
    [canPost setImage:[UIImage imageNamed:@"radiobutton_evalute_sected.png"]];
    [notPost setImage:[UIImage imageNamed:@"radiobutton_evalute.png"]];
    postNumber = @"1";
}

- (void)cantpost
{
    [canPost setImage:[UIImage imageNamed:@"radiobutton_evalute.png"]];
    [notPost setImage:[UIImage imageNamed:@"radiobutton_evalute_sected.png"]];
    postNumber = @"0";
}

//post请求
- (void)post
{
    if (titleTT.text.length == 0){
        [AutoDismissAlert autoDismissAlert:@"请填写商品名"];
        return;
    }
    if (detailTV.text.length == 0){
        [AutoDismissAlert autoDismissAlert:@"请填写商品详情"];
        return;
    }
    if (thingPrice.text.length == 0){
        [AutoDismissAlert autoDismissAlert:@"请填写宝贝价格"];
        [thingPrice becomeFirstResponder];
        return;
    }
    if (proPrice.text.length == 0){
        [AutoDismissAlert autoDismissAlert:@"请填写担保赏金"];
        [proPrice becomeFirstResponder];
        return;
    }
    if (howMany.text.length == 0){
        [AutoDismissAlert autoDismissAlert:@"请填写宝贝库存"];
        [howMany becomeFirstResponder];
        return;
    }
    if (detailTV.text.length < 20 ||detailTV.text.length > 1600) {
        [AutoDismissAlert autoDismissAlert:@"输入商品详情必须在10-800字"];
        [detailTV becomeFirstResponder];
        return;
    }
    if (titleTT.text.length < 12 ||detailTV.text.length > 60) {
        [AutoDismissAlert autoDismissAlert:@"输入商品标题必须在6-30字"];
        [titleTT becomeFirstResponder];
        return;
    }
    NSString * string = nil;
    if ([myphotos isEqualToString:@""]) {
        string = @"0";
    }else
    {
        [myphotos deleteCharactersInRange:NSMakeRange(0, 1)];
        string = myphotos;
    }
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", self.latitude,self.longitude];
    NSString * position = self.detailAddress;
    if (position.length == 0) {
        positionsign = @"0";
    }
    if ([proPrice.text intValue] < 5) {
        [AutoDismissAlert autoDismissAlert:@"担保赏金不得小于5元"];
        return;
    }
    NSString * price = [NSString stringWithFormat:@"%d",[thingPrice.text intValue] + [proPrice.text intValue]];
    
    if ([positionsign isEqualToString:@"1"]) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"1", @"originalPrice":thingPrice.text, @"marketPrice":price, @"transportPrice":@"0", @"freeShipment":postNumber, @"xyz":xyz, @"position":position, @"city":@"", @"positionView":@"1", @"photos":string, @"title":titleTT.text, @"content":detailTV.text, @"storage":howMany.text, @"guaranteeAllow":@"0", @"guaranteePrice":proPrice.text, @"uuid":@"0", @"categoryID":_categoryID }];
        
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                //NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                [AutoDismissAlert autoDismissAlert:@"发布成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
//                MyPublishActivityViewController * vc = [[MyPublishActivityViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"%d", result);
                NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                [AutoDismissAlert autoDismissAlert:@"请求失败"];
                //            imageview.center = tableView2.center;
            }
        }];
    }else {
        NSDictionary * dic = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"1", @"originalPrice":thingPrice.text, @"marketPrice":price, @"transportPrice":@"0", @"freeShipment":postNumber, @"xyz":@"0", @"position":@"0", @"city":@"0", @"positionView":@"0", @"photos":myphotos, @"title":titleTT.text, @"content":detailTV.text, @"storage":howMany.text, @"guaranteeAllow":@"0", @"guaranteePrice":proPrice.text, @"uuid":@"0", @"categoryID":_categoryID }];
        
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                //NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                [AutoDismissAlert autoDismissAlert:@"发布成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSLog(@"%d", result);
                NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                [AutoDismissAlert autoDismissAlert:@"请求失败"];
                //            imageview.center = tableView2.center;
            }
        }];
    }
    
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}


- (UIView *)position
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, 40, 16)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"位置";
    [view addSubview:label];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 3, label.frame.origin.y, 11, 16)];
    imageV.image = [UIImage imageNamed:@"fb_wz.png"];
    [view addSubview:imageV];
    
    theView = [[UIView alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, 12, 150 * SCREEN_WIDTH / 375, 56)];
    CALayer *layer=[theView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:6];
    //设置边框线的宽
    [layer setBorderWidth:1];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor colorWithRed:0.94 green:0.63 blue:0.71 alpha:1] CGColor]];
    [view addSubview:theView];
    
    chooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(theView.frame.size.width - 14 * SCREEN_WIDTH / 375 - 5, 4, 10, 10)];
    chooseImage.image = [UIImage imageNamed: @"location_selected.png"];
    [theView addSubview:chooseImage];
    
    positionLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120 * SCREEN_WIDTH / 375, 46)];
//    positionLB.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"localDic"] objectForKey:@"detailAddress"];
    positionLB.font = [UIFont systemFontOfSize:12];
    positionLB.numberOfLines = 0;
    [theView addSubview:positionLB];
    
    UIButton * button = [[UIButton alloc]initWithFrame:theView.frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(lookPosition) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView * smallView = [[UIView alloc]initWithFrame:CGRectMake(theView.frame.origin.x + theView.frame.size.width + 8, 36, 12  * SCREEN_WIDTH / 375, 12)];
    smallView.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
    smallView.layer.cornerRadius = 12;
    [view addSubview:smallView];
    
    positionbutton = [[UIButton alloc]initWithFrame:CGRectMake(smallView.frame.origin.x + smallView.frame.size.width / 2 , 26, 95 * SCREEN_WIDTH / 375, 30)];
    positionbutton.backgroundColor = [UIColor colorWithRed:1 green:0.47 blue:0.67 alpha:1];
    [positionbutton setTitle:@"点击隐藏位置" forState:UIControlStateNormal];
    [positionbutton addTarget:self action:@selector(lookPosition) forControlEvents:UIControlEventTouchUpInside];
    positionbutton.layer.masksToBounds = YES;
    positionbutton.layer.cornerRadius = 2;
    positionbutton.titleLabel.font = [UIFont systemFontOfSize:12];
    [positionbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:positionbutton];
    
    
    return view;
}

- (void)lookPosition
{
    if ([positionsign isEqualToString:@"0"]) {
        CALayer *layer=[theView layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:10.0];
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:[[UIColor colorWithRed:0.94 green:0.63 blue:0.71 alpha:1] CGColor]];
        positionsign = @"1";
        [positionbutton setTitle:@"点击隐藏位置" forState:UIControlStateNormal];
        chooseImage.image = [UIImage imageNamed: @"location_selected.png"];
    }
    else{
        CALayer *layer=[theView layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:10.0];
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
        positionsign = @"0";
        [positionbutton setTitle:@"点击添加位置" forState:UIControlStateNormal];
        chooseImage.image = [UIImage imageNamed: @"ad_dui.png"];
    }
}

- (UIView *)totalCount
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 70, 16)];
    label1.text = @"宝贝库存";
    label1.font = [UIFont systemFontOfSize:16];
    [view addSubview:label1];
    
    UILabel * label11 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 5, 5, 1, 40)];
    label11.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label11];
    
//    UIImageView * imgV1 = [[UIImageView alloc]initWithFrame:CGRectMake(label11.frame.origin.x + label11.frame.size.width + 5, label1.frame.origin.y - 5, 30, 30)];
//    [imgV1 setImage:[UIImage imageNamed:@"prs_uclk.png"]];
//    [view addSubview:imgV1];
    
    howMany = [[UITextField alloc]initWithFrame:CGRectMake(label11.frame.origin.x + label11.frame.size.width + 5, label1.frame.origin.y - 5, 180, 30)];
    howMany.delegate = self;
    howMany.placeholder = @"有多少宝贝?";
    [howMany setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    howMany.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:howMany];
    
    UILabel * yuanLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31, label1.frame.origin.y, 16, 16)];
    yuanLabel1.text = @"件";
    [yuanLabel1 setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [view addSubview:yuanLabel1];
    
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, label11.frame.origin.y + label11.frame.size.height + 5, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [view addSubview:breakView];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, label11.frame.origin.y + label11.frame.size.height + 20, 70, 16)];
    label2.text = @"是否包邮";
    label2.font = [UIFont systemFontOfSize:16];
    [view addSubview:label2];
    
    UILabel * label22 = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 5, label11.frame.origin.y + label11.frame.size.height + 10, 1, 40)];
    label22.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label22];
    
    canPost = [[UIImageView alloc]initWithFrame:CGRectMake(label22.frame.origin.x + label22.frame.size.width + 5, label2.frame.origin.y - 5, 16, 20)];
    [canPost setImage:[UIImage imageNamed:@"radiobutton_evalute_sected.png"]];
    [view addSubview:canPost];
    
    UIButton * canPostButton = [[UIButton alloc]initWithFrame:CGRectMake(canPost.frame.origin.x + canPost.frame.size.width + 5, label2.frame.origin.y, 80, 16)];
    [canPostButton setTitle:@"我能包邮" forState:UIControlStateNormal];
    [canPostButton addTarget:self action:@selector(canpost) forControlEvents:UIControlEventTouchUpInside];
    [canPostButton setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view addSubview:canPostButton];
    
    notPost = [[UIImageView alloc]initWithFrame:CGRectMake(canPostButton.frame.origin.x + canPostButton.frame.size.width + 5, canPost.frame.origin.y, 16, 20)];
    [notPost setImage:[UIImage imageNamed:@"radiobutton_evalute.png"]];
    [view addSubview:notPost];
    
    UIButton * notPostButton = [[UIButton alloc]initWithFrame:CGRectMake(notPost.frame.origin.x + notPost.frame.size.width + 5, canPostButton.frame.origin.y, 80, 16)];
    [notPostButton setTitle:@"邮费另算" forState:UIControlStateNormal];
    [notPostButton addTarget:self action:@selector(cantpost) forControlEvents:UIControlEventTouchUpInside];
    [notPostButton setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view addSubview:notPostButton];
    
    return view;
}

- (UIView *)price
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 70, 16)];
    label1.text = @"宝贝价格";
    label1.font = [UIFont systemFontOfSize:16];
    [view addSubview:label1];
    
    UILabel * label11 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 5, 5, 1, 40)];
    label11.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label11];
    
    imaV1 = [[UIImageView alloc]initWithFrame:CGRectMake(label11.frame.origin.x + label11.frame.size.width + 5, label1.frame.origin.y , 18, 20)];
    [imaV1 setImage:[UIImage imageNamed:@"prs_uclk.png"]];
    [view addSubview:imaV1];
    
    thingPrice = [[UITextField alloc]initWithFrame:CGRectMake(imaV1.frame.origin.x + imaV1.frame.size.width + 5, label1.frame.origin.y - 7, 180, 30)];
    thingPrice.delegate = self;
    thingPrice.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    thingPrice.placeholder = @"请输入宝贝的价格";
    [thingPrice setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:thingPrice];
    
    UILabel * yuanLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31, label1.frame.origin.y, 16, 16)];
    yuanLabel1.text = @"元";
    [yuanLabel1 setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [view addSubview:yuanLabel1];
    
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, label11.frame.origin.y + label11.frame.size.height + 5, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [view addSubview:breakView];
    
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, label11.frame.origin.y + label11.frame.size.height + 20, 70, 16)];
    label2.text = @"担保赏金";
    label2.font = [UIFont systemFontOfSize:16];
    [view addSubview:label2];
    
    UILabel * label22 = [[UILabel alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 5, label11.frame.origin.y + label11.frame.size.height + 10, 1, 40)];
    label22.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label22];
    
    imaV2 = [[UIImageView alloc]initWithFrame:CGRectMake(label22.frame.origin.x + label22.frame.size.width + 5, label2.frame.origin.y , 18, 20)];
    [imaV2 setImage:[UIImage imageNamed:@"esr_uclk.png"]];
    [view addSubview:imaV2];
    
    proPrice = [[UITextField alloc]initWithFrame:CGRectMake(imaV2.frame.origin.x + imaV2.frame.size.width + 5, label2.frame.origin.y - 7, 180, 30)];
    proPrice.delegate = self;
    proPrice.placeholder = @"请输入担保赏金";
    [proPrice setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    proPrice.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [view addSubview:proPrice];
    
    UILabel * yuanLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31, label2.frame.origin.y, 16, 16)];
    yuanLabel2.text = @"元";
    [yuanLabel2 setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [view addSubview:yuanLabel2];
    
    return view;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (textField == thingPrice) {
            UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"prs_uclk.png"]];
            imaV1.image = image.image;
        }if (textField == proPrice) {
            imaV2.image = [UIImage imageNamed:@"esr_uclk.png"];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:thingPrice]) {
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"prs_clk"]];
        imaV1.image = image.image;
    }if (textField == proPrice) {
        imaV2.image = [UIImage imageNamed:@"esr_clk"];
    }
}

- (UIView *)detail
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView * breakView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    breakView1.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [view addSubview:breakView1];
    
    thingTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, breakView1.frame.origin.y + breakView1.frame.size.height + 20, 70, 16)];
    thingTitle.text = @"商品标题";
    thingTitle.font = [UIFont systemFontOfSize:16];
    [view addSubview:thingTitle];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(thingTitle.frame.origin.x + thingTitle.frame.size.width + 5,  breakView1.frame.origin.y + breakView1.frame.size.height +5, 1, 40)];
    label.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label];
    
    titleTT = [[UITextField alloc]initWithFrame:CGRectMake(label.frame.origin.x + 10, thingTitle.frame.origin.y - 5, SCREEN_WIDTH -label.frame.origin.x - 15, 30)];
    titleTT.delegate = self;
    [titleTT setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
    titleTT.placeholder = @"6-30字,建议填写商品品牌和名称";
    [titleTT setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:titleTT];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height + 5, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [view addSubview:breakView];
    
    thingDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, breakView1.frame.origin.y + breakView1.frame.size.height +70, 70, 16)];
    thingDetail.text = @"商品详情";
    thingDetail.font = [UIFont systemFontOfSize:16];
    [view addSubview:thingDetail];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(thingDetail.frame.origin.x + thingDetail.frame.size.width + 5, label.frame.origin.y + label.frame.size.height + 10, 1, 80)];
    label1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label1];
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(label.frame.origin.x + 5, thingDetail.frame.origin.y - 10 , titleTT.frame.size.width, 70)];
    //detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色
    detailTV.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
    //        self.textView.delegate = self;//设置它的委托方法
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    //        self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容
    detailTV.returnKeyType = UIReturnKeyDefault;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    detailTV.scrollEnabled = YES;//是否可以拖动
    detailTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [view addSubview: detailTV];//加入到整个页面中
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x + 8, thingDetail.frame.origin.y , SCREEN_WIDTH, 14)];
    labeltext.text = @"10-800字, 介绍一下具体情况";
    labeltext.font = [UIFont systemFontOfSize:14];
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [view addSubview:labeltext];
    
    return view;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (thingDetail.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            labeltext.hidden=NO;//隐藏文字
        }else{
            labeltext.hidden=YES;
        }
    }
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        
        
        return NO;
        
        return YES;
    } else{//textview长度不为0
        if (thingDetail.text.length==1){//textview长度为1时候
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

- (UIView *)addPhoto
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WIDTH * 105)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WIDTH * 105)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 1.75, WIDTH * 105);
    [view addSubview:scrollView];
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    [imageView1 setImage:[UIImage imageNamed:@"fb_xj.png"]];
    imageView1.center = CGPointMake(15 + 37.5 * SCREEN_HEIGHT / 667, view.frame.size.height / 2);
    imageView1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView1];
    
    imageButton = [[UIButton alloc]init];
    imageButton.frame = imageView1.frame;
    [imageButton addTarget:self action:@selector(cameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:imageButton];

    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
//    [imageView2 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView2.center = CGPointMake(30 + (75 +  37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
//    [imageView3 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView3.center = CGPointMake(15 * 3 + (75 * 2 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView3.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView3];
    
    imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
//    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView4.center = CGPointMake(15 * 4 + (75 * 3 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView4.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView4];
    
    imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView5.center = CGPointMake(15 * 5 + (75 * 4 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView5.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView5];
    
    imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView6.center = CGPointMake(15 * 6 + (75 * 5 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView6.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView6];
    
    imageView7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView7.center = CGPointMake(15 * 7 + (75 * 6 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView7.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:imageView7];
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------ 调用系统相机 ------
- (void)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相机" otherButtonTitles:@"图片库",@"闪光灯", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"打开系统照相机");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                picker.allowsEditing = YES;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"哎呀，当前设备没有摄像头。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            NSLog(@"打开系统图片库");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                picker.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"e5005d"];
                picker.delegate = self;
                picker.allowsEditing = YES;//是否可以对原图进行编辑
                
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"图片库不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 2:
        {
            NSLog(@"调用系统闪关灯");
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; // 返回用于捕获视频数据的设备（摄像头）
                if (![device hasTorch]) {
                    NSLog(@"没有闪光灯");
                }else{
                    [device lockForConfiguration:nil]; // 请求独占设备的硬件性能
                    if (device.torchMode == AVCaptureTorchModeOff) {
                        [device setTorchMode: AVCaptureTorchModeOn]; // 打开闪光灯
                    }
                }
            }
            else
            {
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"哎呀，当前设备没有摄像头。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
            break;
        }
        case 3:
        {
            NSLog(@"取消");
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
//        [self uploadPictureWithImageData:[self saveImageAndReturn:image WithName:uuid1]];
//        imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"上传中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        if (imageNumber == 0) {
            uuid1 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView2.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView2.frame;
        }
        if (imageNumber == 1) {
            uuid2 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView2.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView3.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView3.frame;
        }
        if (imageNumber == 2) {
            uuid3 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView3.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView4.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView4.frame;
        }
        if (imageNumber == 3) {
            uuid4 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageButton.frame = CGRectMake(SCREEN_WIDTH, 0, 1,1 );
//            imageView2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        }
        imageNumber += 1;
        
    }else{
        
//        [self uploadPictureWithImageData:[self saveImageAndReturn:image WithName:uuid1]];
//        imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"上传中,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        if (imageNumber == 0) {
            uuid1 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView2.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView2.frame;
        }
        if (imageNumber == 1) {
            uuid2 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView2.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView3.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView3.frame;
        }
        if (imageNumber == 2) {
            uuid3 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView3.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView4.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView4.frame;
        }
        if (imageNumber == 3) {
            uuid4 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.4)];
            imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageButton.frame = CGRectMake(SCREEN_WIDTH, 0, 1, 1);
            //            imageView2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        }
        imageNumber += 1;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}

//#pragma mark - post请求
//- (void)postFacePic:(NSString *)str
//{
//    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
//    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
//    //    NSString * str1 = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    //拼接post参数
//    NSDictionary * dic = [self parametersForDic:@"accountSetUserPic" parameters:@{@"account":name, @"password":password, @"url":str, @"uuid":@"0"}];
//    //发送post请求
//    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSLog(@"%@",[dic objectForKey:@"message"]);
//        int result = [[dic objectForKey:@"result"]intValue];
//        if (result == 0) {
//            [AutoDismissAlert autoDismissAlert:@"上传成功"];
//            
//        }else{
//            NSLog(@"%d", result);
//            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"上传失败"];
//        }
//    }];
//}

-(void)uploadPictureWithImageData:(NSData *)imageData{
    
    NSString *url = @"http://mapi.shurenbang.net/servlet/JJUploadImageServlet";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"],@"accessToken", @"ddd.png", @"uploadFileName",nil];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", uuid1] mimeType:@"image/*"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        NSString * str = [dic objectForKey:@"msg"];
        //        NSString * str1 = [str substringWithRange:NSMakeRange(48, 36)];
        NSLog(@"%@",str);
        NSLog(@"message: %@", [dic objectForKey:@"message"]);
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:str];
        [String1 insertString:@"," atIndex:0];
        NSString * string2 = [[NSString alloc]initWithString:String1];
        [myphotos appendString:string2];
        [HUD removeFromSuperview];
        [AutoDismissAlert autoDismissAlert:@"上传成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [AutoDismissAlert autoDismissAlert:@"上传失败"];
    }];
}

#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (NSData *)saveImageAndReturn:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return imageData;
}


#pragma mark - 压缩方法
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - 生成UUID
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (CLLocationManager *)locMgr
{
    // 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            [self.locMgr requestAlwaysAuthorization];
        }
    }
    return _locMgr;
    
}
#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"didUpdateLocations------%f %f", coordinate.latitude, coordinate.longitude);
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                         
                         self.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         self.longitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         self.city = [dict objectForKey:@"State"];
                         NSString *SubLocality = [dict objectForKey:@"SubLocality"];
                         NSString *Street = [dict objectForKey:@"Street"];
                         if (Street == nil) {
                             Street = @"";
                         }
                         NSString *address = [self.city stringByAppendingString:SubLocality];
                         self.detailAddress = [address stringByAppendingString:Street];
                         positionLB.text = self.detailAddress;
                         NSLog(@"street address: %@",self.detailAddress);
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
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
