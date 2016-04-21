//
//  HelpPurchasingController.m
//  SRBApp
//  帮忙代购
//  Created by fengwanqi on 15/10/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define MAX_IMAGE_COUNT 9
#define PHOTO_MARGIN 10

#define PHOTO_TAG 1000

#import "HelpPurchasingController.h"
#import "AppDelegate.h"
#import "CommonView.h"
#import "UIColor+Dice.h"
#import "FAPhotoEditDetailController.h"
#import "NearbyLocationsViewController.h"
#import "CommonHandel.h"
#import "StringHelper.h"
#import "WQDatePickerView.h"
#import "ODMCombinationPickerViewController.h"

@interface HelpPurchasingController ()<ODMCombinationPickerViewControllerDelegate>
{
    UIImageView *_addPhoto;
    NSMutableArray *_imagesArray;
    NSString *_latitude;
    NSString *_longitude;
    NSString *_city;
    NSString *_country;
    MBProgressHUD *_hud;
    WQDatePickerView *_pickerView;
}

@property (nonatomic, strong)CLLocationManager *locMgr;
@end


@implementation HelpPurchasingController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locMgr stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启定位
    [self.locMgr startUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagesArray = [NSMutableArray array];
    [self setUpView];
    [self listenKeyboard];
    
    
}
#pragma mark- 页面
-(void)setUpView {
    //导航
    self.title = @"帮忙代购";
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"提 交" Target:self Action:@selector(commitClicked:)];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor diceColorWithRed:0 green:0 blue:0 alpha:0.7]];
    //设置圆角
    for (int i=100; i<=106; i++) {
        UIView *view0 = [self.view viewWithTag:100];
        UIView *view = [self.view viewWithTag:i];
        float cornerRadius = view0.height * 0.5;
        if (i==106) {
            //cornerRadius = 4.0;
        }
        view.layer.cornerRadius = cornerRadius;
        view.layer.borderColor = [UIColor diceColorWithRed:240 green:240 blue:240 alpha:1].CGColor;
        view.layer.borderWidth = 1.0f;
    }
    //设置图片
    [self setPhotosScrollView];
    //点击隐藏键盘
    [self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    //导航栏
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
}
-(void)setPhotosScrollView {
    float photoWidth = self.photosScrollView.height - PHOTO_MARGIN * 2;
    for (int i=0; i<MAX_IMAGE_COUNT; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * photoWidth + PHOTO_MARGIN * (i + 1), PHOTO_MARGIN, photoWidth, photoWidth)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
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
        
        iv.tag = PHOTO_TAG + i;
        [self.photosScrollView addSubview:iv];
    }
    [self.photosScrollView setContentSize:CGSizeMake(photoWidth * MAX_IMAGE_COUNT + PHOTO_MARGIN * (MAX_IMAGE_COUNT + 1), self.photosScrollView.height)];
}
#pragma mark- 事件
- (IBAction)positionBtnClicked:(id)sender {
}
-(void)commitClicked:(id)sender {
    [self uploadRequest];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTakingOrderSuccessController"]) {
        id vc = segue.destinationViewController;
        [vc setValue:[NSString stringWithFormat:@"%@", _sourceModel.brand] forKey:@"brand"];
        [vc setValue:[NSString stringWithFormat:@"%@", _sourceModel.title] forKey:@"name"];
    }
}
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
                         
                         _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
                         
                         _country = dict[@"Country"];
                         _city = dict[@"City"];
                         [self.postitionBtn setTitle:[NSString stringWithFormat:@" %@ %@", _country, _city] forState:UIControlStateNormal];
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}
//附近位置
- (void)findPosition
{
    NearbyLocationsViewController *nearbyLocationVC = [[NearbyLocationsViewController alloc] init];
    [nearbyLocationVC position:^(NSString *position,NSDictionary *location) {
        NSString *locationStr = [NSString stringWithFormat:@"%@ %@", location[@"country"], location[@"city"]];
        [self.postitionBtn setTitle:locationStr forState:UIControlStateNormal];
        _latitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lat"]];
        _longitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lng"]];
    }];
    nearbyLocationVC.lat = _latitude;
    nearbyLocationVC.lon = _longitude;
    nearbyLocationVC.address = self.postitionBtn.titleLabel.text;
    
    ZZNavigationController *zzNav = [[ZZNavigationController alloc] initWithRootViewController:nearbyLocationVC];
    [self presentViewController:zzNav animated:YES completion:nil];
}
#pragma mark- textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.deliveryTimeTF) {
        [self showDatePickerView];
        return NO;
    }
    return YES;
}
-(void)showDatePickerView{
    [self.view endEditing:YES];
    if (_pickerView == nil) {
        WQDatePickerView *pickerView = [[WQDatePickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT)];
        pickerView.confirmBlock = ^(NSString *date) {
            self.deliveryTimeTF.text = date;
        };
        
        
         _pickerView = pickerView;
    }
    
    _pickerView.frame = CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    [self.view addSubview:_pickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.y = MAIN_NAV_HEIGHT - PICKERVIEW_HEIGHT;
    }];
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
        vc.selectedIndex = iv.tag - PHOTO_TAG;
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
#pragma mark- ActionSheet
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
         [self presentViewController:zYQAssetPicker animated:YES completion:NULL];
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
#pragma mark- CTAssetsPickerController delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
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
        UIImageView *iv = (UIImageView *)[self.view viewWithTag:PHOTO_TAG+i];
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

#pragma mark - Keyboard NSNotification
-(void)listenKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_pickerView cancelClicked:nil];
        self.superSV.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.superSV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark- 请求网络
//提交所有数据
- (void)uploadRequest
{
    NSString *price = [self.priceTF.text trim];
    NSString *deposit = [self.depositTF.text trim];
    NSString *deliveryTime = [self.deliveryTimeTF.text trim];
    NSString *shopland = [self.shoplandTF.text trim];
    NSString *memo = [self.memoTV.text trim];
    
    if (deposit.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写押金"];
        return;
//    }else if (shopland.length == 0) {
//        [AutoDismissAlert autoDismissAlertSecond:@"请填写预计代购地点"];
//        return;
//    }else if (deliveryTime.length == 0) {
//        [AutoDismissAlert autoDismissAlertSecond:@"请填写预计发货时间"];
//        return;
    }
    
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", _latitude ? _latitude : @"",_longitude ? _longitude : @""];
    NSString * position = self.postitionBtn.titleLabel.text;
    if ([position trim].length == 0) {
        xyz = @"0";
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    __block NSDictionary *param = [self parametersForDic:@"accountTaskPost" parameters:@{ACCOUNT_PASSWORD, @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"id":_sourceModel.model_id, @"area":shopland, @"quote":price, @"money":deposit, @"message":memo, @"sendtime": deliveryTime, @"photos": @"", @"uuid": @"0"}];
    if (_imagesArray.count) {
        [CommonHandel uploadPhotoRequest:_imagesArray SucBlock:^(NSString *photoUrl) {
            param = [self parametersForDic:@"accountTaskPost" parameters:@{ACCOUNT_PASSWORD, @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"id":_sourceModel.model_id, @"area":shopland, @"quote":price, @"money":deposit, @"message":memo, @"sendtime": deliveryTime, @"photos": photoUrl, @"uuid": @"0"}];
            [self uploadRequestWithParam:param];
        } FailBlock:^(NSError *error) {
            [_hud removeFromSuperview];
        }];
    }else {
        [self uploadRequestWithParam:param];
    }
}
-(void)uploadRequestWithParam:(NSDictionary *)param {
        [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                //发送通知刷新足迹
                [_hud removeFromSuperview];
                [self performSegueWithIdentifier:@"showTakingOrderSuccessController" sender:self];
            }else{
                [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
                [_hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [_hud removeFromSuperview];
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
