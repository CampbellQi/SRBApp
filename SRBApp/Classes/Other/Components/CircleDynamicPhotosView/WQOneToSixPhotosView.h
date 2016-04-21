//
//  CircleDynamicPhotosView.h
//  tusstar
//
//  Created by zxk on 15/6/5.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQOneToSixPhotosView;

@protocol WQOneToSixPhotosViewViewDelegate <NSObject>

-(void)wQOneToSixPhotosViewImageTap:(UIImageView *)sender;

@end

/**
 *  我的圈子动态  配图
 */
@interface WQOneToSixPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic,assign)id<WQOneToSixPhotosViewViewDelegate>delegate;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;

@end
