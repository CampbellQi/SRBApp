//
//  LocationPhotosView.m
//  SRBApp
//
//  Created by zxk on 15/5/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationPhotosView.h"
#import "LocationModel.h"
#import "TapImageView.h"

#define LocationPhotoWH 72
#define LocationPhotoMargin 3

#define LocationPhotoMaxWH 200
//最大列数
#define LocationPhotoMaxCol(count) ((count == 4)?2:3)

@implementation LocationPhotosView

- (void)setLocationModel:(LocationModel *)locationModel
{
    _locationModel = locationModel;
    NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
    NSInteger photosCount = photosArr.count;
    
    //创建足够数量的图片控件
    while (self.subviews.count < photosCount) {
        TapImageView * photoView =[[TapImageView alloc]init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
    }
    
    //遍历所有图片控件,设置图片
    for (int i = 0; i < self.subviews.count; i++) {
        TapImageView * photoView = self.subviews[i];
        if (photosCount == 1) {
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            photoView.clipsToBounds = NO;
        }
        if (i < photosCount) {
            photoView.hidden = NO;
            NSString * photoStr = photosArr[i];
            //设置图片
            [photoView sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        }else{
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置图片的尺寸和位置
    NSArray * photosArr = [self.locationModel.photos componentsSeparatedByString:@","];
    NSInteger photosCount = photosArr.count;
    NSInteger maxCol = LocationPhotoMaxCol(photosCount);
    for (int i = 0; i < photosCount; i++) {
        TapImageView * photoView = self.subviews[i];
        if (photosCount == 1) {//一张图片的时候尺寸
            photoView.x = 0;
            photoView.y = 0;
            photoView.size = [self onScreenPointSizeOfImageInImageView:self.locationModel];
        }else{
            int col = i % maxCol;
            photoView.x = col * (LocationPhotoWH + LocationPhotoMargin);
            
            int row = i / maxCol;
            photoView.y = row * (LocationPhotoWH + LocationPhotoMargin);
            photoView.width = LocationPhotoWH;
            photoView.height = LocationPhotoWH;
        }
    }
}

/**
 *  根据服务器返回的尺寸计算图片的尺寸,按比例缩放
 */
-(CGSize)onScreenPointSizeOfImageInImageView:(LocationModel *)locationModel{
    if (locationModel.width != nil && ![locationModel.width isEqualToString:@""] && locationModel.height != nil && ![locationModel.height isEqualToString:@""] &&  ![locationModel.width isEqualToString:@"0"] && ![locationModel.height isEqualToString:@"0"]) {
        CGFloat scale;
        CGFloat width = [locationModel.width floatValue];
        CGFloat height = [locationModel.height floatValue];
        //200是图片最大长,宽
        if (width > height) {
            scale = width / LocationPhotoMaxWH;
        } else {
            scale = height / LocationPhotoMaxWH;
        }
        return CGSizeMake(width / scale, height / scale);
    }else{
        return CGSizeMake(LocationPhotoMaxWH, LocationPhotoMaxWH);
    }
    
}

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(LocationModel *)locationModel
{
    NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
    if (photosArr.count == 1) {
        return [[[LocationPhotosView alloc]init] onScreenPointSizeOfImageInImageView:locationModel];
    }else{
        
        //最大列数
        NSInteger maxCols = LocationPhotoMaxCol(photosArr.count);
        
        //列数
        NSInteger cols = photosArr.count > 2 ? maxCols : photosArr.count;
        CGFloat photosW = cols * LocationPhotoWH + (cols - 1) * LocationPhotoMargin;
        
        //行数
        NSInteger rows = (photosArr.count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * LocationPhotoWH + (rows - 1) * LocationPhotoMargin;
        
        return CGSizeMake(photosW, photosH);
    }
}

@end
