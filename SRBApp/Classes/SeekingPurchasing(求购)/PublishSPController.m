//
//  PublishSPurchasingController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define MAX_IMAGE_COUNT 1
#import "PublishSPController.h"
#import "StringHelper.h"
#import "CommonView.h"
#import "NearbyLocationsViewController.h"
#import "AppDelegate.h"
#import "UIImage+Compress.h"
#import "PublishSPSucessController.h"
#import "CropController.h"
#import "TPMarkModel.h"
#import "WQMarkView.h"
#import "WQGuideView.h"
#import "ODMCombinationPickerViewController.h"

@interface PublishSPController ()<ODMCombinationPickerViewControllerDelegate>
{
    NSString *_imagesUrlStr;
    MBProgressHUD *_hud;
    NSString *_country;
    NSString *_city;
    NSString *_latitude;
    NSString *_longitude;
    
    UIImage *_coverImage;
    
    TPMarkModel *_addedTPMarkModel;
    UIButton *_publishBtn;
    UIButton *_backBtn;
}
@property (nonatomic, strong)CLLocationManager *locMgr;
@end

@implementation PublishSPController
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
    [_locMgr stopUpdatingLocation];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启定位
    [self.locMgr startUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self fillData];
    
    [self.openBtn addTarget:self action:@selector(openUpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendsBtn addTarget:self action:@selector(openUpClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- 数据
-(void)fillData {
    if (self.soureMarkModel) {
//        self.brandTF.text = self.soureMarkModel.brand;
//        self.nameTF.text = self.soureMarkModel.name;
//        //原产地
//        self.provenanceTF.text = self.soureMarkModel.origin;
//        //参考价
//        self.referencePriceTF.text = self.soureMarkModel.shopprice;
        
        //规格
        self.specificationsTF.text = self.soureMarkModel.size;
        
        [self showMarkView:_soureMarkModel];
    }
    if (_coverImageUrl) {
        [self.coverIV sd_setImageWithURL:[NSURL URLWithString:_coverImageUrl] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
    }
}
-(void)setSourceBussinessModel:(BussinessModel *)sourceBussinessModel {
    _sourceBussinessModel = sourceBussinessModel;
    
//    self.brandTF.text = self.soureMarkModel.brand;
//    self.nameTF.text = self.soureMarkModel.name;
//    //原产地
//    self.provenanceTF.text = self.soureMarkModel.origin;
//    //参考价
//    self.referencePriceTF.text = self.soureMarkModel.shopprice;
//    
//    //规格
//    self.specificationsTF.text = self.soureMarkModel.size;
}
#pragma mark- 页面
-(void)setUpView {
    self.title = @"求购单";
    UIBarButtonItem *leftBBI = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    UIBarButtonItem *rightBBI = [CommonView rightWithBgBarButtonItemTitle:@"发 布" Target:self Action:@selector(publishBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    _publishBtn = rightBBI.customView;
    _backBtn = leftBBI.customView;
    [self listenKeyboard];
    [self.superSV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    [self.coverIV addTapAction:@selector(showPhotoAlertSheet) forTarget:self];
    
    
}
#pragma mark- 事件
//发布
-(void)publishBtnClicked {
    NSString *brand = @"";
    NSString *name = @"";
    if (self.soureMarkModel) {
        brand = self.soureMarkModel.brand;
        name = self.soureMarkModel.name;
    }else if (_addedTPMarkModel) {
        brand = _addedTPMarkModel.brand;
        name = _addedTPMarkModel.name;
    }
    
    //NSString *specifications = [self.specificationsTF.text trim];
    NSString *numbers = [self.numbersTF.text trim];
    //NSString *location = [self.locationTF.text trim];
    
//    if (specifications.length == 0) {
//        [self.specificationsTF becomeFirstResponder];
//        [AutoDismissAlert autoDismissAlert:@"请填写规格"];
//        return;
//    }
    if (_coverImage == nil && _soureMarkModel == nil) {
        [AutoDismissAlert autoDismissAlert:@"请上传图片"];
        return;
    }
    if (numbers.length == 0) {
        [self.numbersTF becomeFirstResponder];
        [AutoDismissAlert autoDismissAlert:@"请填写数量"];
        return;
    }

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    [self.view endEditing:YES];
    
    _publishBtn.userInteractionEnabled = NO;
    _backBtn.userInteractionEnabled = NO;
    if (_coverImage) {
        [self uploadPhotoRequest];
    }else {
        [self uploadAllRequest];
    }
    
    
    
}
//公开，熟人
- (void)openUpClicked:(UIButton *)sender {
    self.friendsBtn.selected = NO;
    self.openBtn.selected = NO;
    sender.selected = !sender.selected;
}
//返回
-(void)backBtnClicked{
    //规格
    NSString *specifications = [self.specificationsTF.text trim];
    //数量
    NSString *numbers = [self.numbersTF.text trim];
    //期望到手价格
    NSString * expectedPrice = [self.expectedPriceTF.text trim];
    if (!_soureMarkModel && specifications.length ==0 && numbers.length == 0 && expectedPrice.length == 0&&_coverImage == nil) {
        [self backAction];
    }else {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self backAction];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
-(void)backAction {
    if (_isFromPublish) {
        [self.navigationController dismissViewController];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- 跳转
//发布成功
-(void)showSuccess {
    NSString *brand = @"";
    NSString *name = @"";
    if (self.soureMarkModel) {
        brand = self.soureMarkModel.brand;
        name = self.soureMarkModel.name;
    }else if (_addedTPMarkModel) {
        brand = _addedTPMarkModel.brand;
        name = _addedTPMarkModel.name;
    }
    
    if (down_IOS_8) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
        PublishSPSucessController *vc = [sb instantiateViewControllerWithIdentifier:@"PublishSPSucessController"];
        vc.name = [NSString stringWithFormat:@"%@,%@", brand, name];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        vc.isFromPublish = self.isFromPublish;
    }else {
        [self performSegueWithIdentifier:@"showRecommendVC" sender:self];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *brand = @"";
    NSString *name = @"";
    if (self.soureMarkModel) {
        brand = self.soureMarkModel.brand;
        name = self.soureMarkModel.name;
    }else if (_addedTPMarkModel) {
        brand = _addedTPMarkModel.brand;
        name = _addedTPMarkModel.name;
    }
    
    if ([segue.identifier isEqualToString:@"showRecommendVC"]) {
        PublishSPSucessController *vc= segue.destinationViewController;
        [vc setValue:[NSString stringWithFormat:@"%@,%@", brand, name] forKey:@"name"];
        vc.isFromPublish = self.isFromPublish;
    }
}
//标签选择
-(void)showAddTopicMarks:(UIImage *)image {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AddTopicMark" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = sb.instantiateInitialViewController;
    CropController *crop = nav.childViewControllers[0];
    crop.sourceImage = image;
    crop.marksCount = 1;
    crop.comleteBlock = ^(UIImage *image, NSArray *marksArray) {
        _coverImage = image;
        if (marksArray.count >= 1) {
            _addedTPMarkModel = marksArray[0];
//            self.brandTF.text = _addedTPMarkModel.brand;
//            self.nameTF.text = _addedTPMarkModel.name;
//            //原产地
//            self.provenanceTF.text = _addedTPMarkModel.origin;
//            //参考价
//            self.referencePriceTF.text = _addedTPMarkModel.shopprice;
            
            //规格
            self.specificationsTF.text = _addedTPMarkModel.size;
            
            for (UIView *view in self.coverIV.subviews) {
                [view removeFromSuperview];
            }
            
            [self showMarkView:_addedTPMarkModel];
            
        }
        
        self.coverIV.image = image;
    };
    
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)showMarkView:(TPMarkModel *)model {
    WQMarkView *mark = [WQMarkView produceWithData:model];
    NSArray *xyz = [model.xyz componentsSeparatedByString:@","];
    mark.currentPoint = CGPointMake([xyz[0] floatValue] * SCREEN_WIDTH, [xyz[1] floatValue] * (SCREEN_WIDTH * 3.0 / 4.0));
    [self.coverIV addSubview:mark];
    [mark resetCenter];
    mark.isFreeze = YES;
}
#pragma mark- textfield delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.locationTF) {
        return NO;
    }
    return NO;
}
#pragma mark- alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
       [self backAction];
    }
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
                         self.locationTF.text = [NSString stringWithFormat:@"%@ %@", _country, _city];
                         
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
        self.locationTF.text = [NSString stringWithFormat:@"%@ %@", location[@"country"], location[@"city"]];
        _latitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lat"]];
        _longitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lng"]];
    }];
    nearbyLocationVC.lat = _latitude;
    nearbyLocationVC.lon = _longitude;
    nearbyLocationVC.address = self.locationTF.text;
    
    ZZNavigationController *zzNav = [[ZZNavigationController alloc] initWithRootViewController:nearbyLocationVC];
    [self presentViewController:zzNav animated:YES completion:nil];
}

#pragma mark- 调用相册，相机上传图片
#pragma mark- ActionSheet

-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
    
}
-(void)showPhotoAlertSheet {
    if (_coverImageUrl) {
        //不是自己发起的代购不可编辑
        return;
    }
    [self.view endEditing:YES];
    
    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] init];
    vc.delegate = self;
    //vc.maxSelCount = MAX_IMAGE_COUNT - _imagesArray.count;
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
        zYQAssetPicker.maximumNumberOfSelection = 1;
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

#pragma mark - Assets Picker Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    ALAsset *asset = assets[0];
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
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
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
    
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

#pragma mark- 请求网络
//提交所有数据
- (void)uploadAllRequest
{
    NSString *brand = @"";
    NSString *name = @"";
    //原产地
    NSString *provenance = @"";
    //参考价
    NSString *referencePrice = @"";
    
    if (self.soureMarkModel) {
        brand = self.soureMarkModel.brand;
        name = self.soureMarkModel.name;
        provenance = self.soureMarkModel.origin;
        referencePrice = self.soureMarkModel.shopprice;
    }else if (_addedTPMarkModel) {
        brand = _addedTPMarkModel.brand;
        name = _addedTPMarkModel.name;
        provenance = _addedTPMarkModel.origin;
        referencePrice = _addedTPMarkModel.shopprice;
    }
    if (!brand) {
        brand = @"";
    }
    if (!name) {
        name = @"";
    }
    if (!provenance) {
        provenance = @"";
    }
    if (!referencePrice) {
        referencePrice = @"";
    }
    //规格
    NSString *specifications = [self.specificationsTF.text trim];
    //数量
    NSString *numbers = [self.numbersTF.text trim];
    //期望到手价格
    NSString * expectedPrice = [self.expectedPriceTF.text trim];
    NSString * expectedSite = [self.expectedSiteTF.text trim];
    NSString *leaveMsg = [self.leaveMsgTV.text trim];
    NSString *teamView = @"100";
    if (_openBtn.selected) {
        teamView = @"111";
    }
    if (_coverImageUrl) {
        _imagesUrlStr = _coverImageUrl;
    }
    
    NSDictionary *labelDict = nil;
    if (self.soureMarkModel) {
        labelDict = [self.soureMarkModel transToDict];
    }else if (_addedTPMarkModel) {
        labelDict = [_addedTPMarkModel transToDict];
    }
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", _latitude ? _latitude : @"",_longitude ? _longitude : @""];
    NSString * position = self.locationTF.text;
    NSString *positionsign = @"1";
    if ([self.locationTF.text trim].length == 0) {
        positionsign = @"0";
    }else {
        positionsign = @"1";
        if (position.length == 0) {
            positionsign = @"0";
        }
    }
    NSDictionary *param = nil;
    
    if ([positionsign isEqualToString:@"0"]) {
        xyz = @"0";
    }
    
    param = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"dealType":@"4", @"categoryID":@"256", @"size": specifications,@"storage":numbers, @"originalPrice": expectedPrice, @"shopland": expectedSite, @"uuid":@"0", @"photos":_imagesUrlStr ? _imagesUrlStr : @"", @"say": leaveMsg, @"teamView": teamView, @"labels": @[labelDict], @"parentId": self.parentId ? self.parentId : @"0", @"causeId": self.causeId ? self.causeId : @"0", @"brand":brand, @"title":name, @"tags": [NSString stringWithFormat:@"%@,%@", brand, name], @"birthland":provenance,
                                                                     @"marketPrice":referencePrice}];

    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
        if ([result isEqualToString:@"0"]) {
            //发送通知刷新足迹
            [_hud removeFromSuperview];
            //[self performSegueWithIdentifier:@"SPListcontroller" sender:self];
            
            [self showSuccess];
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

            NSData *imageData = [_coverImage compressAndResize];
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        
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
