//
//  EmotionTool.m
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#define RecentEmotionsPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"emotions.archive"]
#import "EmotionTool.h"
#import "Emotion.h"


@implementation EmotionTool
//永远在内存中
static NSMutableArray * _recentEmotions;

//第一次使用此类时,从沙盒加载文件
+ (void)initialize
{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentEmotionsPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

+ (void)addRecentEmotion:(Emotion *)emotion
{

    //删除重复的表情
    //数组删除调用isequal删除
    [_recentEmotions removeObject:emotion];

    //将表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    //写入
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentEmotionsPath];
}

/**
 *  返回装着Emotion模型的数组
 */
+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}

+ (Emotion *)emotionWithChs:(NSString *)chs
{
    NSArray *smileEmotions = [self smileEmotions];
    for (Emotion *emotion in smileEmotions) {
        if ([emotion.code isEqualToString:chs]) return emotion;
    }
    
    NSArray *bellEmotions = [self bellEmotions];
    for (Emotion *emotion in bellEmotions) {
        if ([emotion.code isEqualToString:chs]) return emotion;
    }
    
    NSArray *flowerEmotions = [self flowerEmotions];
    for (Emotion *emotion in flowerEmotions) {
        if ([emotion.code isEqualToString:chs]) return emotion;
    }
    
    return nil;
}

static NSArray *_smileEmotions, *_bellEmotions, *_flowerEmotions;
+ (NSArray *)smileEmotions
{
    if (!_smileEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/smile/info.plist" ofType:nil];
        _smileEmotions = [self objectArr:[NSArray arrayWithContentsOfFile:path]];
    }
    return _smileEmotions;
}

+ (NSArray *)bellEmotions
{
    if (!_bellEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/bells/info.plist" ofType:nil];
        _bellEmotions = [self objectArr:[NSArray arrayWithContentsOfFile:path]];
    }
    return _bellEmotions;
}

+ (NSArray *)flowerEmotions
{
    if (!_flowerEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/flowers/info.plist" ofType:nil];
        _flowerEmotions = [self objectArr:[NSArray arrayWithContentsOfFile:path]];
    }
    return _flowerEmotions;
}

/**
 *  字典转成模型
 *  @param emotionsArrs 字典数组
 *  @return 模型数组
 */
+ (NSArray *)objectArr:(NSArray *)emotionsArrs
{
    NSMutableArray * tempEmotions = [NSMutableArray array];
    for (int i = 0; i < emotionsArrs.count; i++) {
        NSDictionary * tempDic = emotionsArrs[i];
        Emotion * emotion = [[Emotion alloc]init];
        [emotion setValuesForKeysWithDictionary:tempDic];
        [tempEmotions addObject:emotion];
    }
    return tempEmotions;
}

@end
