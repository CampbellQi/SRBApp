//
//  EmotionPopView.h
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion,EmotionButton;

@interface EmotionPopView : UIView
- (void)showFrom:(EmotionButton *)btn;
+ (instancetype)popView;
@end
