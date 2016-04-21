//
//  LocationTextView.h
//  SRBApp
//
//  Created by zxk on 15/4/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSpecial.h"
@class LocationTextView;
@protocol LocationTextViewDelegate <UITextViewDelegate>
/**
 跳转到标签页
 */
- (void)pushToLocationTagView:(NSString *)tag withLocationTextView:(LocationTextView *)locationTextView;
- (void)pushToViewGoodsID:(NSString *)goodsID Moudle:(NSString *)moudle withLocationTextView:(LocationTextView *)locationTextView;

@end


@interface LocationTextView : UITextView
{
    CGPoint beginPoint;
}
/** 所有的特殊字符串(里面存放着HWSpecial) */
@property (nonatomic,strong)NSArray * specials;
@property (nonatomic,weak)id<LocationTextViewDelegate>delegate;
/**
 找出被触摸的特殊字符串
 */
- (ZZSpecial *)touchingSpecialWithPoint:(CGPoint)point;
@end
