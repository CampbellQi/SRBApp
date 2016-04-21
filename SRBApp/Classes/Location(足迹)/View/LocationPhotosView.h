//
//  LocationPhotosView.h
//  SRBApp
//
//  Created by zxk on 15/5/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationModel;

@interface LocationPhotosView : UIView
@property (nonatomic,strong)LocationModel * locationModel;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(LocationModel *)locationModel;
@end
