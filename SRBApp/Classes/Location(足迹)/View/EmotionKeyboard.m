//
//  EmotionKeyboard.m
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "Emotion.h"
#import "EmotionTool.h"

@interface EmotionKeyboard()<EmotionTabBarDelegate>
/** 容纳表情内容的控件 */
//@property (nonatomic,weak)UIView * contentView;
/** 正在显示的内容 */
@property (nonatomic,strong)EmotionListView * showingListView;
/** 表情内容 */
@property (nonatomic,strong)EmotionListView * recentlistView;
@property (nonatomic,strong)EmotionListView * smileListView;
@property (nonatomic,strong)EmotionListView * bellsListView;
@property (nonatomic,strong)EmotionListView * flowersListView;
/** tabbar */
@property (nonatomic,weak)EmotionTabBar * tabBar;
@end

@implementation EmotionKeyboard
#pragma mark - 懒加载
- (EmotionListView *)recentlistView
{
    if (!_recentlistView) {
        self.recentlistView = [[EmotionListView alloc]init];
    }
    return _recentlistView;
}

- (EmotionListView *)smileListView
{
    if (!_smileListView) {
        self.smileListView = [[EmotionListView alloc]init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/smile/info.plist" ofType:nil];
        NSArray * defaultEmotions = [NSArray arrayWithContentsOfFile:path];
        self.smileListView.emotions = [self objectArr:defaultEmotions];
    }
    return _smileListView;
}

- (EmotionListView *)bellsListView
{
    if (!_bellsListView) {
        self.bellsListView = [[EmotionListView alloc]init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/bells/info.plist" ofType:nil];
        NSArray * emojiEmotions = [NSArray arrayWithContentsOfFile:path];
        self.bellsListView.emotions = [self objectArr:emojiEmotions];
    }
    return _bellsListView;
}

- (EmotionListView *)flowersListView
{
    if (!_flowersListView) {
        self.flowersListView = [[EmotionListView alloc] init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"EmotioniconsPlist/flowers/info.plist" ofType:nil];
        NSArray * emojiEmotions = [NSArray arrayWithContentsOfFile:path];
        self.flowersListView.emotions = [self objectArr:emojiEmotions];
    }
    return _flowersListView;
}

/**
 *  字典转成模型
 *  @param emotionsArrs 字典数组
 *  @return 模型数组
 */
- (NSArray *)objectArr:(NSArray *)emotionsArrs
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //tabbar
        EmotionTabBar * tabBar = [[EmotionTabBar alloc]init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
//        //监听表情选中的通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"EmotionDidSelectNotification" object:nil];
    }
    return self;
}

//- (void)emotionDidSelect
//{
//    self.recentlistView.emotions = [EmotionTool recentEmotions];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //tabbar
    self.tabBar.height = 37;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.x = 0;
    self.tabBar.width = self.width;
    
    //表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
    
//    //设置frame
//    UIView * child = [self.contentView.subviews lastObject];
//    child.frame = self.contentView.bounds;
}

#pragma mark - EmotionTabBarDelegate
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType
{
    //移除contentView之前显示的控件
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.showingListView removeFromSuperview];
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent: //最近
        {
            //加载沙盒中的数据
            self.recentlistView.emotions = [EmotionTool recentEmotions];
            [self addSubview:self.recentlistView];
            break;
        }
        case EmotionTabBarButtonTypeSmile: //微笑
        {
            [self addSubview:self.smileListView];
            break;
        }
        case EmotionTabBarButtonTypeBells: //Bells
        {
            [self addSubview:self.bellsListView];
            break;
        }
        case EmotionTabBarButtonTypeFlowers: //花
        {
            [self addSubview:self.flowersListView];
            break;
        }
    }
    self.showingListView = [self.subviews lastObject];
    //重新计算子控件的frame;
    [self setNeedsLayout];

}

@end
