//
//  Emotion.h
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
/**
 *  表情plist文件的model
 */
@interface Emotion : ZZBaseObject<NSCoding>
/** 表情的图片名 */
@property (nonatomic,copy)NSString * png;
/** emoji表情的16进制编码 */
@property (nonatomic,copy)NSString * code;
@end
