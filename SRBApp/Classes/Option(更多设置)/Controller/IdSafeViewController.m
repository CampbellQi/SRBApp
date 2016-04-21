//
//  IdSafeViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "IdSafeViewController.h"
#import "ChangeNameViewController.h"
#import "ChangeSignViewController.h"
#import <UIImageView+WebCache.h>
#import "ChooseSexViewController.h"
#import "ChangePassWordViewController.h"
#import "AMBlurView.h"
#import "AFHTTPRequestOperationManager.h"
#import "SubViewController.h"
#import "SGActionView.h"
#import "GetMoneyPassWordViewController.h"
#import "CreateGetMoneyViewController.h"
#import <TuSDK/TuSDK.h>
#import "MyTwoDimensionCodeViewController.h"
#import "ImageViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "MyQrCodeController.h"

@interface IdSafeViewController ()<UIActionSheetDelegate,TuSDKPFCameraDelegate, TuSDKPFEditTurnAndCutDelegate, TuSDKFilterManagerDelegate>{
    NSArray * _arr;
    NSMutableDictionary * _dic;
    NSString * _nickname;
    NSString * _sign;
    NSString * _birthday;
    NSString * _resetBirthday;
    
    UILabel * _label;
    AVCaptureDevice *device;
    
    NSString * outputString;
    
    UIButton * dateButton;
    
    AMBlurView * _blurView;
    
    NSString * uuidstr;
    
    UIButton * regBtn;
    
    UIDatePicker * datePicker;
    
    NSString * paypassword;
    
    NSString * pushSign;
    BOOL boundWithWeixin;
    BOOL boundWithWeibo;
    
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 头像设置组件
    TuSDKCPAvatarComponent *_avatarComponent;
    // 图片编辑组件
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
}
@property(nonatomic, retain)UIButton * imageButton;
@property(nonatomic, strong)UIImageView * imageView;
@property(nonatomic, retain)UILabel * textLabel;
@property(nonatomic, strong)NSString * signNum;
@property (nonatomic, strong) NSString *userqrcode;//二维码
@property (nonatomic, strong) NSString *invitecode;//邀请码
@property (nonatomic, strong) NSString *constellationcode;//星座
@property (nonatomic, strong) UIImageView *QRImgView;

@property (nonatomic, strong) NSString *weixinID;
@property (nonatomic, strong) NSString *weiboID;

@end

@implementation IdSafeViewController
{
    UIActionSheet * actionSheets;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    //    [self showHubWithStatus:LSQString(@"lsq_initing", @"正在初始化")];
    [TuSDK checkManagerWithDelegate:self];
    
    self.title = @"账号与安全";
    [self post];
    _arr = [NSArray array];
    _arr = @[@"昵称", @"性别", @"生日", @"个性签名", @"我的二维码"];
    _signNum = @"1";
    
    [self refreashUserUserfo];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:view];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    _imageView.center = CGPointMake(SCREEN_WIDTH / 2,  20 + 37.5);
    _imageView.layer.cornerRadius = 37;
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [view addSubview:_imageView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    //图片按钮
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    _imageButton.center = CGPointMake(SCREEN_WIDTH / 2,  20 + 37.5);
    _imageButton.backgroundColor = [UIColor clearColor];
    _imageButton.layer.cornerRadius = 37;
    _imageButton.layer.masksToBounds = YES;
    [_imageButton addTarget:self action:@selector(cameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_imageButton];
    
    
    
    
    //文字
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100 ,16)];
    _textLabel.text = @"点击头像更换";
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imageButton.frame.origin.y + _imageButton.frame.size.height + 12 + 8);
    [_textLabel setTextColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1]];
    [view addSubview:_textLabel];
    
    //信息列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    //    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = view;
    [self.view addSubview:_tableView];
    
    //    regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    regBtn.frame = CGRectMake(0, 15, 60, 25);
    //    [regBtn setTitle:@"保 存" forState:UIControlStateNormal];
    //    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    //    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    //    regBtn.backgroundColor = WHITE;
    //    regBtn.layer.cornerRadius = 2;
    //    regBtn.layer.masksToBounds = YES;
    //    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
    //    regBtn.hidden = NO;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH + 5, 0, 80, 20)];
    _label.text = @"保存成功";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 10;
    _label.font = [UIFont systemFontOfSize:16];
    [_label setTextColor:[UIColor whiteColor]];
    _label.alpha = 0.5;
    _label.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [self.view addSubview:_label];
    
    _blurView = [[AMBlurView alloc]initWithFrame:CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
    //        blurView.frame = self.view.frame;
    //
    //        _blurView.blurRadius = 1;
    //        [_blurView setDynamic:YES];
    [self.view addSubview:_blurView];
    
    actionSheets = [[UIActionSheet alloc]initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"女",@"男", nil];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate * currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * tempTimeStr = [formatter stringFromDate:currentTime];
    
    datePicker.maximumDate = [formatter dateFromString:tempTimeStr];
    [datePicker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [_blurView addSubview:datePicker];
    
    dateButton = [[UIButton alloc]initWithFrame:CGRectMake(0,250 , SCREEN_WIDTH, 40)];
    [dateButton setTitle:@"确认生日" forState:UIControlStateNormal];
    [dateButton setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [dateButton addTarget:self action:@selector(backPicker) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:dateButton];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(dateButton.frame.origin.x, dateButton.frame.origin.y + dateButton.frame.size.height, SCREEN_WIDTH, 40)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reSetPicker) forControlEvents:UIControlEventTouchUpInside];
    [_blurView addSubview:button];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self post];
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ------ 调用系统相机 ------
- (void)cameraButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"还原默认头像",@"拍照", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:actionSheets]) {
        if (buttonIndex != 2) {
            [self regControllerSex:[NSString stringWithFormat:@"%lu",buttonIndex]];
            [self post];
        }
    }else{
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
                [self.imageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
    self.imageButton.alpha = 1;
    //    [self.imageButton setImage:image forState:UIControlStateNormal];
    //    imageButton.contentMode = UIViewContentModeScaleAspectFill;
    //    imageButton.clipsToBounds = YES;
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
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
    NSDictionary * dic = [self parametersForDic:@"accountSetUserPic" parameters:@{ACCOUNT_PASSWORD, @"url":str, @"uuid":@"0"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [self post];
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
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
    [manager POST:iOS_POST_PICTURE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", uuidstr] mimeType:@"image/*"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        
        NSString * str = [dic objectForKey:@"msg"];
        
        [self postFacePic:str];
        [HUD removeFromSuperview];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

#pragma mark - 获取UUID
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString * result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    result = [NSTemporaryDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}
/*
 //#pragma mark - 等比压缩
 //-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
 //    UIImage *newImage = nil;
 //    CGSize imageSize = sourceImage.size;
 //    CGFloat width = imageSize.width;
 //    CGFloat height = imageSize.height;
 //    CGFloat targetWidth = size.width;
 //    CGFloat targetHeight = size.height;
 //    CGFloat scaleFactor = 0.0;
 //    CGFloat scaledWidth = targetWidth;
 //    CGFloat scaledHeight = targetHeight;
 //    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
 //    if(CGSizeEqualToSize(imageSize, size) == NO){
 //        CGFloat widthFactor = targetWidth / width;
 //        CGFloat heightFactor = targetHeight / height;
 //        if(widthFactor > heightFactor){
 //            scaleFactor = widthFactor;
 //        }
 //        else{
 //            scaleFactor = heightFactor;
 //        }
 //        scaledWidth = width * scaleFactor;
 //        scaledHeight = height * scaleFactor;
 //        if(widthFactor > heightFactor){
 //            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
 //        }else if(widthFactor < heightFactor){
 //            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
 //        }
 //    }
 //
 //    UIGraphicsBeginImageContext(size);
 //
 //    CGRect thumbnailRect = CGRectZero;
 //    thumbnailRect.origin = thumbnailPoint;
 //    thumbnailRect.size.width = scaledWidth;
 //    thumbnailRect.size.height = scaledHeight;
 //    [sourceImage drawInRect:thumbnailRect];
 //    newImage = UIGraphicsGetImageFromCurrentImageContext();
 //
 //    if(newImage == nil){
 //        NSLog(@"scale image fail");
 //    }
 //
 //    UIGraphicsEndImageContext();
 //
 //    return newImage;
 //
 //}
 //
 //-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
 //    UIImage *newImage = nil;
 //    CGSize imageSize = sourceImage.size;
 //    CGFloat width = imageSize.width;
 //    CGFloat height = imageSize.height;
 //    CGFloat targetWidth = defineWidth;
 //    CGFloat targetHeight = height / (width / targetWidth);
 //    CGSize size = CGSizeMake(targetWidth, targetHeight);
 //    CGFloat scaleFactor = 0.0;
 //    CGFloat scaledWidth = targetWidth;
 //    CGFloat scaledHeight = targetHeight;
 //    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
 //    if(CGSizeEqualToSize(imageSize, size) == NO){
 //        CGFloat widthFactor = targetWidth / width;
 //        CGFloat heightFactor = targetHeight / height;
 //        if(widthFactor > heightFactor){
 //            scaleFactor = widthFactor;
 //        }
 //        else{
 //            scaleFactor = heightFactor;
 //        }
 //        scaledWidth = width * scaleFactor;
 //        scaledHeight = height * scaleFactor;
 //        if(widthFactor > heightFactor){
 //            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
 //        }else if(widthFactor < heightFactor){
 //            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
 //        }
 //    }
 //    UIGraphicsBeginImageContext(size);
 //    CGRect thumbnailRect = CGRectZero;
 //    thumbnailRect.origin = thumbnailPoint;
 //    thumbnailRect.size.width = scaledWidth;
 //    thumbnailRect.size.height = scaledHeight;
 //
 //    [sourceImage drawInRect:thumbnailRect];
 //
 //    newImage = UIGraphicsGetImageFromCurrentImageContext();
 //    if(newImage == nil){
 //        NSLog(@"scale image fail");
 //    }
 //
 //    UIGraphicsEndImageContext();
 //    return newImage;
 //}
 */

#pragma mark - post请求
- (void)post
{
    HUD1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD1.labelText = @"处理中,请稍后";
    HUD1.dimBackground = YES;
    [HUD1 show:YES];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        _dic = [dic objectForKey:@"data"];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"avatar" ]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        NSLog(@"%@", _dic);
        _nickname = [_dic objectForKey:@"nickname"];
        _sign = [_dic objectForKey:@"sign"];
        _birthday = [_dic objectForKey:@"birthday"];
        _resetBirthday = [_dic objectForKey:@"birthday"];
        _sex = [_dic objectForKey:@"sex"];
        _userqrcode = [_dic objectForKey:@"userqrcode"];
        _invitecode = [_dic objectForKey:@"invitecode"];
        _constellationcode = [_dic objectForKey:@"constellationcode"];
        if (_nickname == nil) {
            _signNum = @"0";
        }
        [self datePickerAndMethod];
        
        if ([dic objectForKey:@"title"] == nil || [dic objectForKey:@"content"] == nil) {
            
        }else{
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
        }
        [self havepassword];
        [HUD1 removeFromSuperview];
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return  0.01;
    }
    if (section == 1) {
        return 0.01;
    }
    if (section == 2) {
        return 0.01;
    }
    return 0.01;
}

#pragma mark - 定义tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        if ([WXApi isWXAppInstalled]) {
            return 2;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            
        }
        cell.textLabel.text = _arr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = _nickname;
        }
        if (indexPath.row == 1) {
            if ([_sex isEqualToString:@"0"]) {
                cell.detailTextLabel.text = @"女";
            }
            else{
                cell.detailTextLabel.text = @"男";
            }
        }
        if (indexPath.row == 2) {
            if (_birthday.length == 0) {
                cell.detailTextLabel.text = @"1990-1-1";
            }else{
            cell.detailTextLabel.text = _birthday;
            }
        }
        if (indexPath.row == 3) {
            if (_sign.length == 0) {
                cell.detailTextLabel.text = @"这个主人很懒...";
            }else{
            cell.detailTextLabel.text = _sign;
            }
        }
        if (indexPath.row == 4) {
            UIImageView *QRImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
            self.QRImgView = QRImgView;
            QRImgView.userInteractionEnabled = YES;
            QRImgView.image = [UIImage imageNamed:@"QRiamge_gray"];
            cell.accessoryView = QRImgView;
            
            UITapGestureRecognizer *qrTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrTap:)];
            [QRImgView addGestureRecognizer:qrTap];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            
        }
        //        cell.textLabel.text = _arr[indexPath.row + 5];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改登录密码";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"设定支付密码";
            cell.detailTextLabel.text = pushSign;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"进入个人主页";
        }
        return cell;

    }
    if (indexPath.section == 2) {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell3"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            
        }
        //        cell.textLabel.text = _arr[indexPath.row + 5];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([WXApi isWXAppInstalled]) {
            if (indexPath.row == 0) {
                NSLog(@"self.weixinID == %@",self.weixinID);
                NSLog(@"self.weiboID == %@",self.weiboID);
                if ([self.weixinID isEqualToString:@""] || (self.weixinID.length == 0) || self.weixinID == nil || [self.weixinID isEqualToString:@"(null)"]) {
                    cell.textLabel.text = @"微信绑定";
                    boundWithWeixin = YES;
                }else{
                    cell.textLabel.text = @"取消微信绑定";
                    boundWithWeixin = NO;
                }
            }
            if (indexPath.row == 1) {
                if ([self.weiboID isEqualToString:@""] || (self.weiboID.length == 0) || self.weiboID == nil || [self.weixinID isEqualToString:@"(null)"]) {
                    cell.textLabel.text = @"新浪微博绑定";
                    boundWithWeibo = YES;
                }else{
                    cell.textLabel.text = @"取消新浪微博绑定";
                    boundWithWeibo = NO;
                }
            }
        }else{
            if (indexPath.row == 0) {
                if ([self.weiboID isEqualToString:@""] || (self.weiboID.length == 0) || self.weiboID == nil || [self.weixinID isEqualToString:@"(null)"]) {
                    cell.textLabel.text = @"新浪微博绑定";
                    boundWithWeibo = YES;
                }else{
                    cell.textLabel.text = @"取消新浪微博绑定";
                    boundWithWeibo = NO;
                }
            }
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ChangeNameViewController * vc = [[ChangeNameViewController alloc]init];
            vc.nickName = _nickname;
            vc.sex = _sex;
            vc.birthday = _birthday;
            vc.sign = _sign;
            vc.signNum = _signNum;
            //        [vc sendMessage1:^(id result) {
            //            _nickname = result;
            //            [_tableView reloadData];
            //        }];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            
            [actionSheets showInView:self.view];
            
        }
        if (indexPath.row == 2) {
            [UIView beginAnimations:@"_blurView" context:nil];
            [UIView setAnimationDuration:0.5];
            _blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            regBtn.hidden = YES;
            [UIView commitAnimations];
        }
        if (indexPath.row == 3) {
            ChangeSignViewController * vc = [[ChangeSignViewController alloc]init];
            vc.nickName = _nickname;
            vc.sex = _sex;
            vc.birthday = _birthday;
            vc.sign = _sign;
            vc.signNum = _signNum;
            //        [vc sendMessage:^(id result) {
            //            _sign = result;
            //            [_tableView reloadData];
            //        }];
            [self.navigationController pushViewController:vc animated:YES];
        }//我的二维码
        if (indexPath.row == 4) {
//            MyTwoDimensionCodeViewController *myTwoDimensionCodeVC = [[MyTwoDimensionCodeViewController alloc] init];
//            myTwoDimensionCodeVC.account = ACCOUNT_SELF;
            
            MyQrCodeController *vc = [[MyQrCodeController alloc] init];
            vc.account = ACCOUNT_SELF;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            ChangePassWordViewController * vc = [[ChangePassWordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            if ([pushSign  isEqual: @"未设定"]) {
                CreateGetMoneyViewController * vc = [[CreateGetMoneyViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                GetMoneyPassWordViewController * vc = [[GetMoneyPassWordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
       
        
        if (indexPath.row == 2) {
            SubViewController * vc = [[SubViewController alloc]init];
            vc.account = ACCOUNT_SELF;
            vc.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
            vc.signNum = _signNum;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if ([WXApi isWXAppInstalled]) {
            if (indexPath.row == 0) {
                //解除微信绑定
                if (boundWithWeixin == NO) {
                    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weixin",@"token":@"0",@"unionid":uid}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                                   
                                               }
                                           }];
                }else{
                    NSLog(@"idnexPath == 00");
                    
                    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   NSString* token = [creden token];
                                                   
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weixin",@"token":[NSString stringWithFormat:@"%@",token],@"unionid":uid}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       //                                                   NSLog(@"dic == %@",dic);
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                               }
                                           }];
                }
                
            }
            if (indexPath.row == 1) {
                
                NSLog(@"idnexPath == 01");
                if (boundWithWeibo == NO) {
                    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   NSString* token = [creden token];
                                                   NSLog(@"uid:%@",uid);
                                                   NSLog(@"token:%@",token);
                                                   NSLog(@"uid = %@",[userInfo uid]);
                                                   NSLog(@"name = %@",[userInfo nickname]);
                                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":@"0"}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                               }
                                               
                                               
                                           }];
                    
                    
                }else{
                    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   NSString* token = [creden token];
                                                   NSLog(@"uid:%@",uid);
                                                   NSLog(@"token:%@",token);
                                                   NSLog(@"uid = %@",[userInfo uid]);
                                                   NSLog(@"name = %@",[userInfo nickname]);
                                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                                   
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":[NSString stringWithFormat:@"%@",token]}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                               }
                                           }];
                }
            }
        }else{
            if (indexPath.row == 0) {
                NSLog(@"idnexPath == 01");
                if (boundWithWeibo == NO) {
                    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   NSString* token = [creden token];
                                                   NSLog(@"uid:%@",uid);
                                                   NSLog(@"token:%@",token);
                                                   NSLog(@"uid = %@",[userInfo uid]);
                                                   NSLog(@"name = %@",[userInfo nickname]);
                                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                                   
                                                   
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":@"0"}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                               }
                                               
                                               
                                           }];
                    
                    
                }else{
                    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                                      authOptions:nil
                                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                               
                                               if (result)
                                               {
                                                   id <ISSPlatformCredential> creden = [userInfo credential];
                                                   NSString* uid = [creden uid];
                                                   NSString* token = [creden token];
                                                   NSLog(@"uid:%@",uid);
                                                   NSLog(@"token:%@",token);
                                                   NSLog(@"uid = %@",[userInfo uid]);
                                                   NSLog(@"name = %@",[userInfo nickname]);
                                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                                   
                                                   //拼接post请求所需参数
                                                   NSDictionary * loginParam = @{@"method":@"accountSetUserToken",@"parameters":@{ACCOUNT_PASSWORD,@"apiType":@"weibo",@"token":[NSString stringWithFormat:@"%@",token]}};
                                                   [HUD removeFromSuperview];
                                                   HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                   HUD.labelText = @"操作中,请稍后";
                                                   HUD.dimBackground = YES;
                                                   [HUD show:YES];
                                                   [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [HUD removeFromSuperview];
                                                           [self refreashUserUserfo];
                                                       });
                                                       [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                                                   }];
                                               }
                                           }];
                }
                
            }
        }
    }
}

//获取支付密码
- (void)havepassword
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountGetQuestion" parameters:@{ACCOUNT_PASSWORD}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSDictionary * dic1 = [dic objectForKey:@"data"];
            paypassword = [dic1 objectForKey:@"question"];
            if ([paypassword isEqualToString:@""]) {
                pushSign = @"未设定";
            }else{
                pushSign = @"已设定";
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [_tableView reloadData];
        [HUD removeFromSuperview];
    }];
}

//保存数据(sex)
- (void)regControllerSex:(NSString *)sex
{
    if ([_signNum isEqualToString: @"0"]) {
        return;
    }else{
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":sex, @"nickname":_nickname, @"sign": _sign, @"birthday": _birthday}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }];
    }
}

//保存数据(birthday)
- (void)regControllerBirthday:(NSString *)birthday
{
    if ([_signNum isEqualToString:@"0"]) {
        return;
    }else{
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":_sex, @"nickname":_nickname, @"sign": _sign, @"birthday": birthday}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                
            }else{
                NSLog(@"%@",[dic objectForKey:@"message"]);
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }];
    }
}
#pragma mark - DatePicker

- (void)datePickerAndMethod
{
    NSString *stdDate = [[NSString alloc]init];
    if (_birthday.length == 0) {
        stdDate = @"1990-01-01";
    }else{
        stdDate = _birthday;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [datePicker setDate:[formatter dateFromString:stdDate] animated:YES];
    
}

- (void)reSetPicker
{
    regBtn.hidden = NO;
    [UIView beginAnimations:@"_blurView" context:nil];
    [UIView setAnimationDuration:0.5];
    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    _birthday = _resetBirthday;
    [_tableView reloadData];
    [UIView commitAnimations];
}

- (void)backPicker
{
    [self regControllerBirthday:_birthday];
    
    regBtn.hidden = NO;
    [UIView beginAnimations:@"_blurView" context:nil];
    [UIView setAnimationDuration:0.5];
    _blurView.frame = CGRectMake(0, - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    [UIView commitAnimations];
}

- (void)showDate:(UIDatePicker *)datePickerr
{
    regBtn.hidden = YES;
    NSDate *date = datePickerr.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    outputString = [formatter stringFromDate:date];
    _birthday = outputString;
    //    _dateField.text = outputString;
    [_tableView reloadData];
}

- (void)function
{
    _label.center = CGPointMake(SCREEN_HEIGHT, SCREEN_HEIGHT);
}


- (void)qrTap:(UITapGestureRecognizer *)sender
{
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    NSString * urlStr = self.userqrcode;
    NSLog(@"self.userqrcode = %@",self.userqrcode);
    imageVC.imgIndex = 1;
    imageVC.imageUrl = urlStr;
    //[self presentViewController:imageVC animated:YES completion:nil];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    JTSImageInfo * imageInfo = [[JTSImageInfo alloc]init];
    
    UIView * tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tempView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [tempView addGestureRecognizer:tapGesture];
    
    UIView * secondView = [[UIView alloc]initWithFrame:tempView.frame];
    secondView.backgroundColor = [UIColor blackColor];
    secondView.alpha = 0.7;
    
    UIActivityIndicatorView * tempActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    tempActivity.center = tempView.center;
    [tempActivity setHidesWhenStopped:YES];
    [tempActivity startAnimating];
    
    [tempView addSubview:secondView];
    [tempView addSubview:tempActivity];
    [[[[UIApplication sharedApplication]windows]lastObject] addSubview:tempView];
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [tempActivity stopAnimating];
        
        if (image == nil) {
            [AutoDismissAlert autoDismissAlert:@"获取头像失败"];
            return;
        }
        
        imageInfo.image = image;
        imageInfo.referenceRect = self.QRImgView.frame;
        imageInfo.referenceView = self.QRImgView.superview;
        
        JTSImageViewController * jtImageVC = [[JTSImageViewController alloc]initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_None];
        [jtImageVC showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
        [tempView removeFromSuperview];
    }];
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [(UIView *)tap.view removeFromSuperview];
    [[SDWebImageManager sharedManager]cancelAll];
}

//刷新用户保密信息
- (void)refreashUserUserfo
{
    NSDictionary * loginParam = @{@"method":@"accountGetInfo",@"parameters":@{ACCOUNT_PASSWORD}};
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        self.weiboID = [[dic objectForKey:@"data"] objectForKey:@"weiboid"];
        self.weixinID = [[dic objectForKey:@"data"] objectForKey:@"weixinid"];
        
        [self.tableView reloadData];
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
