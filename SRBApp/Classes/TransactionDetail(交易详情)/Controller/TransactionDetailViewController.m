//
//  TransactionDetailViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "TransactionReceiveViewController.h"
#import "SGActionView.h"
#import "DetailModel.h"
#import <UIImageView+WebCache.h>
#import "DanBaoRenModel.h"
#import "CommonFriendViewController.h"
#import "OrderViewController.h"
#import "MyLabel.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "CYCustomMultiSelectPickerView.h"
#import "ChooseDanbaoViewController.h"
#import "TransactionDetail.h"
#import "SubZZMyOrderViewController.h"
#import "DetailActivityBtn.h"
#import "BussinessModel.h"

@interface TransactionDetailViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate,UIActionSheetDelegate,CYCustomMultiSelectPickerViewDelegate>

@end

@implementation TransactionDetailViewController
{
    UITableView * tableview;
    DetailModel * detailModel;
    NSDictionary * getDic;      //收货地址字典
    UILabel * phoneLabel;       //联系电话
    UILabel * receivePerLabel;  //收货人
    MyLabel * receiveAddLabel;  //收货地址
    MyImgView * addressDetailImg;
    UILabel * sellerLabel;      //卖家
    UIImageView * goodsImg;          //商品图片
    MyLabel * goodsLabel;       //商品名称
    UILabel * priceLabel;       //商品价格
    UILabel * timeLabel;        //日期
    
    UIView * toolView;          //最下方view
    
    UILabel * totalPrice;       //总价
    UITextField * goodsNumText; //购买数量
    UILabel * postMethodLabel;  //配送方式
    UITextField * toSellerText;  //对卖家留言
    int num;                    //购买数量
    UILabel * danbaorenLabel;   //担保人
    UIButton * submitBtn;       //提交按钮
    UIView * danbaoLineView;
    UIView * danbaoView;
    NSMutableArray * danbaorenArr;
    NSMutableArray * shurenArr;
    NSMutableArray * chooseShurenArr;
    
    UILabel * danbaoNameLabel;  //担保人
    UILabel * danbaoPriceLabel; //担保价格
    NSString * danbaorenID;     //担保人ID
    
    UIView * numBGView;         //购买数量等背景
    UILabel * postPriceLabel;   //邮费
    
    UIScrollView * mainScroll;
    
    NSString * tempPrice;
    NSString * tempTotalPrice;
    UITextView * textViews;
    UILabel * labeltext;
    
    UIView * addressBGView;     //1
    UIView * sellerBGView;      //2
    UIView * sellerSayBGView;
    
    int prewTag;
    float prewMoveY;
    int goodsNums;
    
    MyImgView * noReceiveImg;   //无收货地址
    MyLabel * selectLabel;      //无收货地址提示
    UILabel * tempLabel;
    BOOL _canedit;
    
    CYCustomMultiSelectPickerView * multiPickerView;
    
    UIImageView * danbaoDownImg;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易下单";
    [self customInit];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)backBtn:(UIButton *)sender
{
    [danbaorenArr addObject:@"0"];
//    [operations cancel];
//    [manager.operationQueue cancelAllOperations];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textString = textField.text;
    NSUInteger length = [textString length];
    
    BOOL bChange =YES;
    if (length >= 4)
        bChange = NO;
    
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}

#pragma mark - 控件初始化
- (void)customInit
{
    goodsNums = [self.goodsNum intValue];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    getDic = [NSDictionary dictionary];
    danbaorenArr = [NSMutableArray array];
    shurenArr = [NSMutableArray array];
    chooseShurenArr = [NSMutableArray array];
    danbaorenID = [NSString string];
    num = 1;
    
    mainScroll = [[UIScrollView alloc]init];
    mainScroll.delegate = self;
    mainScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 42);
    [self.view addSubview:mainScroll];
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, 555);
    mainScroll.delaysContentTouches = NO;
//===========================收货地址背景=========================================
    addressBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94)];
    addressBGView.backgroundColor = [GetColor16 hexStringToColor:@"#909eb3"];
    [mainScroll addSubview:addressBGView];
    
    UITapGestureRecognizer * selectAddTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddTap:)];
    [addressBGView addGestureRecognizer:selectAddTap];
    
    //receivePerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 40 - 15, 18)];
    receivePerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 90, 21)];
    receivePerLabel.font = [UIFont systemFontOfSize:18];
    receivePerLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [addressBGView addSubview:receivePerLabel];
    
//    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, receivePerLabel.frame.size.height + receivePerLabel.frame.origin.y + 12, SCREEN_WIDTH - 40- 15, 14)];
    phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 18, SCREEN_WIDTH - 30 - 100, 14)];
    phoneLabel.font = SIZE_FOR_14;
    phoneLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [addressBGView addSubview:phoneLabel];
    
//    tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 12, 75, 14)];
//    tempLabel.font = SIZE_FOR_14;
//    tempLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    tempLabel.text = @"收货地址:";
//    [addressBGView addSubview:tempLabel];
    
//    receiveAddLabel = [[MyLabel alloc]initWithFrame:CGRectMake(85, phoneLabel.frame.size.height + phoneLabel.frame.origin.y + 12, SCREEN_WIDTH - 40- 75, 16)];
    receiveAddLabel = [[MyLabel alloc]initWithFrame:CGRectMake(15, receivePerLabel.frame.size.height + receivePerLabel.frame.origin.y + 15, SCREEN_WIDTH - 25 - 15, 16)];
    receiveAddLabel.font = SIZE_FOR_14;
    receiveAddLabel.numberOfLines = 0;
    receiveAddLabel.textAlignment = NSTextAlignmentLeft;
    //receiveAddLabel.verticalAlignment = VerticalAlignmentTop;
    receiveAddLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [addressBGView addSubview:receiveAddLabel];
    
    addressDetailImg = [[MyImgView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 12, (addressBGView.frame.size.height - 24.5)/2, 12, 24.5)];
    addressDetailImg.image = [UIImage imageNamed:@"detail_address_jt"];
    
    noReceiveImg = [[MyImgView alloc]initWithFrame:CGRectMake(25, 14, 27, 22.5)];
    noReceiveImg.hidden = YES;
    noReceiveImg.image = [UIImage imageNamed:@"address"];
    [addressBGView addSubview:noReceiveImg];
    
    selectLabel = [[MyLabel alloc]initWithFrame:CGRectMake(62, 16.5, 100, 17)];
    selectLabel.hidden = YES;
    selectLabel.text = @"请选择收货地址";
    selectLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    selectLabel.font = SIZE_FOR_14;
    [addressBGView addSubview:selectLabel];
    
    
    [addressBGView addSubview:addressDetailImg];
//==============================================================================
    
//===========================卖家以及商品=========================================
    sellerBGView = [[UIView alloc]initWithFrame:CGRectMake(0, addressBGView.frame.size.height + addressBGView.frame.origin.y+15, SCREEN_WIDTH, 121)];
    sellerBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:sellerBGView];
    
    sellerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 6, 200, 17)];
    sellerLabel.font = SIZE_FOR_14;
    sellerLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [sellerBGView addSubview:sellerLabel];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sellerLabel.frame.size.height + sellerLabel.frame.origin.y + 8, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [sellerBGView addSubview:lineView];
    
    goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, lineView.frame.size.height + lineView.frame.origin.y + 15, 60, 60)];
    [sellerBGView addSubview:goodsImg];
    
    goodsLabel = [[MyLabel alloc]initWithFrame:CGRectMake(goodsImg.frame.size.width+goodsImg.frame.origin.x + 12, goodsImg.frame.origin.y, SCREEN_WIDTH - 15 - 60 - 12 - 15, 17)];
    goodsLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    goodsLabel.verticalAlignment = VerticalAlignmentTop;
    goodsLabel.font = SIZE_FOR_14;
    [sellerBGView addSubview:goodsLabel];
    
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.frame.origin.x, goodsLabel.frame.size.height+goodsLabel.frame.origin.y + 8, 100, 14)];
    priceLabel.font = SIZE_FOR_14;
    priceLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [sellerBGView addSubview:priceLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsLabel.frame.origin.x, goodsImg.frame.size.height+goodsImg.frame.origin.y - 12,100, 14)];
    timeLabel.font = SIZE_FOR_12;
    timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    //[sellerBGView addSubview:timeLabel];
    
//==============================================================================

//===========================卖家以及商品=========================================
    numBGView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sellerBGView.frame) + 15, SCREEN_WIDTH, 122)];
    numBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:numBGView];
    
    UILabel * yunfeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 60, 14)];
    yunfeiLabel.text = @"运费";
    yunfeiLabel.font = SIZE_FOR_14;
    [numBGView addSubview:yunfeiLabel];
    
    postPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 15, 100, 14)];
    postPriceLabel.font = SIZE_FOR_12;
    postPriceLabel.textAlignment = NSTextAlignmentRight;
    postPriceLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [numBGView addSubview:postPriceLabel];
    
    UIView * yunfeiLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    yunfeiLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [numBGView addSubview:yunfeiLineView];
    
    UILabel * buyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(yunfeiLineView.frame) + 13, 60, 14)];
    buyNumLabel.font = SIZE_FOR_14;
    buyNumLabel.text = @"购买数量";
    [numBGView addSubview:buyNumLabel];
    
    UIButton * jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jianBtn.frame = CGRectMake(SCREEN_WIDTH - 115, 41, 35, 35);
    [jianBtn addTarget:self action:@selector(jianBtn:) forControlEvents:UIControlEventTouchDown];
    [jianBtn setImage:[UIImage imageNamed:@"jy_jians"] forState:UIControlStateNormal];
    [jianBtn setImage:[UIImage imageNamed:@"jy_jian"] forState:UIControlStateHighlighted];
    [numBGView addSubview:jianBtn];
    
    goodsNumText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jianBtn.frame) + 2, jianBtn.frame.origin.y+10,35, 14)];
    goodsNumText.font = SIZE_FOR_14;
    goodsNumText.delegate = self;
    goodsNumText.enabled = NO;
    goodsNumText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [goodsNumText addTarget:self action:@selector(totalPriceChange:) forControlEvents:UIControlEventEditingChanged];
    goodsNumText.text = [NSString stringWithFormat:@"%d",num];
    goodsNumText.textAlignment = NSTextAlignmentCenter;
    [numBGView addSubview:goodsNumText];
    
    UIButton * jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jiaBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 41, 35, 35);
    [jiaBtn addTarget:self action:@selector(jiaBtn:) forControlEvents:UIControlEventTouchDown];
    [jiaBtn setImage:[UIImage imageNamed:@"jy_jias"] forState:UIControlStateNormal];
    [jiaBtn setImage:[UIImage imageNamed:@"jy_jia"] forState:UIControlStateHighlighted];
    [numBGView addSubview:jiaBtn];
    
    UIView * buyNumLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    buyNumLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [numBGView addSubview:buyNumLineView];
    
    UILabel * postLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(buyNumLineView.frame) + 13, 60, 14)];
    postLabel.font = SIZE_FOR_14;
    postLabel.text = @"配送方式";
    [numBGView addSubview:postLabel];
    
    UIView * postMethodView = [[UIView alloc]initWithFrame:CGRectMake(0, buyNumLineView.frame.origin.y+buyNumLineView.frame.size.height, SCREEN_WIDTH, 40)];
    [numBGView addSubview:postMethodView];
    
    UITapGestureRecognizer * postMethodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPostMethod:)];
    [postMethodView addGestureRecognizer:postMethodTap];
    
    UIImageView * downImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9, 18, 9, 4)];
    downImg.image = [UIImage imageNamed:@"bg_spinner"];
    [postMethodView addSubview:downImg];
    
    postMethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9 - 25 - 15, 14, 25, 12)];
    postMethodLabel.text = @"选择";
    postMethodLabel.font = SIZE_FOR_12;
    postMethodLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [postMethodView addSubview:postMethodLabel];
    
    UIView * methodLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 1)];
    methodLineView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    //[numBGView addSubview:methodLineView];
    
    if ([self.danbaoNum integerValue] > 0) {
        danbaorenLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, methodLineView.frame.size.height + methodLineView.frame.origin.y + 13, 60, 14)];
        danbaorenLabel.text = @"担保人";
    }else{
        danbaorenLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, methodLineView.frame.size.height + methodLineView.frame.origin.y + 13, 100, 14)];
        danbaorenLabel.text = @"邀请担保人";
    }
    danbaorenLabel.font = SIZE_FOR_14;
    danbaorenLabel.hidden = YES;
    //[numBGView addSubview:danbaorenLabel];
    
    danbaoView = [[UIView alloc]initWithFrame:CGRectMake(0, methodLineView.frame.size.height + methodLineView.frame.origin.y, SCREEN_WIDTH, 40)];
    //[numBGView addSubview:danbaoView];
    
    danbaoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9 - 15 - 150, 13, 150, 14)];
    danbaoNameLabel.textAlignment = NSTextAlignmentRight;
    danbaoNameLabel.font = SIZE_FOR_12;
    danbaoNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    danbaoNameLabel.text = @"选择";
    
//    danbaoPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(danbaoView.frame.size.width - 20.5 - 10 - 10 - 60, 14, 60, 12)];
//    danbaoPriceLabel.text = @"0.00";
//    danbaoPriceLabel.textAlignment = NSTextAlignmentRight;
//    danbaoPriceLabel.font = SIZE_FOR_12;
    
    danbaoDownImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9, 18, 9, 4)];
    danbaoDownImg.image = [UIImage imageNamed:@"bg_spinner"];
    
    danbaoView.hidden = YES;
    [danbaoView addSubview:danbaoNameLabel];
    [danbaoView addSubview:danbaoPriceLabel];
    [danbaoView addSubview:danbaoDownImg];

    UITapGestureRecognizer * danbaoClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(danbaoClick:)];
    [danbaoView addGestureRecognizer:danbaoClick];
    
//    toSellerText = [[UITextField alloc]initWithFrame:CGRectMake(0, numBGView.frame.size.height + numBGView.frame.origin.y+15, SCREEN_WIDTH, 30)];
    
    sellerSayBGView = [[UIView alloc]initWithFrame:CGRectMake(0, numBGView.frame.size.height + numBGView.frame.origin.y + 15, SCREEN_WIDTH, 60)];
    sellerSayBGView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [mainScroll addSubview:sellerSayBGView];
    
    textViews = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 60)];
    textViews.font = SIZE_FOR_14;
    textViews.autocorrectionType = UITextAutocorrectionTypeNo;
    textViews.delegate = self;
    textViews.returnKeyType = UIReturnKeyDone;
    textViews.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色
//    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
//    finishiView1.buttonFinish.tag = 1;
//    finishiView1.buttonBack.tag = 1;
//    finishiView1.buttonNext.tag = 1;
//    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
//    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    [finishiView1.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
//    textViews.inputAccessoryView = finishiView1;
    
    [sellerSayBGView addSubview: textViews];//加入到整个页面中
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH, 14)];
    labeltext.text = @"我要说点什么";
    labeltext.font = SIZE_FOR_14;
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [textViews addSubview:labeltext];
    
    toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 42 - 64, SCREEN_WIDTH, 42)];
    toolView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    toolView.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    toolView.layer.shadowOpacity = 0.6;
    toolView.layer.shadowOffset = CGSizeMake(3, -1);
    [self.view addSubview:toolView];
    
    totalPrice = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH - 15 - 100, 20)];
    totalPrice.font = SIZE_FOR_IPHONE;
    totalPrice.textAlignment = NSTextAlignmentLeft;
    totalPrice.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [toolView addSubview:totalPrice];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 42);
    //submitBtn.titleLabel.font = SetFont(TitleFont);
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [submitBtn setTitle:@"确定下单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    [toolView addSubview:submitBtn];
    
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    [self getAddressUrlRequest];
}

- (void)selectAddTap:(UITapGestureRecognizer *)selectAdd
{
    TransactionReceiveViewController * receiveVC = [[TransactionReceiveViewController alloc]init];
    receiveVC.transactionVC = self;
    [self.view endEditing:YES];
    [self.navigationController pushViewController:receiveVC animated:YES];
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
        [textViews resignFirstResponder];
    }
}

#pragma mark - 监听验证码输入框键盘
- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;//view的x轴上移
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
    }
    
    NSString * toBeString = textView.text;
    
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textView markedTextRange];
        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 50) {
            _canedit = NO;
        }
        if (!position) {
            if (toBeString.length > 100) {
                textView.text = [toBeString substringToIndex:100];
                _canedit = YES;
            }
        }
    }
    else{
        NSLog(@"%lu",toBeString.length);
        if (toBeString.length > 100) {
            textView.text = [toBeString substringToIndex:100];
            _canedit = NO;
        }
    }
}

#pragma mark view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘弹出与收回的通知
- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGRect textViewsRect = [textViews.superview convertRect:textViews.frame toView:self.view];
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CGRect tempViewRect = mainScroll.frame;
    if ([textViews isFirstResponder]) {
        if ((textViewsRect.size.height + textViewsRect.origin.y) > keyboardRect.origin.y) {
            tempViewRect.origin.y -= (textViewsRect.size.height + textViewsRect.origin.y) - keyboardRect.origin.y;
        }
    }
    mainScroll.frame = tempViewRect;
    
    // commit animations
    [UIView commitAnimations];

}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    mainScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 42);
    // commit animations
    [UIView commitAnimations];
}

#pragma mark UITextView 代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    const char * ch=[text cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (toBeString.length <= 100) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 选择担保人
- (void)danbaoClick:(UITapGestureRecognizer *)click
{
    if ([self.danbaoNum integerValue] > 0) {
        NSMutableArray * array = [NSMutableArray array];
        for (int i = 0; i < danbaorenArr.count; i++) {
            @autoreleasepool {
                DanBaoRenModel * danbaorenModel = danbaorenArr[i];
                NSString * str = [NSString stringWithFormat:@"%@(%@)",danbaorenModel.nickname,danbaorenModel.bangPrice];
                [array addObject:str];
            }
        }
        
        //[array insertObject:@"无担保人(0.00)" atIndex:0];
        
        UIActionSheet * actionsheet = [[UIActionSheet alloc]initWithTitle:@"选择担保人" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i = 0; i < array.count; i++) {
            [actionsheet addButtonWithTitle:array[i]];
        }
        [actionsheet addButtonWithTitle:@"取消"];
        actionsheet.cancelButtonIndex = actionsheet.numberOfButtons - 1;
        actionsheet.tag = 33333;
        [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
        
        [self.view endEditing:YES];
    }else{
        ChooseDanbaoViewController * vc = [[ChooseDanbaoViewController alloc]init];
        vc.nameArr = shurenArr;
        [vc sendMessage:^(id result) {
            shurenArr = result;
            for(UIImageView *view in [danbaoView subviews])
            {
                if (view != danbaoDownImg) {
                    [view removeFromSuperview];
                }
            }
            [chooseShurenArr removeAllObjects];
            for (int i = 0; i < shurenArr.count; i++) {
                if ([[shurenArr[i] valueForKey:@"sign"] isEqualToString:@"1"]) {
                    [chooseShurenArr addObject:[shurenArr[i] valueForKey:@"name"]];
                }
            }
            if (chooseShurenArr.count == 0) {
                danbaoNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 9 - 15 - 150, 13, 150, 14)];
                danbaoNameLabel.textAlignment = NSTextAlignmentRight;
                danbaoNameLabel.font = SIZE_FOR_12;
                danbaoNameLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
                danbaoNameLabel.text = @"选择";
                [danbaoView addSubview:danbaoNameLabel];
            }else{
            NSInteger j = 5 < chooseShurenArr.count ? 5:chooseShurenArr.count;
            for (int i = 0 ; i < j; i++) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
                imageV.center = CGPointMake(danbaoDownImg.frame.origin.x - (i + 1) * 32, 20);
                [imageV sd_setImageWithURL:[NSURL URLWithString:[chooseShurenArr[chooseShurenArr.count - 1 - i] avatar]]];
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.clipsToBounds = YES;
                imageV.layer.cornerRadius = 12.5;
                imageV.layer.masksToBounds = YES;
                [danbaoView addSubview:imageV];
//                danbaoNameLabel.hidden = YES;
            }
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    [SGActionView showSheetWithTitle:@"选择担保人" itemTitles:array selectedIndex:50 selectedHandle:^(NSInteger index) {
//        if (index == 0) {
//            danbaoNameLabel.text = @"选择";
//            danbaoPriceLabel.text = @"0.00";
//            priceLabel.text = [NSString stringWithFormat:@"¥%@",detailModel.bangPrice];
//
//            if ([_postSign isEqualToString:@"1"]) {
//                totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[detailModel.bangPrice floatValue]* num];
//            }else{
//                totalPrice.text = [NSString stringWithFormat:@"合计：¥ %.2f",[detailModel.bangPrice floatValue]* num];
//            }
//            
//            danbaorenID = @"";
//        }else{
//            DanBaoRenModel * danbaorenModel = danbaorenArr[index - 1];
//            danbaoNameLabel.text = danbaorenModel.nickname;
//            danbaoPriceLabel.text = danbaorenModel.bangPrice;
//            priceLabel.text = [NSString stringWithFormat:@"¥ %@",danbaorenModel.bangPrice];
//            if ([_postSign isEqualToString:@"1"]) {
//                totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[danbaorenModel.bangPrice floatValue]* num];
//            }else{
//                totalPrice.text = [NSString stringWithFormat:@"合计： ¥ %.2f",[danbaorenModel.bangPrice floatValue]* num];
//            }
//            
//            danbaorenID = danbaorenModel.account;
//        }
//    }];
}

#pragma mark - 控件赋值
- (void)makeValueToControl
{
    //重置坐标
    if (getDic.allKeys.count == 0) {
        addressBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        
        addressDetailImg.frame = CGRectMake(SCREEN_WIDTH - 15 - 12, (addressBGView.frame.size.height - 24.5)/2, 12, 24.5);
        
        receivePerLabel.hidden = YES;
        phoneLabel.hidden = YES;
        receiveAddLabel.hidden = YES;
        tempLabel.hidden = YES;
        noReceiveImg.hidden = NO;
        selectLabel.hidden = NO;
    }else{
        
        addressBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 94);
        receivePerLabel.hidden = NO;
        phoneLabel.hidden = NO;
        receiveAddLabel.hidden = NO;
        noReceiveImg.hidden = YES;
        selectLabel.hidden = YES;
        tempLabel.hidden = NO;
        
        addressDetailImg.frame = CGRectMake(SCREEN_WIDTH - 15 - 12, (addressBGView.frame.size.height - 24.5)/2, 12, 24.5);
        
        receivePerLabel.text = [NSString stringWithFormat:@"%@",[getDic objectForKey:@"receiver"]];
        phoneLabel.text = [NSString stringWithFormat:@"%@",[getDic objectForKey:@"mobile"]];
        receiveAddLabel.text = [NSString stringWithFormat:@"%@",[getDic objectForKey:@"address"]];
        
        CGRect rect = [[getDic objectForKey:@"address"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25 - 15, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
        CGRect receiveRect = receiveAddLabel.frame;
        receiveRect.size.height = rect.size.height;
        receiveAddLabel.frame = receiveRect;
        addressBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 78 + rect.size.height);
    }
    sellerLabel.text = [NSString stringWithFormat:@"卖家:%@",detailModel.nickname];
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:detailModel.cover] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    goodsImg.contentMode = UIViewContentModeScaleAspectFill;
    goodsImg.clipsToBounds = YES;
    goodsLabel.text = detailModel.title;

    //格式化日期
    NSString * timeStr = [CompareCurrentTime compareCurrentTime:detailModel.updatetimeLong];
    timeLabel.text = timeStr;
    
    
//    if ([detailModel.isFriended isEqualToString:@"0"]) {
//        priceLabel.text = [NSString stringWithFormat:@"¥ %@",detailModel.originalPrice];
//        if ([_postSign isEqualToString:@"1"]) {
//            totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[detailModel.originalPrice floatValue]* num];
//        }else{
//            totalPrice.text = [NSString stringWithFormat:@"合计：¥ %.2f",[detailModel.originalPrice floatValue]* num];
//        }
//    }else{
        priceLabel.text = [NSString stringWithFormat:@"¥ %@",detailModel.bangPrice];
        if ([_postSign isEqualToString:@"1"]) {
            totalPrice.text = [NSString stringWithFormat:@"合计(包邮)：¥ %.2f",[detailModel.bangPrice floatValue]* num];
        }else{
            totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[detailModel.bangPrice floatValue]* num + [detailModel.transportPrice floatValue]];
        }

//    }
    tempPrice = [priceLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    tempTotalPrice = [totalPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    
    
    sellerBGView.frame = CGRectMake(0, addressBGView.frame.size.height + addressBGView.frame.origin.y+15, SCREEN_WIDTH, 121);
    numBGView.frame = CGRectMake(0, sellerBGView.frame.size.height + sellerBGView.frame.origin.y+15, SCREEN_WIDTH, 122);
    sellerSayBGView.frame = CGRectMake(0, numBGView.frame.size.height + numBGView.frame.origin.y+15, SCREEN_WIDTH, 60);
    toolView.frame = CGRectMake(0, SCREEN_HEIGHT - 42 - 64, SCREEN_WIDTH, 42);
    
    mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressBGView.frame.size.height +sellerBGView.frame.size.height + numBGView.frame.size.height + sellerSayBGView.frame.size.height + 45 + 30 + 15 + 10);
    
    if ([_postSign isEqualToString:@"1"]) {
        postPriceLabel.text = @"包邮";
    }else{
        postPriceLabel.text = [NSString stringWithFormat:@"¥ %@",detailModel.transportPrice];
    }
    
    if ([detailModel.isFriended isEqualToString:@"1"]) {
        danbaoView.hidden = YES ;
        submitBtn.enabled = YES;
        submitBtn.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    }else{
        danbaoView.hidden = NO;
        danbaorenLabel.hidden = NO;
        CGRect rect = numBGView.frame;
        rect.size.height = 163-44;
        numBGView.frame = rect;
        sellerSayBGView.frame = CGRectMake(0, numBGView.frame.size.height + numBGView.frame.origin.y+15, SCREEN_WIDTH, 60);
        mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, addressBGView.frame.size.height +sellerBGView.frame.size.height + numBGView.frame.size.height + sellerSayBGView.frame.size.height + 45 + 30 + 15 + 10);
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateNormal];
//        if (danbaorenArr.count == 0 || danbaorenArr == nil) {
//            submitBtn.enabled = NO;
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"没有担保人" message:@"还没有共同熟人为其担保,去看看共同好友有哪些吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//        }else{
        submitBtn.enabled = YES;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
//        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        CommonFriendViewController * commonFriendVC = [[CommonFriendViewController alloc]init];
        commonFriendVC.sellerAccount = detailModel.account;
        [self.navigationController pushViewController:commonFriendVC animated:YES];
    }
}

#pragma mark - 提交
- (void)submit:(UIButton *)submit
{
    if ([postMethodLabel.text isEqualToString:@"选择"]) {
        [AutoDismissAlert autoDismissAlert:@"请选择配送方式"];
        return;
    }
    
    if ([detailModel.isFriended isEqualToString:@"0"]) {
        if ([self.danbaoNum integerValue] > 0) {
            if (danbaorenID == nil || [danbaorenID isEqualToString:@"0"] || danbaorenID.length == 0) {
                [AutoDismissAlert autoDismissAlert:@"请选择担保人"];
                return;
            }
        }
    }
    
    MBProgressHUD * huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    huds.labelText = @"提交中,请稍后";
    huds.dimBackground = YES;
    [huds show:YES];
    
    //过滤空格,以及判断留言是否为空
    NSString * toSellerStr = [textViews.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (toSellerStr == nil || toSellerStr.length == 0 ||[toSellerStr isEqualToString:@""]) {
        toSellerStr = @"";
    }
    

    NSString * receiveAddressStr = [getDic objectForKey:@"id"] ? [getDic objectForKey:@"id"] : @"0";
    if ((receiveAddressStr.length == 0 || [receiveAddressStr isEqualToString:@""] || receiveAddressStr == nil) && ![postMethodLabel.text isEqualToString:@"自提"]) {
        [AutoDismissAlert autoDismissAlert:@"请选择收货地址"];
        [huds removeFromSuperview];
        return;
    }
    
    
    NSDictionary * dic = [[NSDictionary alloc]init];
    if ([self.friendsign isEqualToString:@"1"] || [self.danbaoNum integerValue] > 0) {
        dic = [self parametersForDic:@"getBuyPostOrder" parameters:@{ACCOUNT_PASSWORD,@"id":self.goodsID,@"buyType":@"5",@"quantity":goodsNumText.text,@"addressId":receiveAddressStr,@"postscript":toSellerStr,@"guaranteeUser":danbaorenID,@"shippingName":postMethodLabel.text}];
        if (self.spOrderID) {
            dic = [self parametersForDic:@"getBuyTaskOrder" parameters:@{ACCOUNT_PASSWORD,@"id":self.spOrderID,@"goodsId": _goodsID,@"buyType":@"4",@"quantity":goodsNumText.text,@"addressId":receiveAddressStr,@"postscript":toSellerStr,@"guaranteeUser":danbaorenID,@"shippingName":postMethodLabel.text}];
        }
    }else{
        NSMutableString * str = [[NSMutableString alloc]init];
        for (int i = 0; i < chooseShurenArr.count; i++) {
            NSMutableString *String1 = [[NSMutableString alloc] initWithString:[chooseShurenArr[i] account]];
            [String1 insertString:@"," atIndex:0];
            NSString * string2 = [[NSString alloc]initWithString:String1];
            [str appendString:string2];
        }
        //[str deleteCharactersInRange:NSMakeRange(0, 1)];
        dic = [self parametersForDic:@"getBuyPostOrder" parameters:@{ACCOUNT_PASSWORD,@"id":self.goodsID,@"buyType":@"5",@"quantity":goodsNumText.text,@"addressId":receiveAddressStr,@"postscript":toSellerStr,@"inviteUser":str,@"shippingName":postMethodLabel.text}];
        if (self.spOrderID) {
            dic = [self parametersForDic:@"getBuyTaskOrder" parameters:@{ACCOUNT_PASSWORD,@"id":self.spOrderID,@"goodsId": _goodsID,@"buyType":@"4",@"quantity":goodsNumText.text,@"addressId":receiveAddressStr,@"postscript":toSellerStr,@"inviteUser":str,@"shippingName":postMethodLabel.text}];
        }
    }
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dataDict = [dic objectForKey:@"data"];
//            TransactionDetail * transactionDetail = [[TransactionDetail alloc]init];
//            [transactionDetail setValuesForKeysWithDictionary:dataDict];
            [self payWithOrderDetailRequest:dataDict];
            //[self checkOrderWithID:dataDict withTitle:detailModel.title];
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [huds removeFromSuperview];
    } andFailureBlock:^{
        [huds removeFromSuperview];
    }];
}

#pragma mark - 网络请求
//- (void)urlRequestPost
//{
//    NSDictionary * dic = [self parametersForDic:@"accountGetOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"status":@"0",@"start":@"0",@"count":@"1"}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            NSDictionary * tempdic = [temparrs objectAtIndex:0];
//            ZZOrderModel * orderModel = [[ZZOrderModel alloc]init];
//            [orderModel setValuesForKeysWithDictionary:tempdic];
//            [self checkOrderWithID:orderModel withBtn:tempdic];
//        }else if([result isEqualToString:@"4"]){
//            
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        
//    } andFailureBlock:^{
//        
//    }];
//    
//}

#pragma mark - 验证是否可以支付
- (void)checkOrderWithID:(NSDictionary *)dataDict withTitle:(NSString *)string
{
    if ([[dataDict objectForKey:@"orderAmount"] isEqualToString:@"0.00"]) {
        SubZZMyOrderViewController * orderVC = [SubZZMyOrderViewController new];
        [self.navigationController pushViewController:orderVC animated:YES];
        return;
    }
//    //直接进入支付页面
//    ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
//    goPayVC.orderID = [dataDict objectForKey:@"orderId"];
//    goPayVC.orderTitle = detailModel.title;
//    goPayVC.orderDataDic = dataDict;
//    [self.navigationController pushViewController:goPayVC animated:YES];
//    
//    return;
    NSDictionary * dic = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":[dataDict objectForKey:@"orderId"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {

            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
            goPayVC.orderID = [dataDict objectForKey:@"orderId"];
            goPayVC.orderTitle = detailModel.title;
            //goPayVC.orderDataDic = dataDict;
            [self.navigationController pushViewController:goPayVC animated:YES];
        }else{
            if (![result isEqualToString:@"4"]){
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
    
}
#pragma mark- 网络请求
//获取订单详情
-(void)payWithOrderDetailRequest:(NSDictionary *)orderDict {
    NSDictionary * param = [self parametersForDic:@"accountGetOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":orderDict[@"orderId"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
            
            ZZGoPayViewController * goPayVC = [[ZZGoPayViewController alloc]init];
            goPayVC.orderID = orderDict[@"orderId"];
            goPayVC.orderTitle = detailModel.title;
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:@[orderDict[@"orderNum"], model.goods, orderDict[@"orderAmount"],  orderDict[@"orderAmount"]] forKeys:@[@"orderNum", @"goods", @"orderAmount", @"price"]];
            //goPayVC.orderDataDic = dataDict;
            [self.navigationController pushViewController:goPayVC animated:YES];
        }else{
            if (![result isEqualToString:@"4"]){
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
    } andFailureBlock:^{
        
    }];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 999999) {
        if (buttonIndex == 0) {
            postMethodLabel.text = @"快递";
        }else if (buttonIndex == 1){
            postMethodLabel.text = @"物流";
        }else if (buttonIndex == 2){
            postMethodLabel.text = @"自提";
        }
    }else if (actionSheet.tag == 33333){
//        if (buttonIndex == 0) {
//            danbaoNameLabel.text = @"选择";
//            danbaoPriceLabel.text = @"0.00";
//            priceLabel.text = [NSString stringWithFormat:@"¥ %@",detailModel.bangPrice];
//            
//            if ([_postSign isEqualToString:@"1"]) {
//                totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[detailModel.bangPrice floatValue]* num];
//            }else{
//                totalPrice.text = [NSString stringWithFormat:@"合计：¥ %.2f",[detailModel.bangPrice floatValue]* num];
//            }
//            danbaorenID = @"";
//        }else{
            if (buttonIndex != danbaorenArr.count) {
                DanBaoRenModel * danbaorenModel = danbaorenArr[buttonIndex];
                danbaoNameLabel.text = danbaorenModel.nickname;
                danbaoPriceLabel.text = danbaorenModel.bangPrice;
                priceLabel.text = [NSString stringWithFormat:@"¥ %@",danbaorenModel.bangPrice];
                if ([_postSign isEqualToString:@"1"]) {
                    totalPrice.text = [NSString stringWithFormat:@"合计(包邮)：¥ %.2f",[danbaorenModel.bangPrice floatValue]* num];
                }else{
                    totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[danbaorenModel.bangPrice floatValue]* num + [detailModel.transportPrice floatValue]];
                }
                danbaorenID = danbaorenModel.account;
//            }
        }
    }
}

#pragma mark - 选择配送方式
- (void)selectPostMethod:(UITapGestureRecognizer *)select
{
    [self.view endEditing:YES];
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:@"选择配送方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"快递",@"物流",@"自提", nil];
    action.tag = 999999;
    [action showInView:[UIApplication sharedApplication].keyWindow];
    
    
//    [SGActionView showSheetWithTitle:@"选择配送方式" itemTitles:@[@"快递",@"物流",@"自提"] selectedIndex:10 selectedHandle:^(NSInteger index) {
//        if (index == 0) {
//            postMethodLabel.text = @"快递";
//        }else if(index == 1){
//            postMethodLabel.text = @"物流";
//        }else{
//            postMethodLabel.text = @"自提";
//        }
//    }];
}

- (void)changeTotalPriceWithNum:(int)tempNum
{
    goodsNumText.text = [NSString stringWithFormat:@"%d",tempNum];
    if ([_postSign isEqualToString:@"1"]) {
        totalPrice.text = [NSString stringWithFormat:@"合计(包邮)：¥ %.2f",[[priceLabel.text stringByReplacingOccurrencesOfString:@"¥ " withString:@""] floatValue] * tempNum];
    }else{
        totalPrice.text = [NSString stringWithFormat:@"合计(含运费)：¥ %.2f",[[priceLabel.text stringByReplacingOccurrencesOfString:@"¥ " withString:@""] floatValue] * tempNum + [detailModel.transportPrice floatValue]];
    }
}

#pragma mark - 加减按钮操作
- (void)jianBtn:(UIButton *)sender
{
    num--;
    if (num <1) {
        num = 1;
    }
    [self changeTotalPriceWithNum:num];
}

- (void)jiaBtn:(UIButton *)sender
{
    num++;
    if (num > goodsNums) {
        num = goodsNums;
    }
    [self changeTotalPriceWithNum:num];
}

- (void)totalPriceChange:(UITextField *)text
{
    num = [text.text intValue];
    [self changeTotalPriceWithNum:num];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取默认收货地址
- (void)getAddressUrlRequest
{
    [loadImg removeFromSuperview];
    loadImg = [[LoadImg alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadImg.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.view addSubview:loadImg];
    [loadImg imgStart];
    
    NSDictionary * tempdic = [self parametersForDic:@"accountGetAddress" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            getDic = [dic objectForKey:@"data"];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[tempdic objectForKey:@"message"]];
        }
        [self getGoodsDetailRequest];
    } andFailureBlock:^{
        [self getGoodsDetailRequest];
    }];
}

#pragma mark - 获取商品信息
- (void)getGoodsDetailRequest
{
    NSDictionary * tempdic = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD,@"id":self.goodsID}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            detailModel = [[DetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];;
        }
        if ([self.danbaoNum integerValue] > 0) {
            [self getDanBaoRenListRequest];
        }else{
        [self getShuRenListRequest];
        }
    } andFailureBlock:^{
        if ([self.danbaoNum integerValue] > 0) {
            [self getDanBaoRenListRequest];
        }else{
            [self getShuRenListRequest];
        }
    }];
}

#pragma mark - 获取担保人列表
- (void)getDanBaoRenListRequest
{
    NSDictionary * dic = [self parametersForDic:@"getPostGuaranteeByRelation" parameters:@{ACCOUNT_PASSWORD,@"id":self.goodsID,@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [danbaorenArr removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0 ; i< temparr.count; i++) {
                DanBaoRenModel * danBaoRenModel = [[DanBaoRenModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [danBaoRenModel setValuesForKeysWithDictionary:tempdic];
                [danbaorenArr addObject:danBaoRenModel];
            }
        }else{
            
        }
        [self makeValueToControl];
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    } andFailureBlock:^{
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    }];
}

#pragma mark - 获取共同熟人列表
- (void)getShuRenListRequest
{
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendCommon" parameters:@{ACCOUNT_PASSWORD,@"user":self.account,@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [shurenArr removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0 ; i< temparr.count; i++) {
                DanBaoRenModel * danBaoRenModel = [[DanBaoRenModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [danBaoRenModel setValuesForKeysWithDictionary:tempdic];
                NSMutableDictionary * dicc = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       danBaoRenModel, @"name", @"0", @"sign", nil];;
                [shurenArr addObject:dicc];
            }
        }else{
            
        }
        [self makeValueToControl];
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    } andFailureBlock:^{
        [loadImg imgStop];
        [loadImg removeFromSuperview];
    }];
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
