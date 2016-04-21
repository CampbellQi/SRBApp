//
//  MineFragmentViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MineFragmentViewController.h"
#import "MineFragmentView.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "ZZNavigationController.h"
#import "MyPublishViewController.h"
#import "ZZMyOrderViewController.h"
#import "MyWalletActivityViewController.h"
#import "MyChatListViewController.h"
#import "SellerManagementViewController.h"
#import "OptionViewController.h"
#import "MyAssureViewController.h"
#import "NewAttentionViewController.h"
#import "BrowsingHistoryViewController.h"
#import "OptionViewController.h"
#import "SubclassIdSafeViewController.h"
#import "AppDelegate.h"

#import "BuyManagementViewController.h"
#import "GuatanteeManagementViewController.h"
#import "DownMineCell.h"
#import "MJRefresh.h"
#import "NewsCenterViewController.h"
#import "SubRegViewController.h"
#import "AllEvaluationsViewController.h"
#import <TuSDK/TuSDK.h>
#import "SubViewController.h"
#import "OrderDetailController.h"
#import "PersonalSPController.h"
#import "PersonalHelpSPController.h"

static NSString * youString = @"456";

@interface MineFragmentViewController ()<UITableViewDataSource, UITableViewDelegate,TuSDKPFCameraDelegate, TuSDKPFEditTurnAndCutDelegate, TuSDKFilterManagerDelegate>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong) NSString *userqrcode;//二维码
@end

@implementation MineFragmentViewController
{
    UIView * backView;
    UIImageView * logoImg;
    UILabel * nameLabel;
    UILabel * signLabel;
    UILabel * accountLabel;
    //=====靠谱
    UILabel * kaopuLabel;
    UIView * kaopuView;
    UIView * kaopuManyView;
    UILabel * kaopuBaifenbiLabel;
    //======忽悠
    UILabel * huyouLabel;
    UIView * huyouView;
    UIView * huyouManyView;
    UILabel * huyouBaifenbiLabel;
    
    //担保 订单
    MineFragmentView * danAndOrder;
    //钱包 评价
    MineFragmentView * qianAndComment;
    //发布 聊天
    MineFragmentView * fabuAndChat;
    //收藏 历史
    MineFragmentView * shouAndHistory;
    
    //个人信息字典
    NSDictionary * userDic;
    //买家管理
    UIView * buyerView;
    //卖家管理
    UIView * sellerView;
    //担保人管理
    UIView * guaranteeView;
    //我的钱包
    UIView * walletView;
    UIScrollView * mainScroll;
    
    UILabel * collectNum;
    UILabel * historyNum;
    UILabel * runNum;
    
    UIActivityIndicatorView * activity;
    
    UIImageView * backImage;
    
    UIActionSheet * actionSheets;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
    NSString * uuidStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    // Do any additional setup after loading the view.
    self.title = @"我 的";
    userDic = [NSDictionary dictionary];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"wd_sz"] forState:UIControlStateNormal];
    settingBtn.frame = CGRectMake(0, 0, 25, 25);
    [settingBtn addTarget:self action:@selector(MySetting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRun) name:@"notReadNews" object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = [self customHeaderView];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.view addSubview:_tableView];
    
    
    
    
//    [self createLogin];
//    //判断是否是游客
//    NSString *account= [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//    
//    if ([account isEqualToString:GUEST]) {
//        self.guestVC.view.hidden = NO;
//    }
    
    
}

//- (void)createLogin
//{
//    self.guestVC = [[GuestLoginViewController alloc] initWithSign:MY_SGIN ViewController:self];
//    [self.guestVC.regBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
//    [self.guestVC.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    [self addChildViewController:self.guestVC];
//    [self.view addSubview:self.guestVC.view];
//    self.guestVC.view.hidden = YES;
//}

////注册
//- (void)regist:(UIButton *)sender
//{
//    SubRegViewController *regVC = [[SubRegViewController alloc] init];
//    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:regVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}
//
////登录
//- (void)login:(UIButton *)sender
//{
//    LoginViewController *loginVC =[[LoginViewController alloc] init];
//    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:nil];
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
//        self.guestVC.view.hidden = NO;
//    }else{
//        self.guestVC.view.hidden = YES;
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] isEqualToString:GUEST]) {
        [self post];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownMineCell * cell = [[DownMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //cell.imageview.image = [UIImage imageNamed:@"buyguanli"];
//            cell.label.text = @"我是买家";
//            cell.signLabel.text = @"付款、收货、评价 > ";
            cell.imageview.image = [UIImage imageNamed:@"mf_sp"];
            cell.label.text = @"我的求购";
        }
        if (indexPath.row == 1) {
            //cell.imageview.image = [UIImage imageNamed:@"saleguanli"];
//            cell.label.text = @"我是卖家";
//            cell.signLabel.text = @"发货、退款、评价 > ";
            cell.imageview.image = [UIImage imageNamed:@"mf_hsp"];
            cell.label.text = @"我的代购";
        }
//        if (indexPath.row == 2) {
//            cell.imageview.image = [UIImage imageNamed:@"danbaorenguanli"];
//            cell.label.text = @"我是担保人";
//            cell.signLabel.text = @"记录、评价 > ";
//        }
        return cell;
    }
    if (indexPath.section == 1) {
        //cell.imageview.image = [UIImage imageNamed:@"wodeqianbao"];
//        cell.label.text = @"我的钱包";
//        cell.signLabel.text = @"充值、提现 > ";
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.imageview.image = [UIImage imageNamed:@"mf_walllet"];
        cell.label.text = @"我的钱包";
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //我的求购
//            BuyManagementViewController * vc = [[BuyManagementViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            PersonalSPController *vc = [[PersonalSPController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            //我的代购
//            SellerManagementViewController * sellerManagementVC = [[SellerManagementViewController alloc]init];
//            [self.navigationController pushViewController:sellerManagementVC animated:YES];
            
            PersonalHelpSPController *vc = [[PersonalHelpSPController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        if (indexPath.row == 2) {
//            GuatanteeManagementViewController * myAttentionVC = [[GuatanteeManagementViewController alloc]init];
//            [self.navigationController pushViewController:myAttentionVC animated:YES];
//        }
    }
    if (indexPath.section == 1) {
        //我的钱包
        MyWalletActivityViewController * vc = [[MyWalletActivityViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)reloadPost
{
    [self post];
}

- (void)makeChangeToHeaderView
{
    [logoImg sd_setImageWithURL:[userDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    logoImg.contentMode = UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds = YES;
    nameLabel.text = [userDic objectForKey:@"nickname"];
    accountLabel.text = [NSString stringWithFormat:@"%@", [userDic objectForKey:@"account"]];
//    signLabel.text = [userDic objectForKey:@"sign"];
    kaopuBaifenbiLabel.text = [NSString stringWithFormat:@"%@%%",[userDic objectForKey:@"evaluationper"]];
    huyouBaifenbiLabel.text = [NSString stringWithFormat:@"%@%%",[userDic objectForKey:@"fakeper"]];
    CGFloat width = [[userDic objectForKey:@"evaluationper"]floatValue] * (70.0 / 100.0);
    CGFloat huyouWidth = [[userDic objectForKey:@"fakeper"]floatValue] * (70.0/100.0);
    kaopuManyView.frame = CGRectMake(0, 0, width, 12);
    huyouManyView.frame = CGRectMake(0, 0, huyouWidth, 12);
}

#pragma mark ------ 调用系统相机 ------
- (void)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"还原默认背景",@"拍照", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"打开系统图片库");
                ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                
                if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
                    
                {
                    //无权限
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置 → 隐私 → 照片”中 ,允许熟人邦访问你的相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                else{
                    [self editAdvancedComponentHandler];
                }
                break;
                //            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                //                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                //                picker.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"e5005d"];
                //                picker.delegate = self;
                //                picker.allowsEditing = YES;//是否可以对原图进行编辑
                //
                //                //打开相册选择照片
                //                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //                [self presentViewController:picker animated:YES completion:nil];
                //            }
                //            else{
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"图片库不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [alertView show];
                //            }
                break;
            }
            case 1:
            {
                [self postFacePic:@"0"];
                //            self.imageButton.alpha =;
                break;
            }
            case 2:
            {
                NSLog(@"打开系统照相机");
                //            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                //                picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                //                picker.allowsEditing = YES;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                //                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                //                [self presentViewController:picker animated:YES completion:nil];
                //            }
                //            else{
                //                //如果当前设备没有摄像头
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"哎呀，当前设备没有摄像头。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                //                [alertView show];
                //            }
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
                
            default:
                break;
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
    opt.outputSize = CGSizeMake(1440, 1920);
    
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
    UIImage *image = result.image;
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    //    CGSize imagesize = image.size;
    //    image = [self scaleToSize:image size:imagesize];
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //    {
    //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
    //        [self uploadPictureWithImageData:[self saveImageAndReturn:image WithName:uuid1]];
    //        imageView1.image = [self scaleToSize:image size:CGSizeMake(75, 75)];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"上传中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
    //        self.imageView.image = [self scaleToSize:image size:CGSizeMake(400, 400)];
    //        UIImage * image1 = image;
    //        self.imageView.image = image1;
//    self.imageButton.alpha = 1;
    //    [self.imageButton setImage:image forState:UIControlStateNormal];
    //    imageButton.contentMode = UIViewContentModeScaleAspectFill;
    //    imageButton.clipsToBounds = YES;
    backImage.image = image;
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
    [self uploadPictureWithImageData:UIImageJPEGRepresentation(image, 0.3)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//初始化照片处理组件
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager;
{
    //    [self showHubSuccessWithStatus:LSQString(@"lsq_inited", @"初始化完成")];
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


//#pragma mark - UIImagePickerControllerDelegate
//#pragma mark - 拍照/选择图片结束
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
//    //获取图片
//    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
//    uuidstr = [self uuid];
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
////        self.imageView.image = [self scaleToSize:image size:CGSizeMake(400, 400)];
////        UIImage * image1 = image;
////        self.imageView.image = image1;
//        self.imageButton.alpha = 1;
//        [self.imageButton setImage:image forState:UIControlStateNormal];
//        [self uploadPictureWithImageData:[self saveImageAndReturn:[self scaleToSize:image size:CGSizeMake(400, 400)] WithName:uuidstr]];
//    }else{
////        self.imageView.image = [self scaleToSize:image size:CGSizeMake(400, 400)];
////        UIImage * image1 = image;
////        self.imageView.image = image1;
//        self.imageButton.alpha = 1;
//        [self.imageButton setImage:image forState:UIControlStateNormal];
//        [self uploadPictureWithImageData:[self saveImageAndReturn:[self scaleToSize:image size:CGSizeMake(400, 400)] WithName:uuidstr]];
//
//    }
//
//    [self dismissViewControllerAnimated:YES completion:nil];
////    [self.navigationController popViewControllerAnimated:YES];
//
//}

//- (void)upload
//{
//    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),uuidstr];
//}

#pragma mark - post请求
- (void)postFacePic:(NSString *)str
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetBackground" parameters:@{ACCOUNT_PASSWORD, @"url":str, @"uuid":@"0"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
//            if([str  isEqual: @"0"])
//            {
//                [backImage setImage:[UIImage imageNamed:@"bg.png"]];
//            }
//            else{
//                [backImage sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"userbackground"]]];
//            }
            [self post];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"avatar"];
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        
    }];
}

-(void)uploadPictureWithImageData:(NSData *)imageData{
    //    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.labelText = @"上传中,请稍后";
    //    HUD.dimBackground = YES;
    //    [HUD show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"],@"accessToken", @"ddd.png", @"uploadFileName",nil];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:iOS_POST_REALPICTURE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", uuidStr] mimeType:@"image/*"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        
        NSString * str = [dic objectForKey:@"msg"];
        
        [self postFacePic:str];
        [HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
    }];
    
    
}

#pragma mark - post请求
- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD, @"user":ACCOUNT_SELF}];
    NSLog(@"%@",iOS_POST_URL);
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            userDic = [dic objectForKey:@"data"];
            if (userDic == nil) {
            }else{
                historyNum.text = [userDic objectForKey:@"historyTopicCount"];
                collectNum.text = [userDic objectForKey:@"collectTopicCount"];
                self.userqrcode = [userDic objectForKey:@"userqrcode"];
                [self makeChangeToHeaderView];
            }
            if ([[userDic objectForKey:@"userbackground"] isEqualToString:@""] || [userDic objectForKey:@"userbackground"] == nil) {
                [backImage setImage:[UIImage imageNamed:@"bg_mine_header.jpg"]];
            }else{
                [backImage sd_setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"userbackground"]]];
            }
            
        }else{
            if (![result isEqualToString:@"4"]) {
                NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
                if (![name isEqualToString:@""]) {
                    [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                }
            }else{
                historyNum.text = @"0";
                collectNum.text = @"0";
            }
        }
        [self postRun];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
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


- (void)goutoOp
{
    SubViewController * vc = [[SubViewController alloc]init];
    vc.account = ACCOUNT_SELF;
    vc.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    //vc.signNum = _signNum;
    [self.navigationController pushViewController:vc animated:YES];
    
//    AppDelegate * delegateVC = ((AppDelegate *)[[UIApplication sharedApplication]delegate]);
//    SubclassIdSafeViewController * myAssureVC = [[SubclassIdSafeViewController alloc]init];
//    myAssureVC.mineVC = self;
//    [self.navigationController pushViewController:myAssureVC animated:YES];
}

- (void)MySetting:(UIButton *)sender
{
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
//    if ([userName isEqualToString:GUEST]) {
//        LoginViewController *subLoginVC =[[LoginViewController alloc] init];
//        ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:subLoginVC];
//        [self presentViewController:nav animated:YES completion:nil];
//    }else{
        OptionViewController * myAssureVC = [[OptionViewController alloc]init];
        //myAssureVC.mineVC = self;
    myAssureVC.userqrcode = self.userqrcode;
        [self.navigationController pushViewController:myAssureVC animated:YES];
//    }
    
}

- (UIView *)customHeaderView
{
    UIView * view = [[UIView alloc]init];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 172)];
    backView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [view addSubview:backView];
    
    backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
//    backImage.image = [UIImage imageNamed:@"bg_mine_header.jpg"];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    backImage.clipsToBounds = YES;
    backImage.userInteractionEnabled = YES;
    backImage.image = [UIImage imageNamed:@"bg_mine_header"];
    [backView addSubview:backImage];
    
    UITapGestureRecognizer * tapChangeBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cameraButton:)];
    [backImage addGestureRecognizer:tapChangeBackground];
    
    //头像
    logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 75, 75)];
    logoImg.image = [UIImage imageNamed:@"zanwu"];
    logoImg.layer.masksToBounds = YES;
    logoImg.layer.cornerRadius = 75/2;
    logoImg.userInteractionEnabled = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds = YES;
    
    UITapGestureRecognizer * goutoOpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goutoOp)];
    [logoImg addGestureRecognizer:goutoOpTap];
    [backView addSubview:logoImg];
    //昵称
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 12, 12, SCREEN_WIDTH - 75 - 15 - 15 - 12, 22)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:nameLabel];
    
//    accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 4, 120, 14)];
//    accountLabel.font = SIZE_FOR_14;
//    accountLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    [backView addSubview:accountLabel];
    
    //签名
    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.x, CGRectGetMaxY(nameLabel.frame) + 4, SCREEN_WIDTH - 15 - 12 - 75, 34)];
    signLabel.lineBreakMode = NSLineBreakByCharWrapping;
    signLabel.numberOfLines = 2;
    signLabel.font = SIZE_FOR_12;
    signLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:signLabel];
    
    //靠谱指数
    kaopuLabel = [[UILabel alloc]initWithFrame:CGRectMake(signLabel.frame.origin.x, signLabel.frame.size.height + signLabel.frame.origin.y + 6, 70, 12)];
    kaopuLabel.text = @"靠谱指数：";
    kaopuLabel.font = SIZE_FOR_12;
    kaopuLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:kaopuLabel];
    
    kaopuView = [[UIView alloc]initWithFrame:CGRectMake(kaopuLabel.frame.size.width + kaopuLabel.frame.origin.x - 10, kaopuLabel.frame.origin.y+1, 70, 10)];
    kaopuView.layer.masksToBounds = YES;
    kaopuView.layer.cornerRadius = 5;
    kaopuView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [backView addSubview:kaopuView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
    [kaopuView addGestureRecognizer:tap];
    
    kaopuManyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    kaopuManyView.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
    [kaopuView addSubview:kaopuManyView];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
    [kaopuManyView addGestureRecognizer:tap1];
    
    kaopuBaifenbiLabel = [[UILabel alloc]initWithFrame:CGRectMake(kaopuView.frame.size.width + kaopuView.frame.origin.x + 6,kaopuLabel.frame.origin.y,60,12)];
    kaopuBaifenbiLabel.font = SIZE_FOR_12;
    kaopuBaifenbiLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:kaopuBaifenbiLabel];
    //忽悠指数
    huyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(kaopuLabel.frame.origin.x, kaopuLabel.frame.size.height + kaopuLabel.frame.origin.y + 6, 70, 12)];
    huyouLabel.text = @"忽悠指数：";
    huyouLabel.font = SIZE_FOR_12;
    huyouLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:huyouLabel];
    huyouView = [[UIView alloc]initWithFrame:CGRectMake(huyouLabel.frame.size.width + huyouLabel.frame.origin.x - 10, huyouLabel.frame.origin.y+1, 70, 10)];
    huyouView.layer.masksToBounds = YES;
    huyouView.layer.cornerRadius = 5;
    huyouView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [backView addSubview:huyouView];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
    [huyouView addGestureRecognizer:tap2];
    
    huyouManyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    huyouManyView.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
    [huyouView addSubview:huyouManyView];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
    [huyouManyView addGestureRecognizer:tap3];
    
    huyouBaifenbiLabel = [[UILabel alloc]initWithFrame:CGRectMake(huyouView.frame.size.width + huyouView.frame.origin.x + 6,huyouLabel.frame.origin.y,60,12)];
    huyouBaifenbiLabel.font = SIZE_FOR_12;
    huyouBaifenbiLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [backView addSubview:huyouBaifenbiLabel];
    
    UIView * collectView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 , logoImg.frame.origin.y + logoImg.frame.size.height + 32, SCREEN_WIDTH / 3, 40)];
    collectView.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
    collectView.alpha = 0.2;
    [backView addSubview:collectView];
    
    UITapGestureRecognizer * tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    [collectView addGestureRecognizer:tap11];
    
    collectNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    collectNum.font = SIZE_FOR_12;
    collectNum.text = @"0";
    collectNum.textColor = [UIColor whiteColor];
    collectNum.textAlignment = NSTextAlignmentCenter;
    collectNum.center = CGPointMake(collectView.center.x, collectView.center.y - 8);
    [backView addSubview:collectNum];
    
    UILabel * collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    collectLabel.font = SIZE_FOR_12;
    collectLabel.textColor = [UIColor whiteColor];
    collectLabel.textAlignment = NSTextAlignmentCenter;
    collectLabel.text = @"我的收藏";
    collectLabel.center = CGPointMake(collectView.center.x, collectView.center.y + 8);
    [backView addSubview:collectLabel];
    
    
    
    UIView * historyView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, logoImg.frame.origin.y + logoImg.frame.size.height + 32, SCREEN_WIDTH / 3, 40)];
    historyView.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
    historyView.alpha = 0.2;
    [backView addSubview:historyView];
    
    UITapGestureRecognizer * tap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    [historyView addGestureRecognizer:tap22];
    
    historyNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    historyNum.font = SIZE_FOR_12;
    historyNum.text = @"0";
    historyNum.textColor = [UIColor whiteColor];
    historyNum.textAlignment = NSTextAlignmentCenter;
    historyNum.center = CGPointMake(historyView.center.x, collectView.center.y - 8);
    [backView addSubview:historyNum];
    
    UILabel * historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    historyLabel.font = SIZE_FOR_12;
    historyLabel.textColor = [UIColor whiteColor];
    historyLabel.textAlignment = NSTextAlignmentCenter;
    historyLabel.text = @"浏览历史";
    historyLabel.center = CGPointMake(historyView.center.x, collectView.center.y + 8);
    [backView addSubview:historyLabel];
    
    UIView * runView = [[UIView alloc]initWithFrame:CGRectMake(0, logoImg.frame.origin.y + logoImg.frame.size.height + 32, SCREEN_WIDTH / 3, 40)];
    runView.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
    runView.alpha = 0.2;
    [backView addSubview:runView];
    
    UITapGestureRecognizer * tap33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3:)];
    [runView addGestureRecognizer:tap33];
    
    runNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    runNum.font = SIZE_FOR_12;
    runNum.text = @"0";
    runNum.textColor = [UIColor whiteColor];
    runNum.textAlignment = NSTextAlignmentCenter;
    runNum.center = CGPointMake(runView.center.x, collectView.center.y - 8);
    [backView addSubview:runNum];
    //runNum.backgroundColor = [UIColor yellowColor];
    
    UILabel * runLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    runLabel.font = SIZE_FOR_12;
    runLabel.textColor = [UIColor whiteColor];
    runLabel.textAlignment = NSTextAlignmentCenter;
//    runLabel.backgroundColor = [UIColor blackColor];
    runLabel.text = @"我的消息";
    runLabel.center = CGPointMake(runView.center.x, collectView.center.y + 8);
    [backView addSubview:runLabel];
    
    //未读消息数
    UIImageView *runImageV = [[UIImageView alloc] initWithFrame:CGRectMake(62, 0, 10, 10)];
    runImageV.image = [UIImage imageNamed:@"newUnreadMessageCount1"];
    runImageV.hidden = YES;
    self.runImageV = runImageV;
    [runLabel addSubview:runImageV];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(runView.frame.origin.x + runView.frame.size.width, runView.frame.origin.y + 5, 1, 30)];
    view2.backgroundColor = [GetColor16 hexStringToColor:@"#f94888"];
    view2.alpha = 0.5;
    [backView addSubview:view2];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(collectView.frame.origin.x + collectView.frame.size.width, collectView.frame.origin.y + 5, 1, 30)];
    view1.backgroundColor = [GetColor16 hexStringToColor:@"#f94888"];
    view1.alpha = 0.5;
    [backView addSubview:view1];
    
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.centerX = backView.centerX;
    activity.centerY = signLabel.centerY;
    [activity setHidesWhenStopped:YES];
    [backView addSubview:activity];
    
    view.frame = backView.frame;
    return view;
}


#pragma mark - 点击靠谱指数进入评价列表
- (void)allEvaluation:(UITapGestureRecognizer *)tap
{
    AllEvaluationsViewController * vc = [[AllEvaluationsViewController alloc]init];
    vc.username = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap1:(UIGestureRecognizer *)tap
{
    NewAttentionViewController *vc = [[NewAttentionViewController alloc]init];
    vc.mineFragmentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap2:(UIGestureRecognizer *)tap
{
    BrowsingHistoryViewController * vc = [[BrowsingHistoryViewController alloc]init];
    vc.mineFragmentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tap3:(UIGestureRecognizer *)tap
{
    NewsCenterViewController * newsCenterVC = [[NewsCenterViewController alloc]init];
    //newsCenterVC.mineVC = self;
    [self.navigationController pushViewController:newsCenterVC animated:YES];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self post];
    });
}

- (void)postRun
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"accountGetNewMessageCount"parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            runNum.text = [NSString stringWithFormat:@"%@/%@", [[dic objectForKey:@"data"] objectForKey:@"newMessageCount"], [[dic objectForKey:@"data"] objectForKey:@"systemMessageCount"]];
            int count = [[[dic objectForKey:@"data"] objectForKey:@"count"] intValue];
            AppDelegate *app = APPDELEGATE;
            
            if (count > 0) {
                app.versionSignView.hidden = NO;
                self.runImageV.hidden = NO;
            }else{
                app.versionSignView.hidden = YES;
                self.runImageV.hidden = YES;
            }
        } else{
            runNum.text = @"0";
        }
        [self accountGetInfo];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
        [activity stopAnimating];
    }];

}

- (void)accountGetInfo
{
    NSDictionary * dic = [self parametersForDic:@"accountGetInfo"parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSDictionary * dataDic = [dic objectForKey:@"data"];
            signLabel.text = [NSString stringWithFormat:@"余额:¥ %@  积分:%@",[dataDic objectForKey:@"balance"],[dataDic objectForKey:@"score"]];
        }else {
            signLabel.text = [NSString stringWithFormat:@"余额:¥ %@  积分:%@",@"0",@"0"];
        }
        [activity stopAnimating];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
        [activity stopAnimating];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
