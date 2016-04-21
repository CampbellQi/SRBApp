//
//  ODMViewController.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/30/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com



#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSString *CellIdentifier = @"photoCell";

@protocol ODMCombinationPickerViewControllerDelegate;

@interface ODMCombinationPickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isHideNavigationbar;
    UIStatusBarStyle previousBarStyle;
    //NSIndexPath *currentSelectedIndex;
    //NSIndexPath *previousSelectedIndex;
}
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UIImage *cameraImage;
@property (nonatomic, strong) UIViewController *cameraController;

@property (nonatomic, assign)long maxSelCount;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView *navigationView;
@property (nonatomic, strong) IBOutlet UIButton *navagationTitleButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet UIButton *doneButton;

@property (nonatomic, weak) id<ODMCombinationPickerViewControllerDelegate> delegate;

- (void)fadeStatusBar;
- (id)initWithCombinationPickerNib;

@end

@protocol ODMCombinationPickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image;
- (void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImageArray:(NSArray *)images;
- (void)imagePickerControllerDidCancel:(ODMCombinationPickerViewController *)picker;

@end
