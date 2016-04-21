//
//  EmotionPageView.m
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionPageView.h"
#import "Emotion.h"
#import "EmotionButton.h"
#import "EmotionPopView.h"
#import "EmotionTool.h"

@interface EmotionPageView ()
/** 点击表情按钮后弹出的放大镜 */
@property (nonatomic,strong)EmotionPopView * popView;
/** 删除按钮 */
@property (nonatomic,weak)UIButton * deleteButton;
@end

@implementation EmotionPageView

- (EmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [EmotionPopView popView];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton * deleteButton = [[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [self addSubview:deleteButton];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;
        
        //添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

/**
 *  根据手指的位置找出对应的表情按钮
 */
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton * btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
            [self.popView showFrom:btn];
            //已经找到手指所在的表情按钮
            return btn;
        }
    }
    return nil;
}

/**
 *  长按手势出发的时候调用
 */
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    EmotionButton * btn = [self emotionButtonWithLocation:location];
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            //移除popView
            [self.popView removeFromSuperview];
            
            //如果手指还在表情按钮上
            if (btn) {
                //发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
        }
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:{
            
            [self.popView showFrom:btn];
            break;
        }
        default:
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        EmotionButton * btn = [EmotionButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        
        //设置表情数据
        btn.emotion = emotions[i];
        //点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //内边距(周围)
    CGFloat inset = 10;
    CGFloat btnW = (self.width - 2 * inset) / EmotionMaxCols;
    CGFloat btnH = (self.height - inset) / EmotionMaxRows;
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.subviews[i+1];
        btn.frame = CGRectMake(inset + (i % 7) * btnW, inset + (i/7) * btnH, btnW, btnH);
    }
    
    //删除按钮
    self.deleteButton.frame = CGRectMake(self.width - inset - btnW, self.height - btnH, btnW, btnH);
}

/**
 *  监听删除按钮的点击
 */
- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidDeleteNotification" object:nil userInfo:nil];
}

/**
 *  监听表情按钮点击
 *  @param btn 被点击的button
 */
- (void)btnClick:(EmotionButton *)btn
{
    [self.popView showFrom:btn];
    
    //popView自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    [self selectEmotion:btn.emotion];
}

/**
 *  选中某个表情,发出通知
 *  @param emotion 被选中的表情
 */
- (void)selectEmotion:(Emotion *)emotion
{
    //将这个表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    //发出通知
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[@"selectedEmotion"] = emotion;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmotionDidSelectNotification" object:nil userInfo:userInfo];
}

@end
