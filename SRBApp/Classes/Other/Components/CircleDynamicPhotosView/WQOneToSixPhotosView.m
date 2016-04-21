//
//  CircleDynamicPhotosView.m
//  tusstar
//
//  Created by zxk on 15/6/5.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "WQOneToSixPhotosView.h"
//#import "ImageViewController.h"

#define HWStatusPhotoWH 70
#define HWStatusPhotoMargin 5
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)
#define HWStatusPhotoWH_OnePic 200

@implementation WQOneToSixPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        UIImageView * photoView = [[UIImageView alloc] init];
        photoView.userInteractionEnabled = YES;
        photoView.clipsToBounds = YES;
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photoView];
        
        UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        [photoView addGestureRecognizer:imgTap];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        photoView.tag = 100 + i;
        if (i < photosCount) { // 显示
            [photoView sd_setImageWithURL:[NSURL URLWithString:self.photos[i]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            photoView.hidden = NO;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
            
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}
-(void)photoTap:(UIGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(wQOneToSixPhotosViewImageTap:)]) {
        [self.delegate wQOneToSixPhotosViewImageTap:(UIImageView *)sender.view];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = HWStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (HWStatusPhotoWH + HWStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (HWStatusPhotoWH + HWStatusPhotoMargin);
        photoView.width = HWStatusPhotoWH;
        photoView.height = HWStatusPhotoWH;
        if (photosCount == 1) {
            photoView.size = CGSizeMake(HWStatusPhotoWH_OnePic, HWStatusPhotoWH_OnePic);
        }
    }
}

- (void)imgClick:(UITapGestureRecognizer *)tap
{
//    ImageViewController * imgVC = [ImageViewController new];
//    UIImageView * img = (UIImageView *)tap.view;
//    int imgIndex = 0;
//    for (int i = 0; i < self.photos.count; i ++) {
//        if ([img isEqual:self.subviews[i]]) {
//            imgIndex = i;
//            break;
//        }
//    }
//    
//    for (UIView * next = [self superview]; next; next= next.superview) {
//        UIResponder * nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            UIViewController * tempVC = (UIViewController *)nextResponder;
//            imgVC.imageArray = [self.photos mutableCopy];
//            imgVC.imgIndex = imgIndex;
//            [tempVC presentViewController:imgVC animated:YES completion:nil];
//            break;
//        }
//    }
    
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    if (count == 1) {
        return CGSizeMake(200, 200);
    }else{
        // 最大列数（一行最多有多少列）
        int maxCols = HWStatusPhotoMaxCol(count);
        
        NSUInteger cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
        
        // 行数
        NSUInteger rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
        
        return CGSizeMake(photosW, photosH);
    }
}
@end
