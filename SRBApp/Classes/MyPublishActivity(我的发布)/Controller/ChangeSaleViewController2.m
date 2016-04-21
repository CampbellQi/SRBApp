//
//  ChangeSaleViewController2.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define MAX_IMAGE_COUNT 6
#define PHOTO_MARGIN 10
#import "CommonView.h"
#import "CommonHandel.h"

#import "ChangeSaleViewController2.h"
#import "FAPhotoEditDetailController.h"
#import "StringHelper.h"
#import "OrderImageAddController.h"
#import "DetailModel.h"
#import "ODMCombinationPickerViewController.h"

@interface ChangeSaleViewController2 ()<ODMCombinationPickerViewControllerDelegate>
{
    UIImagePickerController* _imagePicker;
    NSMutableArray *_imagesArray;
    UIImageView *_addPhoto;
    
    MBProgressHUD * _hud;
    
    UIButton *_backBtn;
    UIButton *_publishBtn;
}
@property (nonatomic, strong) NSString *city;//城市

@property (nonatomic, strong) CLLocationManager *locMgr;

@property (nonatomic, strong) NSString *detailAddress;//具体地址
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度

//修改商品时使用
@property (nonatomic, strong)DetailModel *detailModel;
@end

@implementation ChangeSaleViewController2
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
-(id)init {
    if (self = [super init]) {
        _isFromPublish = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imagesArray = [NSMutableArray arrayWithCapacity:0];
    [self setUpView];
    
    [self listenKeyboard];
    
    [self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    
    if (self.goodsID) {
        //修改商品
        self.title = @"修改商品";
        [self loadGoodsDetail];
    }
}
#pragma mark- 数据
-(void)fillDataWithDetailModel:(DetailModel *)model {
    self.detailModel = model;
    self.brandTF.text = model.brand;
    self.nameTF.text = model.title;
    self.sizeTF.text = model.size;
    self.priceTF.text = model.originalPrice;
    self.stockTF.text = model.storage;
    self.freightTF.text = model.transportPrice;
    self.leaveMsgTV.text = model.content;
    
    if (model.photos.length) {
        [_imagesArray addObjectsFromArray:[model.photos componentsSeparatedByString:@","]];
        [self showImages];
    }
}


#pragma mark- 页面
-(void)setUpView {
    //左导航
    UIBarButtonItem *backBBI = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    _backBtn = backBBI.customView;
    self.navigationItem.leftBarButtonItem = backBBI;
    //右导航
    UIBarButtonItem *publishBBI = [CommonView rightWithBgBarButtonItemTitle:@"发 布" Target:self Action:@selector(uploadRequest)];
    _publishBtn = publishBBI.customView;
    self.navigationItem.rightBarButtonItem = publishBBI;
    
    //图片
    [self setPhotosScrollView];
    //提示语
    self.noticetitleLbl.text = @"温馨提示：";
    self.noticeLbl.text = @"在这不允许发广告，添加微信、QQ等个人信息的文字和图片，不允许发同样的内容！\n发现违规信息，小邦会立即删除，严重者会被禁言拉黑。\nps:点头像可以进入个人主页的哟，么么哒";
    //self.noticeBgView.layer.cornerRadius = 2;
}
-(void)setPhotosScrollView {
    float photoWidth = self.photosScrollView.height - 2 * PHOTO_MARGIN;
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
        
        iv.tag = 100 + i;
        [self.photosScrollView addSubview:iv];
    }
    [self.photosScrollView setContentSize:CGSizeMake(photoWidth * MAX_IMAGE_COUNT + PHOTO_MARGIN * (MAX_IMAGE_COUNT + 1), self.photosScrollView.height)];
}
#pragma mark- 事件
//返回
-(void)backBtnClicked {
    if (self.brandTF.text.length == 0 && self.nameTF.text.length == 0 && _imagesArray.count == 0) {
        [self dismiss];
    }else {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismiss];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
-(void)dismiss {
    if (_isFromPublish) {
        [self.navigationController dismissViewController];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark- alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self dismiss];
    }
}
#pragma 添加照片
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
            if ([_imagesArray[i] isKindOfClass:[UIImage class]]) {
                //通过添加图片加入的
                iv.image = [_imagesArray objectAtIndex:i];
            }else {
                //获取详情后从网络获取的
                [iv sd_setImageWithURL:[NSURL URLWithString:_imagesArray[i]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            }
            
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
                         self.locationTF.text = self.detailAddress;
                         self.locationTF.textColor = [GetColor16 hexStringToColor:@"#646464"];
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}
#pragma mark - Keyboard NSNotification
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
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
#pragma mark- 请求网络
-(void)goOrderImageAddVC {
    OrderImageAddController *vc = [[OrderImageAddController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//提交所有数据
- (void)uploadRequest
{
    //[self goOrderImageAddVC];
    //return;
    NSString *brand = [self.brandTF.text trim];
    NSString *name = [self.nameTF.text trim];
    NSString *size = [self.sizeTF.text trim];
    NSString *leaveMsg = [self.leaveMsgTV.text trim];
    
    NSString *price = [self.priceTF.text trim];
    NSString *stock = [self.stockTF.text trim];
    NSString *freight = [self.freightTF.text trim];
    if (_imagesArray.count == 0)
    {
        [AutoDismissAlert autoDismissAlertSecond:@"请至少上传一张图片"];
        return;
    }
    if (brand.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写品牌"];
        return;
    }else if (brand.length > 20) {
        [AutoDismissAlert autoDismissAlertSecond:@"品牌请限制在20个字以内"];
        return;
    }
    if (name.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写名称"];
        return;
    }else if (name.length > 20) {
        [AutoDismissAlert autoDismissAlertSecond:@"名称请限制在20个字以内"];
        return;
    }
    if (size.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写规格"];
        return;
    }
    if (price.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写宝贝售价"];
        return;
    }
    if (![self.priceTF.text floatValue] > 0.01||![self.priceTF.text floatValue] == 0.01){
        NSLog(@"%f",[self.priceTF.text floatValue]);
        [AutoDismissAlert autoDismissAlertSecond:@"宝贝售价不能低于0.01"];
        return;
    }
    if (stock.length == 0){
        [AutoDismissAlert autoDismissAlertSecond:@"请填写宝贝库存"];
        return;
    }else if ([self.stockTF.text intValue] < 1){
        [AutoDismissAlert autoDismissAlertSecond:@"宝贝库存不能为0"];
        return;
    }
    
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", _latitude ? _latitude : @"",_longitude ? _longitude : @""];
    NSString * position = self.locationTF.text;
    if ([position trim].length == 0) {
        xyz = @"0";
    }
    
    [self.view endEditing:YES];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    _publishBtn.userInteractionEnabled = NO;
    _backBtn.userInteractionEnabled = NO;
    
    NSString *requestUrl = @"accountCreatePost";
    NSString *photos = @"";
    if (self.goodsID && self.detailModel) {
        //修改商品
        requestUrl = @"accountUpdatePost";
    }
    
    //判断除了网络请求图片外是否从相册或者拍照加入了新照片
    NSMutableArray *tempArray = [NSMutableArray new];
    NSMutableArray *tempArray2 = [NSMutableArray new];
    for (id obj in _imagesArray) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [tempArray addObject:obj];
        }else {
            [tempArray2 addObject:obj];
        }
    }
    
    photos = [tempArray2 componentsJoinedByString:@","];
    __block NSDictionary *param = [self parametersForDic:requestUrl parameters:@{ACCOUNT_PASSWORD, @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"dealType":@"1", @"originalPrice":price, @"brand":brand, @"title":name, @"size":size,@"content":leaveMsg, @"storage":stock, @"transportPrice":freight, @"photos": photos,@"uuid": @"0"}]; 
    
    if (tempArray.count) {
        [CommonHandel uploadPhotoRequest:tempArray SucBlock:^(NSString *photoUrl) {
            param = [self parametersForDic:requestUrl parameters:@{ACCOUNT_PASSWORD, @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"dealType":@"1", @"originalPrice":price, @"brand":brand, @"title":name, @"size":size,@"content":leaveMsg, @"storage":stock, @"transportPrice":freight, @"photos": photos.length == 0 ? photoUrl : [photoUrl stringByAppendingFormat:@",%@", photos], @"uuid": @"0"}];
            [self uploadRequestWithParam:param];
        } FailBlock:^(NSError *error) {
            [_hud removeFromSuperview];
            _publishBtn.userInteractionEnabled = YES;
            _backBtn.userInteractionEnabled = YES;
        }];
    }else {
        [self uploadRequestWithParam:param];
    }
}
-(void)uploadRequestWithParam:(NSDictionary *)param {
    if ((self.goodsID && self.detailModel)) {
        //修改商品-加入原来商品id
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:param[@"parameters"]];
        NSString *method = param[@"method"];
        [parameters setObject:self.goodsID forKey:@"id"];
        //[parameters setObject:@"320" forKey:@"categoryID"];
        param = [self parametersForDic:method parameters:parameters];
    }else if (self.spOrderID) {
        //商品报价-加入原来求购单id
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:param[@"parameters"]];
        NSString *method = param[@"method"];
        
        [parameters setObject:self.spOrderID forKey:@"id"];
        [parameters setObject:@"320" forKey:@"categoryID"];
        param = [self parametersForDic:method parameters:parameters];
    }
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
        
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //直接发布商品
            if (_isFromPublish) {
                [_hud removeFromSuperview];
                [self dismiss];
                if (self.backBlock) {
                    self.backBlock();
                }
            }else {
                if (_spOrderID) {
                    [self bundingSPOderAndGoodsRequest:dic[@"data"][@"id"]];
                }else {
                    [self dismiss];
                    if (self.backBlock) {
                        self.backBlock();
                    }
                }
                
            }
            
            
        }else{
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
            [_hud removeFromSuperview];
        }
    } andFailureBlock:^{
        [_hud removeFromSuperview];
        _publishBtn.userInteractionEnabled = YES;
        _backBtn.userInteractionEnabled = YES;
    }];
}
//发布商品绑定商品和求购单id
-(void)bundingSPOderAndGoodsRequest:(NSString *)goodsID {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBidPostDeal" parameters:@{ACCOUNT_PASSWORD, @"id": _spOrderID, @"goodsId": goodsID}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [_hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self dismiss];
            if (self.backBlock) {
                self.backBlock();
            }
            if ((self.goodsID && self.spOrderID && self.detailModel) || self.spOrderID) {
                //修改商品完成发通知刷新我的代购-待报价
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SPGoodsUpdatedNF" object:nil];
            }
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
        }
    } andFailureBlock:^{
        [_hud removeFromSuperview];
    }];
}
//获取商品详情
-(void)loadGoodsDetail {
    if (self.goodsID == nil || [self.goodsID isEqualToString:@""] || self.goodsID.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"商品已下架"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取商品详情中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": self.goodsID}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [hud removeFromSuperview];
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            DetailModel *model = [[DetailModel alloc]init];
            [model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self fillDataWithDetailModel:model];
        }else{
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
    }andFailureBlock:^{
        [hud removeFromSuperview];
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
