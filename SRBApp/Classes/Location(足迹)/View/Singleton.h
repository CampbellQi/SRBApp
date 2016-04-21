//
//  Singleton.h
//  SRBApp
//
//  Created by zxk on 15/2/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
/**
 *  @brief  判断是否评论的单例
 */
@interface Singleton : ZZBaseObject
@property (nonatomic,assign)BOOL pinglunTap;
@property (nonatomic,assign)BOOL isShow;
/** 足迹列表是否正在滚动 */
@property (nonatomic,assign)BOOL isScrolling;
+ (Singleton *)sharedInstance;
@end
