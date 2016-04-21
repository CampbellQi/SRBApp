//
//  PublishTopicController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define keyImage @"topicImage"
#define keyContent @"topicContent"
#define keyImageUrl @"topicImageUrl"
#define MAXDESC_COUNT 60

#define TopicCellContent_Default @"请填写配图描述~"
#define DESC_PLACEHOLDER  @"必填，请不要超过60个字哦~"

#import "PublishTopicController.h"
#import "UIColor+Dice.h"
#import "PublishTopicCell.h"
#import "LayoutFrame.h"
#import "CreateSignViewController.h"
#import "NearbyLocationsViewController.h"
#import "TopicDetailListController.h"
#import "UIImage+Compress.h"

@interface PublishTopicController ()
{
    long _editTopicIndex;
    NSMutableArray *_publishDataArray;
    MBProgressHUD *_hud;
    UIButton *_publishBtn;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度
//@property (nonatomic, strong) NSString *latitudeHad;//纬度
//@property (nonatomic, strong) NSString *longitudeHad;//经度
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSString *detailAddress;//具体地址
@property (nonatomic, strong) NSMutableArray * imageArr;//存地址的数组
@end

@implementation PublishTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发布话题";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self setTopicIndex:0 Image:nil Content:nil];
    _editTopicIndex = 0;
    [self listenKeyboard];
    [self setUpView];
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启定位
    [self.locMgr startUpdatingLocation];
}
#pragma mark- 界面
-(void)setUpView {
    self.title = @"发布话题";
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //右导航
    UIColor *pColor = [UIColor diceColorWithRed:227.0 green:95.0 blue:147.0 alpha:1];
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.layer.cornerRadius = 4.0f;
    [publishBtn setBackgroundColor:[UIColor whiteColor]];
    publishBtn.frame = CGRectMake(15, 0, 60, 25);
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    publishBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [publishBtn addTarget:self action:@selector(publishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn setTitleColor:pColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    _publishBtn  = publishBtn;
    //头部，尾部
    self.tableView.tableFooterView = self.footerTopView;
    self.tableView.tableHeaderView = self.headerTopView;
    
    //位置
    self.locationSuperView.layer.cornerRadius = 4.0f;
    self.locationSuperView.layer.borderColor = pColor.CGColor;
    self.locationSuperView.layer.borderWidth = 1.0f;
    //添加图片文字
    self.addMoreBtn.layer.cornerRadius = 4.0f;
    self.addMoreBtn.layer.borderColor = [UIColor diceColorWithRed:226 green:226 blue:226 alpha:1].CGColor;
    self.addMoreBtn.layer.borderWidth = 1.0f;
}
//发布话题成功还原页面
-(void)clearInput {
    self.titleTF.text = @"";
    self.markTF.text = @"";
    self.descTV.text = DESC_PLACEHOLDER;
    self.descTV.textColor = TV_PLACEHOLDER_COLOR;
    [self.dataArray removeAllObjects];
    [self setTopicIndex:0 Image:nil Content:nil];
    [self.tableView reloadData];
}
#pragma mark- 数据
-(void)setTopicIndex:(NSInteger)index Image:(UIImage *)image Content:(NSString *)content {
    NSMutableDictionary *dict = nil;
    if (self.dataArray.count > index) {
        dict = _dataArray[index];
    }else {
        dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.dataArray addObject:dict];
    }
    if (image) {
        [dict setObject:image forKey:keyImage];
    }
    if (content) {
        [dict setObject:content forKey:keyContent];
    }
    //[self.dataArray replaceObjectAtIndex:index withObject:dict];
    //[self.tableView reloadData];
}
#pragma mark- 事件
- (void)backBtn:(UIButton *)sender
{
    if (self.titleTF.text.length == 0 && [self.descTV.text isEqualToString:DESC_PLACEHOLDER] && self.markTF.text.length == 0 && _dataArray.count < 2) {
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
-(void)publishBtnClicked {
    [self uploadRequest];
}
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
- (IBAction)addMoreBtnClicked:(id)sender {
    [self setTopicIndex:self.dataArray.count Image:nil Content:nil];
    [self.tableView reloadData];
}

- (IBAction)addMarkBtnClicked:(id)sender {
    CreateSignViewController * createSignVC = [[CreateSignViewController alloc]init];
    createSignVC.isTopicMark = YES;
    createSignVC.signStr = self.markTF.text;
    createSignVC.completeBlock = ^(NSString *signStr) {
        self.markTF.text = signStr;

    };
    [self.navigationController pushViewController:createSignVC animated:YES];
}

- (IBAction)shareWeiboBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}
- (IBAction)shareWeiXinBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}
//添加话题图片
-(void)addTopicImage:(UIGestureRecognizer *)gr {
    UIView *view = gr.view;
    _editTopicIndex = view.tag - 100;
    [self.view endEditing:YES];
    [self showPhotoAlertSheet];
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
//附近位置
- (void)findPosition
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
#pragma mark- 调用相册，相机上传图片
#pragma mark- ActionSheet
-(void)showPhotoAlertSheet {
    [self.view endEditing:YES];
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
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        //    picker.allowsEditing = YES;//是否可以对原图进行编辑
        picker.maximumNumberOfSelection = 1;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        //uploadnum = arr.count;
        picker.delegate = self;
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        //    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.selsectArray];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
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
    ALAsset *asset = assets[0];
    UIImage *image = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullResolutionImage]];
    [self setTopicIndex:_editTopicIndex Image:image Content:nil];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self setTopicIndex:_editTopicIndex Image:image Content:nil];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark- textfield delegate 
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag >= 200) {
        if (textField.text.length > 0) {
            [self setTopicIndex:textField.tag - 200 Image:nil Content:textField.text];
        }
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.markTF) {
        [self addMarkBtnClicked:nil];
        return NO;
    }
    return YES;
}
#pragma mark- textview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView != self.descTV) {
        if ([textView.text isEqualToString:TopicCellContent_Default]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }else {
        if ([textView.text isEqualToString:DESC_PLACEHOLDER]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView != self.descTV) {
        if (textView.text.length == 0) {
            textView.text = TopicCellContent_Default;
            textView.textColor = TV_PLACEHOLDER_COLOR;
        }
        if (![textView.text isEqualToString:TopicCellContent_Default]) {
            [self setTopicIndex:textView.tag - 200 Image:nil Content:textView.text];
        }
    }else {
        if (textView.text.length == 0) {
            textView.text = DESC_PLACEHOLDER;
            textView.textColor = TV_PLACEHOLDER_COLOR;
        }
    }
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.locationTV) {
        [self findPosition];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView == self.descTV) {
//        if (textView.text.length > MAXDESC_COUNT)
//        {
//            textView.text = [textView.text substringToIndex:MAXDESC_COUNT];
//        }
//        //NSString  * nsTextContent=textView.text;
//    }
    
    
}
#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PublishTopicCell";
    PublishTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.IV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTopicImage:)]];
        cell.contentTV.delegate = self;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (dic[keyImage]) {
        cell.IV.image = dic[keyImage];
    }else if(indexPath.row == 0) {
        cell.IV.image = [UIImage imageNamed:@"publish_topic_addImage0"];
    }else {
        cell.IV.image = [UIImage imageNamed:@"publish_topic_addImage1"];
    }
    if (dic[keyContent]) {
        cell.contentTV.text = dic[keyContent];
        cell.contentTV.textColor = [UIColor blackColor];
    }else {
        cell.contentTV.text = TopicCellContent_Default;
        cell.contentTV.textColor = TV_PLACEHOLDER_COLOR;
    }
    cell.contentTV.tag = indexPath.row + 200;
    cell.IV.tag = indexPath.row + 100;
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 1) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
#pragma mark- alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController dismissViewController];
    }
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
        [LayoutFrame showViewConstraint:self.tableView AttributeBottom:keyBoardRect.size.height];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [LayoutFrame showViewConstraint:self.tableView AttributeBottom:0];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}
//键入Done时，插入换行符，然后执行addBookmark
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //判断加上输入的字符，是否超过界限
    NSString *str = [NSString stringWithFormat:@"%@", self.descTV.text];
    if (str.length > 60)
    {
        textView.text = [textView.text substringToIndex:60];
        [AutoDismissAlert autoDismissAlert:@"简介不能超过60字"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                              
//                                                        message:@"简介不能超过60字"
//                              
//                                                       delegate:nil
//                              
//                                              cancelButtonTitle:@"知道了"
//                              
//                                              otherButtonTitles:nil, nil];
//        
//        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark- 网络请求
- (void)uploadRequest {
    NSString *title = self.titleTF.text;
    NSString *desc = self.descTV.text;
    NSString *mark = self.markTF.text;
    [_descTV resignFirstResponder];
    if (title.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写标题"];
        [self.titleTF becomeFirstResponder];
        return;
    }
    if (mark.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写标签"];
        return;
    }
    if (desc.length == 0 || [desc isEqualToString:DESC_PLACEHOLDER]) {
        [self.descTV becomeFirstResponder];
        [AutoDismissAlert autoDismissAlertSecond:@"请填写简介"];
        return;
    }
//    if (desc.length > MAXDESC_COUNT) {
//        [AutoDismissAlert autoDismissAlertSecond:[NSString stringWithFormat:@"话题内容不能超过%d个字哦",MAXDESC_COUNT]];
//        return;
//    }

    [self.view endEditing:YES];
    _publishDataArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.dataArray) {
        NSString *content = dict[keyContent];
        UIImage *image = dict[keyImage];
        if (content && !image) {
            [AutoDismissAlert autoDismissAlertSecond:@"请上传配图"];
            return;
        }
            if (!content && image) {
                [AutoDismissAlert autoDismissAlertSecond:@"请填写配图描述"];
                return;
        //}
//        if ((!content && image) || (content && !image)) {
//            [AutoDismissAlert autoDismissAlertSecond:@"上传栏目的图片和内容都不能为空"];
//            return;
        }else if (content && image) {
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:content, keyContent, image, keyImage, nil];
            [_publishDataArray addObject:tempDict];
        }
    }
    if (_publishDataArray.count == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写一组配图描述"];
        return;
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    [self uploadPhotoRequest];
}
-(void)uploadAllRequest {
    NSString *title = self.titleTF.text;
    NSString *desc = self.descTV.text;
    NSString *mark = self.markTF.text;
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", self.latitude ? self.latitude : @"",self.longitude ? self.longitude : @""];
    NSString * position = self.locationTV.text;
    if (position.length == 0) {
        position = @"";
    }
    NSString *positionsign = @"1";
    if (self.locationSelectedIV.hidden) {
        positionsign = @"0";
    }else {
        positionsign = @"1";
        if (position.length == 0) {
            positionsign = @"0";
        }
    }
    NSMutableArray *goods = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in _publishDataArray) {
        NSDictionary *tempDict = @{ACCOUNT_PASSWORD, @"dealType":@"3", @"content":dic[keyContent], @"photos": dic[keyImageUrl] ? dic[keyImageUrl] : @"", @"uuid":@"0", @"categoryID":@"254"};
        [goods addObject:tempDict];
    }
    NSDictionary *mainDict = goods[0];
    [goods removeObjectAtIndex:0];
    
    NSDictionary *param = nil;
    if ([positionsign isEqualToString:@"1"]) {
        //拼接post参数
        param = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"3", @"xyz":xyz, @"position":position, @"city":_city ? _city : @"", @"positionView":@"1", @"title":title, @"description":desc, @"categoryID":@"251", @"tags":mark, @"content": mainDict[@"content"], @"photos": mainDict[@"photos"], @"goods": goods, @"uuid":@"0"}];
        
        
    }else {
        param = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"3", @"xyz":@"0", @"position":@"0", @"city":@"", @"positionView":@"0", @"title":title, @"description":desc, @"categoryID":@"251", @"content": mainDict[@"content"], @"photos": mainDict[@"photos"], @"tags":mark, @"goods": goods, @"uuid":@"0"}];
    }
    _publishBtn.userInteractionEnabled = NO;
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        _publishBtn.userInteractionEnabled = YES;
        [_hud removeFromSuperview];
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [self clearInput];
            //NSDictionary * tempdic = [dic objectForKey:@"data"];
            [AutoDismissAlert autoDismissAlertSecond:@"发布成功"];
            TopicDetailListController *detail = [[TopicDetailListController alloc] init];
            NSDictionary *data = [dic objectForKey:@"data"];
            detail.modelId = data[@"id"];
            [self.navigationController pushViewController:detail animated:YES];
            //[self.navigationController dismissViewController];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
    }];
}
-(void)uploadPhotoRequest {
    
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_REALPICTURE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSDictionary *dict in _publishDataArray) {
            UIImage *image = dict[keyImage];
            NSData *imageData = [image compressAndResize];
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        NSString * str = [dic objectForKey:@"msg"];
        //        NSString * str1 = [str substringWithRange:NSMakeRange(48, 36)];
        NSLog(@"%@",str);
        NSLog(@"message: %@", [dic objectForKey:@"message"]);
        NSArray *tempArray = [str componentsSeparatedByString:@","];
        for (int i=0; i<tempArray.count; i++) {
            if (i < _publishDataArray.count) {
                NSMutableDictionary *dict = _publishDataArray[i];
                [dict setObject:tempArray[i] forKey:keyImageUrl];
            }
        }
        [self uploadAllRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_hud removeFromSuperview];
        //[UIAlertView autoDismissAlert:@"上传失败"];
        //[HUD removeFromSuperview];
    }];
}
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
//

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
