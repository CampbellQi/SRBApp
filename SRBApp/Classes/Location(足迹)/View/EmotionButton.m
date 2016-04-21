//
//  EmotionButton.m
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionButton.h"
#import "Emotion.h"

@implementation EmotionButton
/**
 *  当控件不是从xib,storyboard中创建时,调用这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  当控件从xib,storyboard中创建时,调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    self.adjustsImageWhenHighlighted = NO;
}

/**
 *  在initWithCoder调用完毕后,调用这个方法
 */
- (void)awakeFromNib
{
    
}

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    if (emotion.png) {//有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }
//    else if (emotion.code){//是emoji表情
//        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
//    }
}

@end
