//
//  ZZTextPart.h
//  SRBApp
//
//  Created by zxk on 15/4/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZTextPart : ZZBaseObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为人名 */
@property (nonatomic, assign, getter = isSpecialName)BOOL specialName;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion)BOOL emotion;
/** 是否为链接 */
@property (nonatomic,assign,getter=isLink)BOOL link;
@end
