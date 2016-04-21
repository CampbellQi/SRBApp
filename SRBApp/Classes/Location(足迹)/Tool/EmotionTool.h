//
//  EmotionTool.h
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
@class Emotion;
@interface EmotionTool : ZZBaseObject
+ (void)addRecentEmotion:(Emotion *)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)smileEmotions;
+ (NSArray *)bellEmotions;
+ (NSArray *)flowerEmotions;
/**
 *  通过表情描述找到对应的表情
 *
 *  @param chs 表情描述
 */
+ (Emotion *)emotionWithChs:(NSString *)chs;
@end
