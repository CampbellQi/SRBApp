//
//  ChangeBuyViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ChangeBuyViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChangeLaterViewController.h"
#import "ShareViewController.h"
#import "HelpViewController.h"
#import <TuSDK/TuSDK.h>
#import "editViewController.h"
#import "SaleListViewController.h"
#import "WebHelpViewController.h"

@interface ChangeBuyViewController ()<UIActionSheetDelegate,CTAssetsPickerControllerDelegate,UIImagePickerControllerDelegate,ISSShareViewDelegate,TuSDKPFCameraDelegate, TuSDKPFEditTurnAndCutDelegate, TuSDKFilterManagerDelegate>
{
    int oldNum;
    DetailModel * newModel;
    UIButton * buttonType;
    UIView * createLocationView;    //是否发布足迹
    UIButton * locationBtn;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
}
@property (nonatomic ,strong)NSMutableArray * bigImageArr;
//@property (nonatomic, strong) NSDictionary *userInfoDic;
@end

@implementation ChangeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    // Do any additional setup after loading the view.
    if (_model.sortid == nil) {
        self.title = @"求真货";
    }else{
        self.title = @"修改信息";
    }
    //初始化用户信息字典
//    self.userInfoDic = [NSDictionary dictionary];
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 0, 110/2, 50/2);
    regBtn.backgroundColor = [UIColor whiteColor];
    regBtn.layer.masksToBounds = YES;
    regBtn.layer.cornerRadius = CGRectGetHeight(regBtn.frame)*0.5;
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn setTitle:@"发 布" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = 2;
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
    
    [self setMainView];
}

- (void)setMainView
{
    imageNumber = 0;
    imageSign = 0;
    publishNum = 0;
    postTime = 0;
    camera = 0;
    myphotos = [NSMutableString stringWithFormat:@""];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.2);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _imageArr = [[NSMutableArray alloc]init];
    _bigImageArr = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    imageNumber = 0;
    positionsign = @"1";
    _categoryID = _model.sortid;
    
    //    myphotos = _model.photos;
    if (_categoryID == nil) {
        
    }else{
        if (_model.photos.length == 0) {
            
        }else if (_model.photos.length < 120) {
            [_imageArr addObject:_model.photos];
        }else{
            _imageArr = [NSMutableArray arrayWithArray:[_model.photos componentsSeparatedByString:@","]];
        }
    }
    oldNum = 0;
    if (_model.photos.length != 0) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"获取信息,请稍后";
        HUD.dimBackground = YES;
        [HUD show:YES];
        for (int i = 0; i < _imageArr.count; i++) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:_imageArr[i] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                oldNum += 1;
                [_bigImageArr addObject:image];
                if (oldNum == _imageArr.count) {
                    [HUD removeFromSuperview];
                    [self setTheView];
                    [self.locMgr startUpdatingLocation];
                    
                    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                    tapGr.cancelsTouchesInView = NO;
                    [self.view addGestureRecognizer:tapGr];
                }
            }];
        }
    }else
    {
        [self setTheView];
        [self.locMgr startUpdatingLocation];
        
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGr];
    }
    PublishLaterView * publishLater = [[PublishLaterView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    AppDelegate * app = APPDELEGATE;
    [app.window addSubview:publishLater];
    publishLater.hidden = YES;
    self.publishLater = publishLater;
    [publishLater.lookNowButton addTarget:self action:@selector(lookNowButton:) forControlEvents:UIControlEventTouchUpInside];
    [publishLater.goOnPublishButton addTarget:self action:@selector(goOnPublishButton:) forControlEvents:UIControlEventTouchUpInside];
    [publishLater.shareButton addTarget:self action:@selector(shareRequest) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refresh
{
    self.publishLater.hidden = NO;
}

- (void)lookNowButton:(id)sender
{
    self.publishLater.hidden = YES;
    PublishLaterBackViewController * myAssureVC = [[PublishLaterBackViewController alloc]init];
    myAssureVC.idNumber = newModel.model_id;
    [self.navigationController pushViewController:myAssureVC animated:YES];
}

- (void)goOnPublishButton:(id)sender
{
    self.publishLater.hidden = YES;
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    [self setMainView];
}


- (void)shareButton:(id)sender
{
    NSString *content = [NSString stringWithFormat:@"%@ %@",newModel.content, newModel.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
    [ShareViewController shareToThirdPlatformWithUIViewController:self Account:newModel.account Nickname:newModel.nickname Avatar:newModel.avatar Cover:newModel.cover IdNumber:newModel.model_id Title:newModel.title  Content:content Photo:newModel.photos Btn:sender ShareUrl:_model.shareUrl];
}
#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 键盘弹出与收回的监听
- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect titleTTRect = [titleTT.superview convertRect:titleTT.frame toView:self.view];
    CGRect detailTVRect = [detailTV.superview convertRect:detailTV.frame toView:self.view];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    CGRect tempViewRect = self.scrollView.frame;
    if ([titleTT isFirstResponder]) {
        if ((titleTTRect.size.height + titleTTRect.origin.y) > keyboardRect.origin.y) {
            tempViewRect.origin.y -= (titleTTRect.size.height + titleTTRect.origin.y) - keyboardRect.origin.y;
        }
    }else{
        if ((detailTVRect.size.height + detailTVRect.origin.y) > keyboardRect.origin.y) {
            tempViewRect.origin.y -= (detailTVRect.size.height + detailTVRect.origin.y) - keyboardRect.origin.y;
        }
    }
    self.scrollView.frame = tempViewRect;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];

        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        // commit animations
        [UIView commitAnimations];
}

- (void)setTheView
{
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    [view1 addSubview: [self addPhoto]];
    [_scrollView addSubview:view1];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height + 20, SCREEN_WIDTH, 160)];
    [view2 addSubview:[self detail]];
    [_scrollView addSubview:view2];
    
    UIView * viewType = [[UIView alloc]initWithFrame:CGRectMake(0, view2.frame.origin.y + view2.frame.size.height + 20, SCREEN_WIDTH, 50)];
    [viewType addSubview:[self chooseType]];
    [_scrollView addSubview:viewType];
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, viewType.frame.origin.y + viewType.frame.size.height + 20, SCREEN_WIDTH, 80)];
    [view5 addSubview:[self position]];
    [_scrollView addSubview:view5];
    
    //是否分享到足迹的view
    createLocationView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view5.frame) + 20, SCREEN_WIDTH, 40)];
    createLocationView.backgroundColor = WHITE;
    createLocationView.hidden = YES;
    [_scrollView addSubview:createLocationView];
    
    //是否分享到足迹选择按钮
    locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.selected = NO;
    [locationBtn setImage:[UIImage imageNamed:@"not_choose"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"had_choose"] forState:UIControlStateSelected];
    [locationBtn addTarget:self action:@selector(shareLocation) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.frame = CGRectMake(15, 11, 19, 18);
    [createLocationView addSubview:locationBtn];
    
    UILabel * locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 200, 16)];
    locationLabel.font = SIZE_FOR_14;
    locationLabel.userInteractionEnabled = YES;
    locationLabel.text = @"分享到足迹";
    locationLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [createLocationView addSubview:locationLabel];
    UITapGestureRecognizer * locationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareLocation)];
    [locationLabel addGestureRecognizer:locationTap];
    
    UIImageView * smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view5.frame.origin.y + view5.frame.size.height + 18, 20, 10)];
    self.smallV = smallV;
    smallV.image = [UIImage imageNamed:@"notice"];
    [_scrollView addSubview:smallV];
    
    UIView * bigV = [[UIView alloc]initWithFrame:CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 114)];
    self.bigV = bigV;
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
    
    UILabel * smallL = [[UILabel alloc]initWithFrame:CGRectMake(10, bigL.frame.origin.y + bigL.frame.size.height + 8, bigV.frame.size.width - 15, 75)];
    smallL.text = @"在这不允许发广告，添加微信、QQ等个人信息的文字和图片，不允许发同样的内容！\n发现违规信息，小邦会立即删除，严重者会被禁言拉黑。\nps:点头像可以进入个人主页的哟，么么哒";
    smallL.numberOfLines = 0;
    smallL.textColor = [UIColor whiteColor];
    smallL.font = [UIFont systemFontOfSize:12];
    [bigV addSubview:smallL];
    
    if (_model.sortid == nil) {
        createLocationView.hidden = NO;
        self.smallV.frame = CGRectMake(24, CGRectGetMaxY(createLocationView.frame) + 18, 20, 10);
    }else{
        createLocationView.hidden = YES;
        self.smallV = [[UIImageView alloc]initWithFrame:CGRectMake(24, view5.frame.origin.y + view5.frame.size.height + 18, 20, 10)];
    }
    self.bigV.frame = CGRectMake(15, smallV.frame.origin.y + smallV.frame.size.height , SCREEN_WIDTH - 30, 114);
    
//    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130,self.bigV.frame.size.height + self.bigV.frame.origin.y + 5, 115, 14)];
//    [button setTitle:@"查看更多帮助 >>" forState:UIControlStateNormal];
//    [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(askHelp) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = SIZE_FOR_14;
//    [_scrollView addSubview:button];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bigV.frame.origin.y + bigV.frame.size.height + 10);
    
}

- (void)askHelp
{
    HelpViewController * vc = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)chooseType
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 70, 16)];
    label.text = @"商品类目";
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 5, 1, 40)];
    label1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label1];
    
    buttonType = [[UIButton alloc]initWithFrame:CGRectMake(label1.frame.origin.x , thingTitle.frame.origin.y , 80, 16)];
    if (_categoryID == nil) {
        [buttonType setTitle:@"请选择" forState:UIControlStateNormal];
    }else{
        [buttonType setTitle:_model.sortName forState:UIControlStateNormal];
    }
    buttonType.titleLabel.font = SIZE_FOR_IPHONE;
    [buttonType addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
    [buttonType setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view addSubview:buttonType];
    
    UIImageView * detailImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 8, 20, 5, 10)];
    detailImg.image = [UIImage imageNamed:@"friendnew_jt"];
    [view addSubview:detailImg];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choose)];
    [view addGestureRecognizer:tap];
    
    return view;
}

#pragma mark - 是否分享到足迹
- (void)shareLocation
{
    locationBtn.selected = !locationBtn.selected;
}

- (void)choose
{
    SaleListViewController * vc = [[SaleListViewController alloc]init];
    vc.theSign = @"买";
    [vc sendMessage:^(id result1, id result2) {
        [buttonType setTitle:result2 forState:UIControlStateNormal];
        self.categoryID = result1;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [detailTV resignFirstResponder];
    [titleTT resignFirstResponder];
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

- (UIView *)position
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 33, 40, 16)];
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
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
//    positionLB.text = self.detailAddress;
    positionLB.font = [UIFont systemFontOfSize:12];
    positionLB.numberOfLines = 0;
    [theView addSubview:positionLB];
    
    UIButton * button = [[UIButton alloc]initWithFrame:theView.frame];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(findPosition) forControlEvents:UIControlEventTouchUpInside];
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

- (void)backBtn:(id)sender
{

    if (detailTV.text.length == 0 && _imageArr.count == 0 && titleTT.text.length == 0 ) {
        [self.navigationController dismissViewController];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }

}
//附近位置
- (void)findPosition
{
    NearbyLocationsViewController *nearbyLocationVC = [[NearbyLocationsViewController alloc] init];
    [nearbyLocationVC position:^(NSString *position,NSDictionary *location) {
        positionLB.text = position;
        self.detailAddress = position;
        self.latitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lat"]];
        self.longitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lng"]];
    }];
    nearbyLocationVC.lat = self.latitudeHad;
    nearbyLocationVC.lon = self.longitudeHad;
    nearbyLocationVC.address = self.detailAddress;

    ZZNavigationController *zzNav = [[ZZNavigationController alloc] initWithRootViewController:nearbyLocationVC];
    [self presentViewController:zzNav animated:YES completion:nil];
}

- (void)buttonNext:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
        [titleTT resignFirstResponder];
        [detailTV becomeFirstResponder];
    }
}

- (void)buttonBack:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 2) {
        [detailTV resignFirstResponder];
        [titleTT becomeFirstResponder];
    }
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
        [titleTT resignFirstResponder];
    }
    if (button.tag == 2) {
        [detailTV resignFirstResponder];
    }
}


- (void)lookPosition
{
    if ([positionsign isEqualToString:@"0"]) {
//        CALayer *layer=[theView layer];
//        //是否设置边框以及是否可见
//        [layer setMasksToBounds:YES];
//        //设置边框圆角的弧度
//        [layer setCornerRadius:10.0];
//        //设置边框线的宽
//        [layer setBorderWidth:1];
//        //设置边框线的颜色
//        [layer setBorderColor:[[UIColor colorWithRed:0.94 green:0.63 blue:0.71 alpha:1] CGColor]];
        positionLB.hidden = NO;
        positionsign = @"1";
        [positionbutton setTitle:@"点击隐藏位置" forState:UIControlStateNormal];
        chooseImage.image = [UIImage imageNamed: @"location_selected.png"];
    }
    else{
//        CALayer *layer=[theView layer];
//        //是否设置边框以及是否可见
//        [layer setMasksToBounds:YES];
//        //设置边框圆角的弧度
//        [layer setCornerRadius:10.0];
//        //设置边框线的宽
//        [layer setBorderWidth:1];
//        //设置边框线的颜色
//        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
        positionLB.hidden = YES;
        positionsign = @"0";
        [positionbutton setTitle:@"点击添加位置" forState:UIControlStateNormal];
        chooseImage.image = [UIImage imageNamed: @"ad_dui.png"];
    }
}


- (UIView *)detail
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    view.backgroundColor = [UIColor whiteColor];
    
    thingTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 70, 16)];
    thingTitle.text = @"宝贝标题";
    thingTitle.textColor = [GetColor16 hexStringToColor:@"#434343"];
    thingTitle.font = SIZE_FOR_IPHONE;
    [view addSubview:thingTitle];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(thingTitle.frame.origin.x + thingTitle.frame.size.width + 5, 5, 1, 40)];
    label.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label];
    
    titleTT = [[UITextField alloc]initWithFrame:CGRectMake(label.frame.origin.x + 10, thingTitle.frame.origin.y - 5, SCREEN_WIDTH -label.frame.origin.x - 15, 30)];
    titleTT.delegate = self;
    titleTT.placeholder = @"(必填,6-30个字)填写宝贝品牌和名称";
    titleTT.returnKeyType = UIReturnKeyDone;
    [titleTT setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    if (_categoryID == nil) {
        titleTT.text = @"";
    }else{
        titleTT.text = _model.title;
    }
    [titleTT setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
    FinishView * finishiView1 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView1.buttonFinish.tag = 1;
    finishiView1.buttonBack.tag = 1;
    finishiView1.buttonNext.tag = 1;
    [finishiView1.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView1.buttonBack setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    titleTT.inputAccessoryView = finishiView1;
    
    [view addSubview:titleTT];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height + 5, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [view addSubview:breakView];
    
    thingDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 70, 16)];
    thingDetail.text = @"宝贝要求";
    thingDetail.textColor = [GetColor16 hexStringToColor:@"#434343"];
    thingDetail.font = SIZE_FOR_IPHONE;
    [view addSubview:thingDetail];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(thingDetail.frame.origin.x + thingDetail.frame.size.width + 5, label.frame.origin.y + label.frame.size.height + 10, 1, 100)];
    label1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [view addSubview:label1];
    
    detailTV = [[UITextView alloc]initWithFrame:CGRectMake(label.frame.origin.x + 5, thingDetail.frame.origin.y - 10 , titleTT.frame.size.width, 70)];
    detailTV.keyboardType = UIKeyboardAppearanceDefault;
    detailTV.returnKeyType = UIReturnKeyDone;
    detailTV.delegate = self;
    detailTV.textColor = [GetColor16 hexStringToColor:@"#434343"];//设置textview里面的字体颜色
    detailTV.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
    detailTV.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    detailTV.returnKeyType = UIReturnKeyDefault;//返回键的类型
    detailTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    detailTV.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    if (_categoryID == nil) {
        detailTV.text = @"";
    }else{
        detailTV.text = _model.content;
    }
    FinishView * finishiView2 = [[FinishView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 30)];
    finishiView2.buttonFinish.tag = 2;
    finishiView2.buttonBack.tag = 2;
    finishiView2.buttonNext.tag = 2;
    [finishiView2.buttonNext addTarget:self action:@selector(buttonNext:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonBack addTarget:self action:@selector(buttonBack:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonFinish addTarget:self action:@selector(buttonFinish:) forControlEvents:UIControlEventTouchUpInside];
    [finishiView2.buttonNext setTitleColor:[UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:1] forState:UIControlStateNormal];
    detailTV.inputAccessoryView = finishiView2;
    
    [view addSubview: detailTV];//加入到整个页面中
    
    if (_categoryID == nil) {
        labeltext = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x + 8, thingDetail.frame.origin.y , SCREEN_WIDTH, 14)];
        labeltext.text = @"(必填)介绍一下宝贝要求";
        labeltext.font = [UIFont systemFontOfSize:14];
        [labeltext setTextColor:[GetColor16 hexStringToColor:@"#c9c9c9"]];
        [view addSubview:labeltext];
    }else{
        
    }
    return view;
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
    NSString *textString = textView.text;
    NSUInteger length = [textString length];
    BOOL bChange =YES;
    if (length >= 800)
        bChange = NO;
    
    if (range.length == 1) {
        bChange = YES;
    }
    
    return bChange;
    return YES;
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
    //    UITapGestureRecognizer *pLongPress7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress7:)];
    //    pLongPress7.delegate = self;
    //    pLongPress7.numberOfTapsRequired = 1;
    //    [imageView4 addGestureRecognizer:pLongPress7];
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
        imageView1.image = _bigImageArr[0];
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
        imageView1.image = _bigImageArr[0];
        imageView2.image = _bigImageArr[1];
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
        imageView1.image = _bigImageArr[0];
        imageView2.image = _bigImageArr[1];
        imageView3.image = _bigImageArr[2];
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
        imageView1.image = _bigImageArr[0];
        imageView2.image = _bigImageArr[1];
        imageView3.image = _bigImageArr[2];
        imageView4.image = _bigImageArr[3];
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
        imageView1.image = _bigImageArr[0];
        imageView2.image = _bigImageArr[1];
        imageView3.image = _bigImageArr[2];
        imageView4.image = _bigImageArr[3];
        imageView5.image = _bigImageArr[4];
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
        imageView1.image = _bigImageArr[0];
        imageView2.image = _bigImageArr[1];
        imageView3.image = _bigImageArr[2];
        imageView4.image = _bigImageArr[3];
        imageView5.image = _bigImageArr[4];
        imageView6.image = _bigImageArr[5];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            if (_model.sortid == nil) {
                [self.navigationController dismissViewController];
            }else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        if (buttonIndex == 1) {
            if (imageSign == 1) {
                [_imageArr removeObjectAtIndex:0];
                [_bigImageArr removeObjectAtIndex:0];
                imageNumber -= 1;
                [arr removeObjectAtIndex:0];
                uploadnum = uploadnum - 1;
                [self reloadImage];
            }else if (imageSign == 2) {
                [_imageArr removeObjectAtIndex:1];
                [_bigImageArr removeObjectAtIndex:1];
                [arr removeObjectAtIndex:1];
                uploadnum = uploadnum - 1;
                imageNumber -= 1;
                [self reloadImage];
            }else if (imageSign == 3) {
                [_imageArr removeObjectAtIndex:2];
                [_bigImageArr removeObjectAtIndex:2];
                [arr removeObjectAtIndex:2];
                uploadnum = uploadnum - 1;
                imageNumber -= 1;
                [self reloadImage];
            }else if (imageSign == 4) {
                [_imageArr removeObjectAtIndex:3];
                [_bigImageArr removeObjectAtIndex:3];
                [arr removeObjectAtIndex:3];
                uploadnum = uploadnum - 1;
                imageNumber -= 1;
                [self reloadImage];
            }
            else if (imageSign == 5) {
                [_imageArr removeObjectAtIndex:4];
                [_bigImageArr removeObjectAtIndex:4];
                [arr removeObjectAtIndex:4];
                uploadnum = uploadnum - 1;
                imageNumber -= 1;
                [self reloadImage];
            }
            else if (imageSign == 6) {
                [_imageArr removeObjectAtIndex:5];
                [_bigImageArr removeObjectAtIndex:5];
                [arr removeObjectAtIndex:5];
                uploadnum = uploadnum - 1;
                imageNumber -= 1;
                [self reloadImage];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    [controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
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
    UIImage *image = result.image;
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
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
- (void)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
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
                //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                //                picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                //                picker.allowsEditing = NO;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                //                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                //                [self presentViewController:picker animated:YES completion:nil];
                [self cameraComponentHandler];
            }
            break;
        }
//        case 2:
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
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assetses
{
    if (assetses.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (!arr) {
        arr = [NSMutableArray arrayWithArray:assetses];
    }else{
        if (uploadnum < imageNumber) {
            arr = [NSMutableArray arrayWithArray:assetses];
        }else{
            [arr addObjectsFromArray:assetses];
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
            UIImage * image = image1;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            //设置image的尺寸
            CGSize imagesize = image1.size;
            image1 = [self scaleToSize:image1 size:imagesize];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image1,0.3)];
            uploadnum = 1;
        }
        if (uploadnum == 1 && imageNumber == 1 ) {
            ALAsset *asset = arr[1];
            image2 = [[UIImage alloc]init];
            image2 = [self fullResolutionImageFromALAsset:asset];
            UIImage * image = image2;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image2.size;
            image2 = [self scaleToSize:image2 size:imagesize];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image2, 0.3)];
            uploadnum = 2;
        }
        if (uploadnum == 2 && imageNumber == 2) {
            ALAsset *asset = arr[2];
            image3 = [[UIImage alloc]init];
            image3 = [self fullResolutionImageFromALAsset:asset];
            UIImage * image = image3;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image3.size;
            image3 = [self scaleToSize:image3 size:imagesize];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image3, 0.3)];
            uploadnum = 3;
        }
        if (uploadnum == 3 && imageNumber == 3) {
            ALAsset *asset = arr[3];
            image4 = [[UIImage alloc]init];
            image4 = [self fullResolutionImageFromALAsset:asset];
            UIImage * image = image4;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image4.size;
            image4 = [self scaleToSize:image4 size:imagesize];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image4, 0.3)];
            uploadnum = 4;
        }
        if (uploadnum == 4 && imageNumber == 4) {
            ALAsset *asset = arr[4];
            image5 = [[UIImage alloc]init];
            image5 = [self fullResolutionImageFromALAsset:asset];
            UIImage * image = image5;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image5.size;
            image5 = [self scaleToSize:image5 size:imagesize];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image5, 0.3)];
            uploadnum = 5;
        }
        if (uploadnum == 5 && imageNumber == 5) {
            ALAsset *asset = arr[5];
            image6 = [[UIImage alloc]init];
            image6 = [self fullResolutionImageFromALAsset:asset];
            UIImage * image = image6;
            [_bigImageArr addObject:image];
            uuid1 = [self uuid];
            CGSize imagesize = image6.size;
            image6 = [self scaleToSize:image6 size:imagesize];
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
            imageView4.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView5.image = [UIImage imageNamed:@"fb_xj.png"];
//            imageView4.del.hidden = NO;
        }
        if (imageNumber == 4) {
            uuid5 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
            imageView5.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView6.image = [UIImage imageNamed:@"fb_xj.png"];
//            imageView5.del.hidden = NO;
        }
        if (imageNumber == 5) {
            uuid6 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
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
            imageView5.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
            imageView6.image = [UIImage imageNamed:@"fb_xj.png"];
//            imageView5.del.hidden = NO;
        }
        if (imageNumber == 5) {
            uuid6 = [self uuid];
            [self saveImageAndReturn:image WithName:uuid1];
            [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
            [_bigImageArr addObject:image];
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
        //        NSMutableString *String1 = [[NSMutableString alloc] initWithString:str];
        //        [String1 insertString:@"," atIndex:0];
        //        NSString * string2 = [[NSString alloc]initWithString:String1];
        //        [myphotos appendFormat:string2];
        [_imageArr addObject:str];
        [self reloadImage];
//        [AutoDismissAlert autoDismissAlert:@"上传成功"];
        
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if ([string isEqualToString:@"\n"]){
        
        return YES;
        
    }
    
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (titleTT == textField)
        
    {
        
        if ([aString length] > 30) {
            
            textField.text = [aString substringToIndex:30];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                  
                                                            message:@"超过最大字数限制"
                                  
                                                           delegate:nil
                                  
                                                  cancelButtonTitle:@"知道了"
                                  
                                                  otherButtonTitles:nil, nil];
            
            [alert show];
            
            return NO;
            
        }
    }
    return YES;
}
//post请求
- (void)post
{
    [titleTT resignFirstResponder];
    [detailTV resignFirstResponder];

    postTime += 1;
    
    NSString * titleStr = [titleTT.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSDictionary * guarantorDic = self.toSellerModel.guarantor;
    if ([titleStr isEqualToString:@""] || titleStr.length == 0 || titleStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请填写宝贝标题"];
        postTime = 0;
        publishNum = 0;
        [titleTT becomeFirstResponder];
        return;
    }

    NSString * detailStr = [detailTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        NSDictionary * guarantorDic = self.toSellerModel.guarantor;
    if ([detailStr isEqualToString:@""] || detailStr.length == 0 || detailStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请填写宝贝要求"];
        postTime = 0;
        publishNum = 0;
        [detailTV becomeFirstResponder];
        return;
    }
    
    
    if (self.categoryID.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请选择宝贝分类"];
        publishNum = 0;
        postTime = 0;
        return;
    }
    if (titleStr.length < 6 || titleStr.length > 30) {
        [AutoDismissAlert autoDismissAlert:@"宝贝标题须在6-30字"];
        [titleTT becomeFirstResponder];
        publishNum = 0;
        postTime = 0;
        return;
    }
    if (detailStr.length < 10 ||detailStr.length > 800) {
        [AutoDismissAlert autoDismissAlert:@"宝贝要求须在10-800字"];
        [detailTV becomeFirstResponder];
        publishNum = 0;
        postTime = 0;
        return;
    }
    if (postTime == 1) {
        theStr = [[NSMutableString alloc]init];
        myphotos = [[NSMutableString alloc]init];
        for (int i = 0; i < _imageArr.count; i++) {
            NSMutableString *String1 = [[NSMutableString alloc] initWithString:_imageArr[i]];
            [String1 insertString:@"," atIndex:0];
            NSString * string2 = [[NSString alloc]initWithString:String1];
            [myphotos appendString:string2];
        }
        if (myphotos.length < 1) {
            theStr = @"0";
        }else
        {
            [myphotos deleteCharactersInRange:NSMakeRange(0, 1)];
            theStr = myphotos;
        }
    }
    
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"发布中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];

    NSString * xyz = [NSString stringWithFormat:@"%@,%@", self.latitude,self.longitude];

    if ([self.latitude isEqualToString:@""] || self.latitude.length == 0 || self.latitude == nil) {
        xyz = [NSString stringWithFormat:@"%@,%@", self.latitudeHad,self.longitudeHad];
    }
    NSString * position = self.detailAddress;
    if (position.length == 0) {
        positionsign = @"0";
    }
    if (_model.sortid == nil) {
        NSString * isShareToLocation;
        if (locationBtn.selected == YES) {
            isShareToLocation = @"1";
        }else{
            isShareToLocation = @"0";
        }
        if ([positionsign isEqualToString:@"1"]) {
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"2", @"originalPrice":@"0", @"marketPrice":@"0", @"transportPrice":@"100", @"freeShipment":@"0", @"xyz":xyz, @"position":position, @"city":_city, @"positionView":@"1", @"photos":theStr, @"title":titleStr, @"content":detailStr, @"storage":@"0", @"guaranteeAllow":@"0", @"guaranteePrice":@"5", @"uuid":@"0", @"categoryID":_categoryID,@"share":isShareToLocation}];
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    NSDictionary * tempdic = [dic objectForKey:@"data"];
                    newModel = [[DetailModel alloc]init];
                    [newModel setValuesForKeysWithDictionary:tempdic];
                    self.publishLater.hidden = NO;
                }else{
                    NSLog(@"%d", result);
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                    //            imageview.center = tableView2.center;
                }
                [HUD removeFromSuperview];
                publishNum = 0;
                postTime = 0;
            }];
        }else {
            NSDictionary * dic = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"2", @"originalPrice":@"0", @"marketPrice":@"0", @"transportPrice":@"100", @"freeShipment":@"0", @"xyz":@"0", @"position":@"0", @"city":@"0", @"positionView":@"0", @"photos":theStr, @"title":titleTT.text, @"content":detailTV.text, @"storage":@"0",  @"guaranteeAllow":@"0", @"guaranteePrice":@"5", @"uuid":@"0", @"categoryID":_categoryID,@"share":isShareToLocation}];
            
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    NSDictionary * tempdic = [dic objectForKey:@"data"];
                    newModel = [[DetailModel alloc]init];
                    [newModel setValuesForKeysWithDictionary:tempdic];
                    self.publishLater.hidden = NO;
                    
                }else{
                    NSLog(@"%d", result);
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                }
                publishNum = 0;
                postTime = 0;
                [HUD removeFromSuperview];
            }];
        }

    }else{
    if ([positionsign isEqualToString:@"1"]) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountUpdatePost" parameters:@{ACCOUNT_PASSWORD,@"id":_model.model_id, @"dealType":@"2", @"originalPrice":@"0", @"transportPrice":@"0", @"xyz":xyz,@"position":position,@"photos":theStr, @"title":titleTT.text, @"content":detailTV.text, @"guaranteeAllow":@"0", @"guaranteePrice":@"0",@"uuid":@"0",@"freeShipment":@"0"}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [AutoDismissAlert autoDismissAlert:@"修改成功"];
                [self.notPublishVC urlRequestPost];
                NSDictionary * tempdic = [dic objectForKey:@"data"];
                newModel = [[DetailModel alloc]init];
                [newModel setValuesForKeysWithDictionary:tempdic];
                [self changeNext];
//                MyPublishViewController * vc = [[MyPublishViewController alloc]init];
//                vc.dealType = @"2";
//                vc.thedealType = @"2";
//                vc.notPublishType = @"1";
//                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"%d", result);
                [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                //            imageview.center = tableView2.center;
            }
            publishNum = 0;
            postTime = 0;
            [HUD removeFromSuperview];
        }];
    }else {
        NSDictionary * dic = [self parametersForDic:@"accountUpdatePost" parameters:@{ACCOUNT_PASSWORD,@"id":_model.model_id, @"dealType":@"2", @"originalPrice":@"0", @"transportPrice":@"0", @"xyz":@"0",@"position":@"0",@"photos":theStr, @"title":titleTT.text, @"content":detailTV.text, @"guaranteeAllow":@"0", @"guaranteePrice":@"0",@"uuid":@"0",@"freeShipment":@"0"}];
        
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [AutoDismissAlert autoDismissAlert:@"修改成功"];
                [self.notPublishVC urlRequestPost];
                NSDictionary * tempdic = [dic objectForKey:@"data"];
                newModel = [[DetailModel alloc]init];
                [newModel setValuesForKeysWithDictionary:tempdic];
                [self changeNext];
            }else{
                NSLog(@"%d", result);
                [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
            }
            publishNum = 0;
            postTime = 0;
            [HUD removeFromSuperview];
        }];
    }
    }
}

- (void)changeNext
{
    ChangeLaterViewController * vc = [[ChangeLaterViewController alloc]init];
    vc.idNumber = newModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)regController:(id)sender
{
    publishNum += 1;
    if (publishNum == 1) {
        [self post];
    }
}

#pragma mark - post请求

- (void)shareRequest
{
    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":newModel.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [newModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self shareButton:self.publishLater.shareButton];
            
        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
    }];
}


- (CLLocationManager *)locMgr
{
    // 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
//        self.locMgr.distanceFilter = 10.0;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置代理
        self.locMgr.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            [self.locMgr requestAlwaysAuthorization];//永久
            [self.locMgr requestWhenInUseAuthorization];//使用中
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
                         
                         self.latitudeHad = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         self.longitudeHad = [NSString stringWithFormat:@"%f",coordinate.longitude];
                         self.city = [dict objectForKey:@"State"];
                         NSString *SubLocality = [dict objectForKey:@"SubLocality"];
                         NSString *Street = [dict objectForKey:@"Street"];
                         if (Street == nil) {
                             Street = @"";
                         }
                         NSString *address = [self.city stringByAppendingString:SubLocality];
                         if (_city == nil) {
                             _city = @"";
                         }
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
