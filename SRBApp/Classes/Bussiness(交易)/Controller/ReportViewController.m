//
//  FeedbackController.m
//  tusstar
//
//  Created by fengwanqi on 15/7/15.
//  Copyright (c) 2015年 zxk. All rights reserved.
//
#define PHOTO_MARGIN 15
#define MAX_IMAGE_COUNT 6

#import "ReportViewController.h"
#import "FAPhotoEditDetailController.h"
#import "StringHelper.h"
#import "WQCheckboxController.h"
#import "LayoutFrame.h"
#import "CommonView.h"
#import "WQPickerView.h"
#import "ODMCombinationPickerViewController.h"

@interface ReportViewController ()<ODMCombinationPickerViewControllerDelegate>
{
    UIImagePickerController* _imagePicker;
    NSMutableArray *_imagesArray;
    NSString *_imagesUrlStr;
    UIImageView *_addPhoto;
    
    MBProgressHUD *_hud;
    WQPickerView *_pickerView;
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    _imagesArray = [NSMutableArray arrayWithCapacity:0];
    _imagesUrlStr = @"";
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    [self.typeView addTapAction:@selector(showPickerView) forTarget:self];
    //[self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [self listenKeyboard];
    [self setUpView];
}

#pragma mark- 页面
-(void)setUpView {
    float photoWidth = self.photoSV.height - 2 * PHOTO_MARGIN;
    for (int i=0; i<6; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * photoWidth + PHOTO_MARGIN * (i + 1), PHOTO_MARGIN, photoWidth, photoWidth)];
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
        [self.photoSV addSubview:iv];
    }
    
    [self.photoSV setContentSize:CGSizeMake(photoWidth * 6 + PHOTO_MARGIN * 7, self.photoSV.height)];
    
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"发 送" Target:self Action:@selector(submitClicked)];
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
-(void)showPickerView{
    if (!_pickerView) {
        NSString *s = @"价格虚假,虚假、违法信息,重复铺货,知识产权侵权,滥用关键字,严重放错类目,要求汇款,照片虚假,图片侵权";
        WQPickerView *pickerView = [[WQPickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) DataArray:[s componentsSeparatedByString:@","]];
        _pickerView = pickerView;
        pickerView.confirmBlock = ^(NSString *selectedItem) {
            self.typeTF.text = selectedItem;
        };
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
        vc.selectedIndex = iv.tag - 100;
        vc.editImageBlock = ^(NSMutableArray *imageArray){
            
            _imagesArray = imageArray;
            [self showImages];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

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
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        //    picker.allowsEditing = YES;//是否可以对原图进行编辑
        picker.maximumNumberOfSelection = MAX_IMAGE_COUNT - _imagesArray.count;
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
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage: asset.aspectRatioThumbnail];
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
-(void)submitClicked {
    NSString * content = [self.contentTV.text trim];
    if (content.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请填举报内容"];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    if (_imagesArray.count) {
        [self uploadPhotoRequest];
    }else {
        [self uploadAllRequest];
    }
    
    
    
}
#pragma mark- 请求网络
//提交所有数据
- (void)uploadAllRequest
{
    NSString * content = [self.contentTV.text trim];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"addPostReport" parameters:@{ACCOUNT_PASSWORD, @"title": @"llaal", @"id":_idNumber, @"msg": content, @"qqNo": @"", @"telNo":_mobileTF.text, @"email":@"",@"photos":_imagesUrlStr}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //        [self post];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
    }andFailureBlock:^{
        
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
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        _imagesUrlStr = [dic objectForKey:@"msg"];
        
        NSLog(@"message: %@", [dic objectForKey:@"message"]);
        
        [self uploadAllRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

//- (IBAction)typeBtnClicked:(id)sender {
//    [self.view endEditing:YES];
//    [self showPickerView];
//    [WQCheckboxController showWithSourceData:@[@"价格虚假",@"虚假、违法信息",@"重复铺货",@"知识产权侵权",@"滥用关键字",@"严重放错类目",@"要求汇款", @"照片虚假",@"图片侵权"] Message:@"类型" CurrentSelItem:_typeBtn.titleLabel.text SelectItemBlock:^(NSString *selectItem) {
//        [_typeBtn setTitle:selectItem forState:UIControlStateNormal];
//    }];
    
//}

#pragma mark- 监听键盘
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
        [LayoutFrame showViewConstraint:self.mobileBgView AttributeBottom:keyBoardRect.size.height];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        [LayoutFrame showViewConstraint:self.mobileBgView AttributeBottom:86];
        
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)lakaiBtn:(id)sender {
    [self showPickerView];
}
@end
