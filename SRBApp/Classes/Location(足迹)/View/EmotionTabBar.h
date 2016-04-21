//
//  EmotionTabBar.h
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EmotionTabBarButtonTypeRecent,  //最近
    EmotionTabBarButtonTypeSmile, //默认
    EmotionTabBarButtonTypeBells,   //emoji
    EmotionTabBarButtonTypeFlowers     //发送
}EmotionTabBarButtonType;

/**
 *  表情键盘底部选项卡
 */
@class EmotionTabBar;
@protocol EmotionTabBarDelegate <NSObject>

- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType;
 @end

@interface EmotionTabBar : UIView
@property (nonatomic,weak)id<EmotionTabBarDelegate> delegate;
@end
