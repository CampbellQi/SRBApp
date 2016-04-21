//
//  OrderImageAddController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/20.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define PHOTO_MARGIN 15
#define LINE_PHOTO_COUNT 3

#define MAX_IMAGE_COUNT 7

#import "OrderImageAddController.h"
#import "CommonHandel.h"
#import "CommonView.h"
#import "ODMCombinationPickerViewController.h"

@interface OrderImageAddController ()<ODMCombinationPickerViewControllerDelegate>
{
    NSMutableArray *_imagesArray;
    MBProgressHUD *_hud;
}
@end

@implementation OrderImageAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"补充图片";
    _imagesArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"fb_xj.png"], nil];
    
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    //左导航
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    //右导航
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"发 送" Target:self Action:@selector(uploadPhotsView)];
    //设置照相显示
    [self setPhotosView];
}
//设置图片显示
-(void)setPhotosView {
    float width = (SCREEN_WIDTH - (LINE_PHOTO_COUNT + 1) * PHOTO_MARGIN)/LINE_PHOTO_COUNT;
    for (int i=0; i<_imagesArray.count; i++) {
        float x = i % LINE_PHOTO_COUNT * (width + PHOTO_MARGIN) + PHOTO_MARGIN;
        float y = i / LINE_PHOTO_COUNT * (width + PHOTO_MARGIN) + PHOTO_MARGIN;
        UIView *view = [self createPhotoViewWithFrame:CGRectMake(x, y, width, width) Image:_imagesArray[i] Tag:100 + i];
        if (i==0) {
            [view addTapAction:@selector(showPhotoAlertSheet) forTarget:self];
        }
        [self.contentSV addSubview:view];
    }
    
    self.contentSV.contentSize = CGSizeMake(CGRectGetWidth(self.contentSV.frame), (_imagesArray.count / LINE_PHOTO_COUNT + 1) * (width + PHOTO_MARGIN) + PHOTO_MARGIN);
}
//生产图片和删除按钮混合view
-(UIView *)createPhotoViewWithFrame:(CGRect)frame Image:(UIImage *)image Tag:(int)tag{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.tag = tag;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:view.bounds];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = image;
    [view addSubview:iv];
    if (tag != 100) {
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [delBtn setImage:[UIImage imageNamed:@"order_imageUpload_delete"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:delBtn];
    }
    
    view.userInteractionEnabled = YES;
    return view;
}
#pragma mark- 事件
//删除
-(void)deletePhoto:(UIButton *)sender {
    if (sender.superview.tag == 100) {
        return;
    }
    for (UIView *view in self.contentSV.subviews) {
            [view removeFromSuperview];
    }
    [_imagesArray removeObjectAtIndex:sender.superview.tag - 100];
    
    [self setPhotosView];
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 添加照片
#pragma mark- ActionSheet
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_imagesArray.count < MAX_IMAGE_COUNT) {
            [_imagesArray addObject:image];
            [self setPhotosView];
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
        [self setPhotosView];
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
    [self setPhotosView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_imagesArray addObject:image];
        [self setPhotosView];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- 网络请求
-(void)uploadPhotsView {
    [_imagesArray removeObjectAtIndex:0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发布中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    _hud = hud;
    [CommonHandel uploadPhotoRequest:_imagesArray SucBlock:^(NSString *photoUrl) {
        [self uploadRequest:photoUrl];
        
    } FailBlock:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}
-(void)uploadRequest:(NSString *)photos {
    NSDictionary * param = [self parametersForDic:@"accountBidPostPurchase" parameters:@{ACCOUNT_PASSWORD, @"id": self.spOrderID, @"goodsId": self.goodsID, @"code": @"yes", @"photos": photos, @"uuid": @"0"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPPurchaseSuccessNF" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.backBlock) {
                self.backBlock();
            }
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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
