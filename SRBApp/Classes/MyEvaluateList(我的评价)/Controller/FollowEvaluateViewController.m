//
//  FollowEvaluateViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/5/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FollowEvaluateViewController.h"
#import <UIImageView+WebCache.h>
#import <TuSDK/TuSDK.h>
#import "editViewController.h"
#import "CTAssetsPickerController.h"

@interface FollowEvaluateViewController ()<UITextViewDelegate>
{
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    UIImageView * imageView4;
    UIImageView * imageView5;
    UIImageView * imageView6;
    UIImageView * imageView7;
    
    NSString * uuid1;
    NSString * uuid2;
    NSString * uuid3;
    NSString * uuid4;
    NSString * uuid5;
    NSString * uuid6;
    
    UIButton * imageButton;
    NSInteger imageNumber;
    int imageSign;
    
    int publishNum;
    
    UILabel * numLabel;
    
    NSMutableArray * assets;
    
    UIImage * image1;
    UIImage * image2;
    UIImage * image3;
    UIImage * image4;
    UIImage * image5;
    UIImage * image6;
    
    NSInteger uploadnum;
    
    NSMutableArray * arr;
    
    NSTimer * timer;
    
    int camera;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    NSMutableString * myphotos;
    NSString * positionsign;
    
    UILabel * labeltext;
}
@property (nonatomic, strong) NSMutableArray * imageArr;//存地址的数组
@property (nonatomic, strong) NSMutableArray * bigImageArr;//存具体图片的数组
@property (nonatomic, strong) UITextView * textView;
@end

@implementation FollowEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"追加评价";
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    myphotos = [NSMutableString stringWithFormat:@""];
    positionsign = @"1";
    publishNum = 0;
    uploadnum = 0;
    camera = 0;
    _imageArr = [[NSMutableArray alloc]init];
    _bigImageArr = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    
    imageNumber = 0;
    positionsign = @"1";
    imageSign = 0;
    myphotos = [NSMutableString stringWithFormat:@""];
    [self customInit];
}

- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
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
    [regBtn addTarget:self action:@selector(regController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 667 * 105)];
    [view1 addSubview: [self addPhoto]];
    [self.view addSubview:view1];
    
    //评价
    UITextView * textview = [[UITextView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height + 20, SCREEN_WIDTH, 100)];
    textview.font = SIZE_FOR_IPHONE;
    textview.returnKeyType = UIReturnKeyDone;
    self.textView = textview;
    textview.delegate = self;
    [self.view addSubview:textview];
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH, 16)];
    labeltext.text = @"说点什么...";
    [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
    [self.textView addSubview:labeltext];
}

- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regController
{
    [self commentSubmit];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        labeltext.hidden = YES;
    }else{
        labeltext.hidden = NO;
    }
    
//    NSString * toBeString = textView.text;
//    
//    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange * selectedRange = [textView markedTextRange];
//        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
//        __block int chNum = 0;
//        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//            
//            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
//            if ([tempData length] == 3) {
//                chNum ++;
//            }
//        }];
//        if (chNum >= 20) {
//            _canedit = NO;
//        }
//        if (!position) {
//            if (toBeString.length > 140) {
//                textView.text = [toBeString substringToIndex:140];
//                _canedit = YES;
//            }
//        }
//    }
//    else{
//        if (toBeString.length > 140) {
//            textView.text = [toBeString substringToIndex:140];
//            _canedit = NO;
//        }
//    }
//    if (textView.text.length > 140) {
//        numLabel.text = @"0";
//    }else
//    {
//        numLabel.text = [NSString stringWithFormat:@"%u",140 - textView.text.length];
//    }
}


#pragma mark - 提交按钮
- (void)commentSubmit
{
    NSString * sayStr = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([sayStr isEqualToString:@""] || sayStr.length == 0 || sayStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请输入评价内容"];
        [self.textView becomeFirstResponder];
        publishNum = 0;
        return;
    }
    [HUD removeFromSuperview];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    
//    NSString * isTongbuStr = @"1";
    for (int i = 0; i < _imageArr.count; i++) {
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:_imageArr[i]];
        [String1 insertString:@"," atIndex:0];
        NSString * string2 = [[NSString alloc]initWithString:String1];
        [myphotos appendString:string2];
    }
    
    NSString * string = nil;
    if ([myphotos isEqualToString:@""]) {
        string = @"0";
    }else
    {
        [myphotos deleteCharactersInRange:NSMakeRange(0, 1)];
        string = myphotos;
    }
    
    NSString * danRBSayStr = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSDictionary * guarantorDic = self.toSellerModel.guarantor;
    if ([danRBSayStr isEqualToString:@""] || danRBSayStr.length == 0 || danRBSayStr == nil) {
        //danRBSayStr = @"0";
    }
    NSDictionary * dic = [self parametersForDic:@"accountAppendOrderComment" parameters:@{ACCOUNT_PASSWORD,@"itemId":self.itemID,@"orderId":self.orderID,@"content":sayStr,@"photos":string,@"uuid":@"0"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
//            [self.buyerWaiCommentVC urlRequestPost];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            publishNum = 0;
        }
        [HUD hide:YES];
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD hide:YES];
        [HUD removeFromSuperview];
        publishNum = 0;
    }];
}

- (UIView *)addPhoto
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WIDTH * 105)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    if (SCREEN_HEIGHT == 480) {
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WIDTH * 105);
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 1.56, WIDTH * 105);
    }else{
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WIDTH * 105);
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 1.75, WIDTH * 105);
    }
    [view addSubview:scrollView];
    
    
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView1 setImage:[UIImage imageNamed:@"fb_xj.png"]];
    imageView1.center = CGPointMake(15 + 37.5 * SCREEN_HEIGHT / 667, view.frame.size.height / 2);
    imageView1.userInteractionEnabled = YES;
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    [scrollView addSubview:imageView1];
    UITapGestureRecognizer *pLongPress1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress1:)];
    pLongPress1.numberOfTapsRequired = 1;;
    [imageView1 addGestureRecognizer:pLongPress1];
    [scrollView addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    imageView2.center = CGPointMake(30 + (75 +  37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    imageView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *pLongPress2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress2:)];
    pLongPress2.numberOfTapsRequired = 1;
    [imageView2 addGestureRecognizer:pLongPress2];
    [scrollView addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    imageView3.center = CGPointMake(15 * 3 + (75 * 2 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView3.userInteractionEnabled = YES;
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.clipsToBounds = YES;
    UITapGestureRecognizer *pLongPress3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress3:)];
    pLongPress3.numberOfTapsRequired = 1;
    [imageView3 addGestureRecognizer:pLongPress3];
    [scrollView addSubview:imageView3];
    
    imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    imageView4.center = CGPointMake(15 * 4 + (75 * 3 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView4.userInteractionEnabled = YES;
    imageView4.contentMode = UIViewContentModeScaleAspectFill;
    imageView4.clipsToBounds = YES;
    UITapGestureRecognizer *pLongPress4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress4:)];
    pLongPress4.numberOfTapsRequired = 1;
    [imageView4 addGestureRecognizer:pLongPress4];
    [scrollView addSubview:imageView4];
    
    imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView5.center = CGPointMake(15 * 5 + (75 * 4 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView5.userInteractionEnabled = YES;
    imageView5.contentMode = UIViewContentModeScaleAspectFill;
    imageView5.clipsToBounds = YES;
    [scrollView addSubview:imageView5];
    UITapGestureRecognizer *pLongPress5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress5:)];
    pLongPress5.numberOfTapsRequired = 1;
    [imageView5 addGestureRecognizer:pLongPress5];
    
    imageView6 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView6.center = CGPointMake(15 * 6 + (75 * 5 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    imageView6.userInteractionEnabled = YES;
    imageView6.contentMode = UIViewContentModeScaleAspectFill;
    imageView6.clipsToBounds = YES;
    [scrollView addSubview:imageView6];
    UITapGestureRecognizer *pLongPress6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress6:)];
    pLongPress6.numberOfTapsRequired = 1;
    [imageView6 addGestureRecognizer:pLongPress6];
    
    imageView7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_HEIGHT / 667 * 75, SCREEN_HEIGHT / 667 * 75)];
    //    [imageView4 setImage:[UIImage imageNamed:@"x1.png"]];
    imageView7.center = CGPointMake(15 * 7 + (75 * 6 + 37.5) * SCREEN_HEIGHT / 667, imageView1.center.y);
    [scrollView addSubview:imageView7];
    [self reloadImage];
    return view;
}


- (void)reloadImage
{
    if (_imageArr.count == 0) {
        [imageView1 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageButton.frame = imageView1.frame;
        [imageView2 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView3 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView4 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView5 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView6 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = YES;
        //        imageView2.del.hidden = YES;
        //        imageView3.del.hidden = YES;
        //        imageView4.del.hidden = YES;
        //        imageView5.del.hidden = YES;
        //        imageView6.del.hidden = YES;
    } else if (_imageArr.count == 1) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 1;
        [imageView3 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView4 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView5 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView6 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = YES;
        //        imageView3.del.hidden = YES;
        //        imageView4.del.hidden = YES;
        //        imageView5.del.hidden = YES;
        //        imageView6.del.hidden = YES;
    } else if (_imageArr.count == 2) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:_bigImageArr[1]];
        [imageView3 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 2;
        [imageView4 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView5 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView6 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = NO;
        //        imageView3.del.hidden = YES;
        //        imageView4.del.hidden = YES;
        //        imageView5.del.hidden = YES;
        //        imageView6.del.hidden = YES;
    }else if (_imageArr.count == 3) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
        //        [imageView3 sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:_bigImageArr[1]];
        [imageView3 setImage:_bigImageArr[2]];
        [imageView4 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 3;
        [imageView5 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView6 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = NO;
        //        imageView3.del.hidden = NO;
        //        imageView4.del.hidden = YES;
        //        imageView5.del.hidden = YES;
        //        imageView6.del.hidden = YES;
    }else if (_imageArr.count == 4) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
        //        [imageView3 sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
        //        [imageView4 sd_setImageWithURL:[NSURL URLWithString:_imageArr[3]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:_bigImageArr[1]];
        [imageView3 setImage:_bigImageArr[2]];
        [imageView4 setImage:_bigImageArr[3]];
        [imageView5 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 4;
        [imageView6 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = NO;
        //        imageView3.del.hidden = NO;
        //        imageView4.del.hidden = NO;
        //        imageView5.del.hidden = YES;
        //        imageView6.del.hidden = YES;
    }else if (_imageArr.count == 5) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
        //        [imageView3 sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
        //        [imageView4 sd_setImageWithURL:[NSURL URLWithString:_imageArr[3]]];
        //        [imageView5 sd_setImageWithURL:[NSURL URLWithString:_imageArr[4]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:_bigImageArr[1]];
        [imageView3 setImage:_bigImageArr[2]];
        [imageView4 setImage:_bigImageArr[3]];
        [imageView5 setImage:_bigImageArr[4]];
        [imageView6 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 5;
        [imageView7 setImage:[UIImage imageNamed:@"fb_gd_bg.png"]];
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = NO;
        //        imageView3.del.hidden = NO;
        //        imageView4.del.hidden = NO;
        //        imageView5.del.hidden = NO;
        //        imageView6.del.hidden = YES;
    }else if (_imageArr.count == 6) {
        //        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
        //        [imageView2 sd_setImageWithURL:[NSURL URLWithString:_imageArr[1]]];
        //        [imageView3 sd_setImageWithURL:[NSURL URLWithString:_imageArr[2]]];
        //        [imageView4 sd_setImageWithURL:[NSURL URLWithString:_imageArr[3]]];
        //        [imageView5 sd_setImageWithURL:[NSURL URLWithString:_imageArr[4]]];
        //        [imageView6 sd_setImageWithURL:[NSURL URLWithString:_imageArr[5]]];
        [imageView1 setImage:_bigImageArr[0]];
        [imageView2 setImage:_bigImageArr[1]];
        [imageView3 setImage:_bigImageArr[2]];
        [imageView4 setImage:_bigImageArr[3]];
        [imageView5 setImage:_bigImageArr[4]];
        [imageView6 setImage:_bigImageArr[5]];
        [imageView7 setImage:[UIImage imageNamed:@"fb_xj.png"]];
        imageNumber = 6;
        //        imageView1.del.hidden = NO;
        //        imageView2.del.hidden = NO;
        //        imageView3.del.hidden = NO;
        //        imageView4.del.hidden = NO;
        //        imageView5.del.hidden = NO;
        //        imageView6.del.hidden = NO;
    }
    if (arr.count == imageNumber || camera == 1) {
        camera = 0;
        [HUD removeFromSuperview];
    }
}

#pragma mark - 长按手势
- (void)longPress1:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 0) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 0) {
        
        [self bianji];
    }
}

- (void)longPress2:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 1) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 1) {
        [self bianji];
    }
}

- (void)longPress3:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 2) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 2) {
        [self bianji];
    }
}

- (void)longPress4:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 3) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 3) {
        [self bianji];
    }
}

- (void)longPress5:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 4) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 4) {
        [self bianji];
    }
}

- (void)longPress6:(UITapGestureRecognizer *)tap
{
    if (_imageArr.count == 5) {
        [self cameraButton:tap];
    }
    if (_imageArr.count > 5) {
        [self bianji];
    }
}

- (void)bianji
{
    editViewController * editV = [[editViewController alloc]init];
    editV.albumlist = _imageArr;
    editV.bigAlbumlist = _bigImageArr;
    editV.arrlist = arr;
    __block NSMutableArray * bdragArr = _imageArr;
    __block NSMutableArray * bigbdragArr = _bigImageArr;
    __block NSMutableArray * arrbdragArr = arr;
    __block id bself = self;
    [editV setSortCompleteCallBack:^(NSArray *dragArr,NSArray*bigdragArr, NSArray*arrdragArr)
     {
         [bdragArr removeAllObjects];
         [bigbdragArr removeAllObjects];
         [arrbdragArr removeAllObjects];
         
         [bdragArr addObjectsFromArray:dragArr];
         [bigbdragArr addObjectsFromArray:bigdragArr];
         [arrbdragArr addObjectsFromArray:arrdragArr];
         
         
         [bself updateDragScrollerView];
         
         imageNumber = bdragArr.count;
         uploadnum = bdragArr.count;
     }];
    [self.navigationController pushViewController:editV animated:YES];
    editV = nil;
}

- (void)updateDragScrollerView
{
    //移除之前的数据
    //    for (UIView * views in _scrollV.subviews)
    //    {
    //        [views removeFromSuperview];
    //    }
    //    for (int i = 0 ; i < _dragArr.count; i ++)
    //    {
    //        CGFloat x = i % 3 * 107 + 10;
    //        CGFloat y = i/3 * 125;
    //        UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //        [dragBu setFrame:CGRectMake(x, y, 83, 81)];
    //        [dragBu setTitle:[_dragArr objectAtIndex:i] forState:UIControlStateNormal];
    //        [_scrollV addSubview:dragBu];
    //    }
    [self reloadImage];
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
                
            {
                //无权限
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置 → 隐私 → 相机”中 ,允许熟人邦访问你的相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
            }else
            {
                
                [self cameraComponentHandler];
            }
            break;
        }
//        case 1:
//        {
//            NSLog(@"打开系统图片库");
//            //            ALAuthorizationStatus author = ALAssetsLibraryauthorizationStatus;
//            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//            
//            if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
//                
//            {
//                //无权限
//                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置 → 隐私 → 照片”中 ,允许熟人邦访问你的相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show];
//                
//            }
//            else{
//                [self editAdvancedComponentHandler];
//            }
//            break;
//        }
        case 1:
        {
            NSLog(@"打开系统图片库");
            //            ALAuthorizationStatus author = ALAssetsLibraryauthorizationStatus;
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            
            if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
                
            {
                
                //无权限
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置 → 隐私 → 照片”中 ,允许熟人邦访问你的相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
            }
            else{
                [self pickAssets];
            }
            break;
        }
        default:
            break;
    }
}
//打开相册
- (void)pickAssets
{
    assets = [[NSMutableArray alloc] init];
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    //    picker.allowsEditing = YES;//是否可以对原图进行编辑
    picker.maximumNumberOfSelection = 6 - _imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    uploadnum = arr.count;
    picker.delegate = self;
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    //    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selsectArray];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

#pragma mark 点击完成按钮
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (!arr) {
        arr = [NSMutableArray arrayWithArray:assets];
    }else{
        if (uploadnum < imageNumber) {
            arr = [NSMutableArray arrayWithArray:assets];
        }else{
            [arr addObjectsFromArray:assets];
        }
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    //        double delayInSeconds = 1.0;
    //        if (arr.count < 5) {
    //            delayInSeconds = 1.0 + arr.count * 0.2;
    //        }else if(arr.count == 5){
    //            delayInSeconds = 2.3;
    //        }else
    //        {
    //            delayInSeconds = 3;
    //        }
    
    //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    //        [timer setFireDate:[NSDate distantPast]];
    
    //    });
    [self dismissViewControllerAnimated:YES completion:nil];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"上传中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
}

- (void)onTimer
{
    if (uploadnum < imageNumber ) {
        for (int i = 0; i < _imageArr.count; i++) {
            [arr insertObject:_imageArr[i] atIndex:i];
        }
        uploadnum = imageNumber;
    }
    if (arr.count == imageNumber) {
        [timer invalidate];
        timer = nil;
        return;
    }else{
        if (uploadnum == 0 && imageNumber == 0) {
            ALAsset *asset = arr[0];
            image1 = [[UIImage alloc]init];
            //        image1 = [UIImage imageWithCGImage: asset.aspectRatioThumbnail];
            image1 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image1;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            //设置image的尺寸
            CGSize imagesize = image1.size;
            image1 = [self scaleToSize:image1 size:imagesize];
            [_bigImageArr addObject:image1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image1,0.3)];
            uploadnum = 1;
        }
        if (uploadnum == 1 && imageNumber == 1 ) {
            ALAsset *asset = arr[1];
            image2 = [[UIImage alloc]init];
            image2 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image2;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image2.size;
            image2 = [self scaleToSize:image2 size:imagesize];
            [_bigImageArr addObject:image2];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image2, 0.3)];
            uploadnum = 2;
        }
        if (uploadnum == 2 && imageNumber == 2) {
            ALAsset *asset = arr[2];
            image3 = [[UIImage alloc]init];
            image3 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image3;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image3.size;
            image3 = [self scaleToSize:image3 size:imagesize];
            [_bigImageArr addObject:image3];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image3, 0.3)];
            uploadnum = 3;
        }
        if (uploadnum == 3 && imageNumber == 3) {
            ALAsset *asset = arr[3];
            image4 = [[UIImage alloc]init];
            image4 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image4;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image4.size;
            image4 = [self scaleToSize:image4 size:imagesize];
            [_bigImageArr addObject:image4];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image4, 0.3)];
            uploadnum = 4;
        }
        if (uploadnum == 4 && imageNumber == 4) {
            ALAsset *asset = arr[4];
            image5 = [[UIImage alloc]init];
            image5 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image5;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image5.size;
            image5 = [self scaleToSize:image5 size:imagesize];
            [_bigImageArr addObject:image5];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image5, 0.3)];
            uploadnum = 5;
        }
        if (uploadnum == 5 && imageNumber == 5) {
            ALAsset *asset = arr[5];
            image6 = [[UIImage alloc]init];
            image6 = [self fullResolutionImageFromALAsset:asset];
            //        UIImage * image = image6;
            //        [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image6.size;
            image6 = [self scaleToSize:image6 size:imagesize];
            [_bigImageArr addObject:image6];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image6, 0.3)];
            uploadnum = 6;
        }
    }
    
}

- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 6;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (self.imageArr.count == 6)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Please select not more than 6 assets"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Attention"
                                   message:@"Your asset has not yet been downloaded to your device"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (self.imageArr.count < 7 && asset.defaultRepresentation != nil);
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    CGSize imagesize = image.size;
    image = [self scaleToSize:image size:imagesize];
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
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView2.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView2.frame;
            //            imageView1.del.hidden = NO;
        }
        if (imageNumber == 1) {
            uuid2 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView2.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView3.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView3.frame;
            //            imageView2.del.hidden = NO;
        }
        if (imageNumber == 2) {
            uuid3 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView3.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView4.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView4.frame;
            //            imageView3.del.hidden = NO;
        }
        if (imageNumber == 3) {
            uuid4 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView5.image = [UIImage imageNamed:@"fb_xj.png"];
            //            imageView4.del.hidden = NO;
        }
        if (imageNumber == 4) {
            uuid5 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView5.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView6.image = [UIImage imageNamed:@"fb_xj.png"];
            //            imageView5.del.hidden = NO;
        }
        if (imageNumber == 5) {
            uuid6 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView6.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView7.image = [UIImage imageNamed:@"fb_xj.png"];
            //            imageView6.del.hidden = NO;
        }
        imageNumber += 1;
        camera = 1;
        
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
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView2.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView2.frame;
            //            imageView1.del.hidden = NO;
        }
        if (imageNumber == 1) {
            uuid2 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView2.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView3.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView3.frame;
            //            imageView2.del.hidden = NO;
        }
        if (imageNumber == 2) {
            uuid3 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView3.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView4.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = imageView4.frame;
            //            imageView3.del.hidden = NO;
        }
        if (imageNumber == 3) {
            uuid4 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView5.image = [UIImage imageNamed:@"fb_xj.png"];
            imageButton.frame = CGRectMake(SCREEN_WIDTH, 0, 1, 1);
            //            imageView4.del.hidden = NO;
        }
        if (imageNumber == 4) {
            uuid5 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView5.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView6.image = [UIImage imageNamed:@"fb_xj.png"];
            //            imageView5.del.hidden = NO;
        }
        if (imageNumber == 5) {
            uuid6 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            [arr addObject:image];
            imageView6.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView7.image = [UIImage imageNamed:@"fb_xj.png"];
            //            imageView6.del.hidden = NO;
        }
        imageNumber += 1;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)uploadPictureWithImageData:(NSData *)imageData{
    
    NSString *url = iOS_POST_REALPICTURE_URL;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
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
        [_imageArr addObject:str];
        //        [AutoDismissAlert autoDismissAlert:@"上传成功"];
        [self reloadImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [AutoDismissAlert autoDismissAlert:@"上传失败"];
        [HUD removeFromSuperview];
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

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (void)regController:(id)sender
{
    publishNum += 1;
    if (publishNum == 1) {
        [self commentSubmit];
    }
}

#pragma mark - 使用相机
- (void) cameraComponentHandler;
{
    // 开启访问相机权限
    [TuSDKTSDeviceSettings checkAllowWithType:lsqDeviceSettingsCamera
                                    completed:^(lsqDeviceSettingsType type, BOOL openSetting)
     {
         if (openSetting) {
             lsqLError(@"Can not open camera");
             return;
         }
         [self showCameraController];
     }];
}

#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
- (void)showCameraController;
{
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFCameraOptions.html
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    // opt.viewClazz = [TuSDKPFCameraView class];
    
    // 默认相机控制栏视图类 (默认:TuSDKPFCameraConfigView, 需要继承 TuSDKPFCameraConfigView)
    // opt.configBarViewClazz = [TuSDKPFCameraConfigView class];
    
    // 默认相机底部栏视图类 (默认:TuSDKPFCameraBottomView, 需要继承 TuSDKPFCameraBottomView)
    // opt.bottomBarViewClazz = [TuSDKPFCameraBottomView class];
    
    // 闪光灯视图类 (默认:TuSDKPFCameraFlashView, 需要继承 TuSDKPFCameraFlashView)
    // opt.flashViewClazz = [TuSDKPFCameraFlashView class];
    
    // 滤镜视图类 (默认:TuSDKPFCameraFilterGroupView, 需要继承 TuSDKPFCameraFilterGroupView)
    // opt.filterViewClazz = [TuSDKPFCameraFilterGroupView class];
    
    // 聚焦触摸视图类 (默认:TuSDKICFocusTouchView, 需要继承 TuSDKICFocusTouchView)
    // opt.focusTouchViewClazz = [TuSDKICFocusTouchView class];
    
    // 摄像头前后方向 (默认为后置优先)
    // opt.avPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.defaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    opt.showFilterDefault = YES;
    
    // 滤镜列表行视图宽度
    // opt.filterBarCellWidth = 75;
    
    // 滤镜列表选择栏高度
    // opt.filterBarHeight = 100;
    
    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    // opt.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    
    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    // opt.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // opt.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    
    // 是否保存最后一次使用的滤镜
    opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    opt.autoSelectGroupDefaultFilter = YES;
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 开启持续自动对焦 (默认: NO)
    opt.enableContinueFoucs = YES;
    
    // 自动聚焦延时 (默认: 5秒)
    // opt.autoFoucsDelay = 5;
    
    // 长按延时 (默认: 1.2秒)
    // opt.longTouchDelay = 1.2;
    
    // 保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
    opt.saveToAlbum = NO;
    
    // 保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
    // opt.saveToTemp = NO;
    
    // 保存到系统相册的相册名称
    opt.saveToAlbumName = @"熟人邦";
    
    // 照片输出压缩率 0-1 如果设置为0 将保存为PNG格式 (默认: 0.95)
    // opt.outputCompress = 0.95f;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = RGB(51, 51, 51);
    
    // 照片输出分辨率
    // opt.outputSize = CGSizeMake(1440, 1920);
    
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    // opt.disableMirrorFrontFacing = YES;
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
    controller.delegate = self;
    [self presentModalNavigationController:controller animated:YES];
}

/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    [controller dismissModalViewControllerAnimated:YES];
    lsqLDebug(@"onTuSDKPFCamera: %@", result);
    [self upimagefengzhuang:result];
}

#pragma mark - editAdvancedComponentHandler
/**
 *  4-1 高级图片编辑组件
 */
- (void)editAdvancedComponentHandler;
{
    lsqLDebug(@"editAdvancedComponentHandler");
    
    _albumComponent =
    [TuSDK albumCommponentWithController:self
                           callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         
         // 获取图片错误
         if (error) {
             lsqLError(@"album reader error: %@", error.userInfo);
             return;
         }
         [self openEditAdvancedWithController:controller result:result];
     }];
    
    [_albumComponent showComponent];
}

/**
 *  开启图片高级编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditAdvancedWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    if (!controller || !result) return;
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditComponent.html
    _photoEditComponent =
    [TuSDK photoEditCommponentWithController:controller
                               callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         [self upimagefengzhuang:result];
         [self clearComponents];
         // 获取图片失败
         if (error) {
             lsqLError(@"editAdvanced error: %@", error.userInfo);
             return;
         }
         [result logInfo];
     }];
    
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditOptions.html
    // _photoEditComponent.options
    
    //    // 图片编辑入口控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditEntryOptions.html
    // _photoEditComponent.options.editEntryOptions
    //    // 默认: true, 开启裁剪旋转功能
    //    _photoEditComponent.options.editEntryOptions.enableCuter = YES;
    //    // 默认: true, 开启滤镜功能
    //    _photoEditComponent.options.editEntryOptions.enableFilter = YES;
    //    // 默认: true, 开启贴纸功能
    //    _photoEditComponent.options.editEntryOptions.enableSticker = YES;
    //    // 最大输出图片按照设备屏幕 (默认:false, 如果设置了LimitSideSize, 将忽略LimitForScreen)
    //    _photoEditComponent.options.editEntryOptions.limitForScreen = YES;
    //    // 保存到系统相册
    //    _photoEditComponent.options.editEntryOptions.saveToAlbum = YES;
    //    // 控制器关闭后是否自动删除临时文件
    //    _photoEditComponent.options.editEntryOptions.isAutoRemoveTemp = YES;
    //
    //    // 图片编辑滤镜控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditFilterOptions.html
    // _photoEditComponent.options.editFilterOptions
    //    // 默认: true, 开启滤镜配置选项
    //    _photoEditComponent.options.editFilterOptions.enableFilterConfig = YES;
    //    // 是否仅返回滤镜，不返回处理图片(默认：false)
    //    _photoEditComponent.options.editFilterOptions.onlyReturnFilter = YES;
    //    // 滤镜列表行视图宽度
    //    _photoEditComponent.options.editFilterOptions.filterBarCellWidth = 75;
    //    // 滤镜列表选择栏高度
    //    _photoEditComponent.options.editFilterOptions.filterBarHeight = 100;
    //    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    //    _photoEditComponent.options.editFilterOptions.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    //    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    //    _photoEditComponent.options.editFilterOptions.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    //
    //    // 图片编辑裁切旋转控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditCuterOptions.html
    // _photoEditComponent.options.editCuterOptions
    //    // 是否开启图片旋转(默认: false)
    //    _photoEditComponent.options.editCuterOptions.enableTrun = YES;
    //    // 是否开启图片镜像(默认: false)
    //    _photoEditComponent.options.editCuterOptions.enableMirror = YES;
    //    // 裁剪比例 (默认:lsqRatioAll)
    //    _photoEditComponent.options.editCuterOptions.ratioType = lsqRatioAll;
    //    // 是否仅返回裁切参数，不返回处理图片
    //    _photoEditComponent.options.editCuterOptions.onlyReturnCuter = YES;
    //    // 本地贴纸选择控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFStickerLocalOptions.html
    // _photoEditComponent.options.stickerLocalOptions
    
    // 保存到系统相册
    _photoEditComponent.options.editEntryOptions.saveToAlbum = NO;
    //     控制器关闭后是否自动删除临时文件
    _photoEditComponent.options.editEntryOptions.isAutoRemoveTemp = YES;
    // 设置图片
    _photoEditComponent.inputImage = result.image;
    _photoEditComponent.inputTempFilePath = result.imagePath;
    _photoEditComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    [_photoEditComponent showComponent];
}

/**
 *  清楚所有控件
 */
- (void)clearComponents;
{
    // 自定义系统相册组件
    _albumComponent = nil;
    // 头像设置组件
    _avatarComponent = nil;
    // 图片编辑组件
    _photoEditComponent = nil;
}

- (void)upimagefengzhuang:(TuSDKResult * )result
{
    //UIImage *image = [self fullResolutionImageFromALAsset:result.imageAsset];
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    UIImage *image = result.image;
    CGSize imagesize = image.size;
    image = [self scaleToSize:image size:imagesize];
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //    {
    //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
    //        [self uploadPictureWithImageData:[self saveImageAndReturn:image WithName:uuid1]];
    //        imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"上传中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    if (imageNumber == 0) {
        uuid1 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView2.image = [UIImage imageNamed:@"fb_xj.png"];
        imageButton.frame = imageView2.frame;
        //            imageView1.del.hidden = NO;
    }
    if (imageNumber == 1) {
        uuid2 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView2.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView3.image = [UIImage imageNamed:@"fb_xj.png"];
        imageButton.frame = imageView3.frame;
        //            imageView2.del.hidden = NO;
    }
    if (imageNumber == 2) {
        uuid3 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView3.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView4.image = [UIImage imageNamed:@"fb_xj.png"];
        imageButton.frame = imageView4.frame;
        //            imageView3.del.hidden = NO;
    }
    if (imageNumber == 3) {
        uuid4 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView5.image = [UIImage imageNamed:@"fb_xj.png"];
        //            imageView4.del.hidden = NO;
    }
    if (imageNumber == 4) {
        uuid5 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView5.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView6.image = [UIImage imageNamed:@"fb_xj.png"];
        //            imageView5.del.hidden = NO;
    }
    if (imageNumber == 5) {
        uuid6 = [self uuid];
        [self saveImageAndReturn:image WithName:uuid1];
        [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
        [_bigImageArr addObject:image];
        [arr addObject:image];
        imageView6.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
        imageView7.image = [UIImage imageNamed:@"fb_xj.png"];
        //            imageView6.del.hidden = NO;
    }
    imageNumber += 1;
    camera = 1;
}



//初始化照片处理组件
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager;
{
    //    [self showHubSuccessWithStatus:LSQString(@"lsq_inited", @"初始化完成")];
}



#pragma mark ------ 调用系统相机 ------
- (void)cameraButton:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

- (void)goOnPublishButton:(id)sender
{
    myphotos = [NSMutableString stringWithFormat:@""];
    publishNum = 0;
    uploadnum = 0;
    camera = 0;
    imageNumber = 0;
    positionsign = @"1";
    imageSign = 0;
    
    _imageArr = [[NSMutableArray alloc]init];
    _bigImageArr = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    
    //    detailTV.text = @"";
    [self reloadImage];
    
    //    publishLater.hidden = YES;
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
