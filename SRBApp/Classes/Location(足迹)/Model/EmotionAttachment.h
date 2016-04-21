//
//  EmotionAttachment.h
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionAttachment : NSTextAttachment
@property (nonatomic,strong)Emotion * emotion;
@end
