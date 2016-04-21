//
//  EmotionPageView.h
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

//一行最多是7列
#define EmotionMaxCols 7
//一页中最多3行
#define EmotionMaxRows 3
//每页表情个数
#define ZZEmotionPageSize ((EmotionMaxRows * EmotionMaxCols) - 1)

@interface EmotionPageView : UIView
/**
 *  这一页显示的表情
 */
@property (nonatomic,strong)NSArray * emotions;
@end
