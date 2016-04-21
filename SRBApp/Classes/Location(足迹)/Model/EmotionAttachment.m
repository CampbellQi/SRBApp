//
//  EmotionAttachment.m
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"

@implementation EmotionAttachment
- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end
