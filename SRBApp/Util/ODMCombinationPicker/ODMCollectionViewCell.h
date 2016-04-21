//
//  ODMCollectionViewCell.h
//  CombinationPickerContoller
//
//  Created by allfake on 7/31/14.
//  Copyright (c) 2014 Opendream. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface ODMCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

- (void)setHightlightBackground:(BOOL)isSelected withAimate:(BOOL)animate;
- (void)setNormalBackground:(BOOL)animate;
- (void)setHightlightBackground;

-(void)showSelectedIV;
-(void)hideSelectedIV;
@end
