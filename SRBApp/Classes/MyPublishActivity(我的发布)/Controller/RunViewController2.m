//
//  RunViewController2.m
//  tusstar
//
//  Created by fengwanqi on 15/7/1.
//  Copyright (c) 2015年 zxk. All rights reserved.
//
#define MAX_IMAGE_COUNT 9
#import "RunViewController2.h"
#import "NearbyLocationsViewController.h"
#import "CreateSignViewController.h"
#import "StringHelper.h"
#import "UIColor+Dice.h"
#import "ZZNavigationController.h"
#import "FAPhotoEditDetailController.h"
#import "AppDelegate.h"
#import "UIImage+Compress.h"
#import "CreateSignViewController2.h"
#import "ODMCombinationPickerViewController.h"

//#import "LoadingView.h"

#define PHOTO_MARGIN 10
#define CONTENT_PLACEHOLDER @"说点什么..."

@interface RunViewController2 ()<ODMCombinationPickerViewControllerDelegate>
{
    UIImagePickerController* _imagePicker;
    NSMutableArray *_imagesArray;
    NSString *_imagesUrlStr;
    UIImageView *_addPhoto;
    
    MBProgressHUD * _hud;
    
    NSMutableArray *_selectedSignArray;
    
    UIButton *_publishBtn;
    UIButton *_backBtn;
}
@property (nonatomic, strong) NSString *detailAddress;//具体地址
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度

@end

@implementation RunViewController2

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布足迹";
    // Do any additional setup after loading the view from its nib.
    _imagesArray = [NSMutableArray arrayWithCapacity:0];
    _imagesUrlStr = @"";
    [self setUpView];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locMgr stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启定位
    [self.locMgr startUpdatingLocation];
}
#pragma mark- 页面
-(void)setUpView {
    //图片
    [self setPhotosScrollView];
    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    _backBtn = backBtn;
    //右导航
    UIColor *pColor = [UIColor diceColorWithRed:227.0 green:95.0 blue:147.0 alpha:1];
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(15, 0, 55, 25);
    publishBtn.layer.masksToBounds = YES;
    publishBtn.layer.cornerRadius = CGRectGetHeight(publishBtn.frame)*0.5;
    [publishBtn setBackgroundColor:[UIColor whiteColor]];
    [publishBtn setTitle:@"发 布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [publishBtn addTarget:self action:@selector(publishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:pColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    _publishBtn = publishBtn;
    //位置
    self.locationSuperView.layer.cornerRadius = 4.0f;
    self.locationSuperView.layer.borderColor = pColor.CGColor;
    self.locationSuperView.layer.borderWidth = 1.0f;
    //标签
    [self.markBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSignVC)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    //输入框字数限制
    self.contentNumLbl.text = [NSString stringWithFormat:@"%d/%d",0, FOOTER_MAX_COUNT];
}
-(void)setPhotosScrollView {
    float photoWidth = self.photosScrollView.height;
    for (int i=0; i<MAX_IMAGE_COUNT; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * photoWidth + PHOTO_MARGIN * (i + 1), 0, photoWidth, photoWidth)];
        if (i == 0) {
            iv.image = [UIImage imageNamed:@"fb_xj.png"];
            _addPhoto = iv;
            iv.userInteractionEnabled = YES;
        }else {
            iv.image = [UIImage imageNamed:@"fb_gd_bg.png"];
            iv.userInteractionEnabled = NO;
        }
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        
        [iv addGestureRecognizer:tapGR];
        
        iv.tag = 100 + i;
        [self.photosScrollView addSubview:iv];
    }
    [self.photosScrollView setContentSize:CGSizeMake(photoWidth * MAX_IMAGE_COUNT + PHOTO_MARGIN * (MAX_IMAGE_COUNT + 1), self.photosScrollView.height)];
}
#pragma mark- 事件
//隐藏键盘
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
//隐藏位置
- (IBAction)hideLocationBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.locationSelectedIV.hidden) {
        self.locationTV.hidden = NO;
        self.locationSelectedIV.hidden = NO;
    }else {
        self.locationTV.hidden = YES;
        self.locationSelectedIV.hidden = YES;
    }
}

- (IBAction)addTagsBtnClicked:(id)sender {
    [self goSignVC];
}
//发布
-(void)publishBtnClicked {
    NSString * content = [self.contentTextView.text trim];
    if ((content.length == 0 || [content isEqualToString:CONTENT_PLACEHOLDER]) && _imagesArray.count == 0) {
        [self.contentTextView becomeFirstResponder];
         [AutoDismissAlert autoDismissAlert:@"请填写分享内容,或上传图片"];
        return;
    }
    if (content.length > FOOTER_MAX_COUNT) {
        [self.contentTextView becomeFirstResponder];
        [AutoDismissAlert autoDismissAlert:[NSString stringWithFormat:@"不能超过%d个字", FOOTER_MAX_COUNT]];
        return;
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    _publishBtn.userInteractionEnabled = NO;
    _backBtn.userInteractionEnabled = NO;
    if (_imagesArray.count) {
        [self uploadPhotoRequest];
    }else {
        [self uploadAllRequest];
    }
    
   
    
}
//返回
-(void)backBtnClicked {
    if ([self.contentTextView.text isEqualToString:CONTENT_PLACEHOLDER] && _imagesArray.count == 0) {
        [self.navigationController dismissViewController];
    }else {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewController];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
#pragma mark- 跳转
//附近位置
- (void)goFindPositionVC
{
    NearbyLocationsViewController *nearbyLocationVC = [[NearbyLocationsViewController alloc] init];
    [nearbyLocationVC position:^(NSString *position,NSDictionary *location) {
        self.locationTV.text = position;
        self.detailAddress = position;
        self.latitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lat"]];
        self.longitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lng"]];
    }];
    nearbyLocationVC.lat = self.latitude;
    nearbyLocationVC.lon = self.longitude;
    nearbyLocationVC.address = self.detailAddress;
    
    ZZNavigationController *zzNav = [[ZZNavigationController alloc] initWithRootViewController:nearbyLocationVC];
    [self presentViewController:zzNav animated:YES completion:nil];
}
//标签
- (void)goSignVC {
    CreateSignViewController2 *vc = [[CreateSignViewController2 alloc] initWithFooterPrint];
    vc.selectedSignArray = _selectedSignArray;
    vc.completeBlock = ^(NSMutableArray *signArray) {
        _selectedSignArray = signArray;
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary *dict in signArray) {
            [tempArray addObject:dict[@"name"]];
        }
        self.markTF.text = [tempArray componentsJoinedByString:@","];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    //    CreateSignViewController * createSignVC = [[CreateSignViewController alloc]init];
    //    createSignVC.signStr = self.markTF.text;
    //    createSignVC.completeBlock = ^(NSString *signStr) {
    //        self.markTF.text = signStr;
    //
    //    };
    //    [self.navigationController pushViewController:createSignVC animated:YES];
}
#pragma mark- 定位
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
                         self.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
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
                         self.locationTV.text = self.detailAddress;
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}
#pragma mark- 添加照片
-(void)photoTapped:(UIGestureRecognizer *)aGR {
    [self.view endEditing:YES];
    UIImageView *iv = (UIImageView *)aGR.view;
    
    if (iv == _addPhoto) {
        [self showPhotoAlertSheet];
    }else {
        FAPhotoEditDetailController *vc = [[FAPhotoEditDetailController alloc] init];
        vc.imageArray = _imagesArray;
        vc.selectedIndex = iv.tag - 100;
        vc.editImageBlock = ^(NSMutableArray *imageArray){
            
            _imagesArray = imageArray;
            [self showImages];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- ActionSheet
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_imagesArray.count < MAX_IMAGE_COUNT) {
            [_imagesArray addObject:image];
            [self showImages];
        }
     
    }];
}
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImageArray:(NSArray *)images {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        for (UIImage *image in images) {
            if (_imagesArray.count < MAX_IMAGE_COUNT) {
                [_imagesArray addObject:image];
            }
        }
        [self showImages];
    }];
}
-(void)showPhotoAlertSheet {
    [self.view endEditing:YES];
    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] init];
    vc.delegate = self;
    vc.maxSelCount = MAX_IMAGE_COUNT - _imagesArray.count;
    [self presentViewController:vc animated:YES completion:nil];
    return;
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:0];
        }]];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:1];
        }]];
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alertSheet animated:YES completion:nil];
    }else {
        UIActionSheet *alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alertSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self alertButtonAtIndex:buttonIndex];
}
-(void)alertButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        ZYQAssetPickerController *zYQAssetPicker = [[ZYQAssetPickerController alloc] init];
        zYQAssetPicker.maximumNumberOfSelection = MAX_IMAGE_COUNT - _imagesArray.count;
        zYQAssetPicker.assetsFilter = [ALAssetsFilter allPhotos];
        zYQAssetPicker.showEmptyGroups=NO;
        zYQAssetPicker.delegate=self;
//        zYQAssetPicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//                return duration >= 5;
//            } else {
//                return YES;
//            }
//        }];
        [self presentViewController:zYQAssetPicker animated:YES completion:NULL];
        
//        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
//        //    picker.allowsEditing = YES;//是否可以对原图进行编辑
//        picker.maximumNumberOfSelection = MAX_IMAGE_COUNT - _imagesArray.count;
//        picker.assetsFilter = [ALAssetsFilter allPhotos];
//        //uploadnum = arr.count;
//        picker.delegate = self;
//        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        //    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selsectArray];
        
       // [self presentViewController:picker animated:YES completion:NULL];
        
    }else if(buttonIndex == 0){
        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            //[LoadingView showErrMsg:@"该设备不支持相机！" WithInterval:1];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullScreenImage]];
        if (_imagesArray.count < MAX_IMAGE_COUNT) {
            [_imagesArray addObject:image];
        }
    }
    [self showImages];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_imagesArray addObject:image];
        [self showImages];
    }];
}
-(void)showImages {
    for (int i=0; i<MAX_IMAGE_COUNT; i++) {
        UIImageView *iv = (UIImageView *)[self.view viewWithTag:100+i];
        if (_imagesArray.count > i) {
            iv.image = [_imagesArray objectAtIndex:i];
            iv.userInteractionEnabled = YES;
        }else if(i == _imagesArray.count) {
            iv.image = [UIImage imageNamed:@"fb_xj.png"];
            _addPhoto = iv;
            iv.userInteractionEnabled = YES;
            
        }else {
            iv.image = [UIImage imageNamed:@"fb_gd_bg.png"];
            iv.userInteractionEnabled = NO;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- textview delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.markTF) {
        [self goSignVC];
        return NO;
    }
    return YES;
}
#pragma mark- textview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.contentTextView) {
        if ([textView.text isEqualToString:CONTENT_PLACEHOLDER]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.contentTextView) {
        if (textView.text.length == 0) {
            textView.text = CONTENT_PLACEHOLDER;
            textView.textColor = [UIColor lightGrayColor];
        }
        
    }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.locationTV) {
        [self goFindPositionVC];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView.text.length > 140)
//    {
//        textView.text = [textView.text substringToIndex:140];
//    }
    NSString  * nsTextContent=textView.text;
    self.contentNumLbl.text = [NSString stringWithFormat:@"%ld/%d", nsTextContent.length,FOOTER_MAX_COUNT];
    
}
#pragma mark- alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController dismissViewController];
    }
}
#pragma mark- 请求网络
//提交所有数据
- (void)uploadAllRequest
{
    NSString * content = [self.contentTextView.text trim];
    if ([content isEqualToString:CONTENT_PLACEHOLDER]) {
        content = @"";
    }
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", self.latitude ? self.latitude : @"",self.longitude ? self.longitude : @""];
    NSString * position = self.detailAddress;
    NSString *positionsign = @"1";
    if (self.locationSelectedIV.hidden) {
        positionsign = @"0";
    }else {
        positionsign = @"1";
        if (position.length == 0) {
            positionsign = @"0";
        }
    }
    NSDictionary *param = nil;
    if ([positionsign isEqualToString:@"1"]) {
        param = [self parametersForDic:@"accountCreatePosition" parameters:@{ACCOUNT_PASSWORD, @"title":position, @"xyz":xyz, @"url":_imagesUrlStr, @"content":content, @"uuid":@"0",@"tags":self.markTF.text}];
        //发送post请求
        
    }else {
        param = [self parametersForDic:@"accountCreatePosition" parameters:@{ACCOUNT_PASSWORD, @"title":@"0", @"xyz":@"0", @"url":_imagesUrlStr, @"content":content, @"uuid":@"0",@"tags":self.markTF.text}];
    }
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
        if ([result isEqualToString:@"0"]) {
            //发送通知刷新足迹
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLocationNTF" object:nil];
            [_hud removeFromSuperview];
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app tabbarSelectedIndex:3];
            [self.navigationController dismissViewController];
        }else{
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
            [_hud removeFromSuperview];
        }
    } andFailureBlock:^{
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
        [_hud removeFromSuperview];
    }];
}
-(void)uploadPhotoRequest {
    
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_REALPICTURE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in _imagesArray) {
            NSData *imageData = [image compressAndResize];
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        _imagesUrlStr = [dic objectForKey:@"msg"];

        NSLog(@"message: %@", [dic objectForKey:@"message"]);
 
        [self uploadAllRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
        NSLog(@"Error: %@", error);
        [_hud removeFromSuperview];
        //[UIAlertView autoDismissAlert:@"上传失败"];
        //[HUD removeFromSuperview];
    }];
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
@end
