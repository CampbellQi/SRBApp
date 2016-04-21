//
//  Read Me.h
//  SRBApp
//
//  Created by lizhen on 15/4/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

/**
 * 文件说明：此文件为本APP的第三方平台集成情况说明
 * 如需更改，请详细阅读各平台API
 */

#ifndef SRBApp_Read_Me_h
#define SRBApp_Read_Me_h

/* 1.融云IM即时通讯云平台
 * 头文件引入：appdelegate.m   
 * 初始化方法：- (void)rongCloud
 * 具体参数及配置详见融云官方API http://docs.rongcloud.cn
 */

/* 2.shareSDK登录与分享平台
 * 头文件引入：appdelegate.m
 * 初始化方法：- (void)shareSDK
 * 支持平台类型：新浪微博、腾讯微博、QQ、QQ空间、微信、微信朋友圈、短信
 * 具体参数及配置详见mob官方API http://wiki.mob.com
 */

/* 3.极光推送平台
 * 头文件引入：appdelegate.m
 * 初始化方法：- (void)JPush
 * 具体参数及配置详见极光官方API http://docs.jpush.io/client/ios_sdk/
 */

/* 4.友盟统计平台
 * 头文件引入：appdelegate.m
 * 初始化方法：- (void)umengTrack
 * 具体参数及配置详见友盟官方API http://dev.umeng.com/analytics/ios-doc/integration
 */

/* 5.支付宝平台
 * 头文件引入：AlipayWrapper.h
 * 初始化方法：
 *           1.充值:+ (void) alipaySyncRecharge:(NSString*)orderNum orderID:(NSString *)orderID amount:
 *                   (CGFloat)amount success:(CompletionBlock)success failure:(CompletionBlock)failure
 *           2.支付:+ (void) alipaySyncPay:(NSString*)tradeID amount:(CGFloat)amount productName:
 *                    (NSString*)productName desc:(NSString*)desc orderID:(NSString *)orderID success:
 *                    (CompletionBlock)success
 failure:(CompletionBlock)failure
 * 具体参数及配置详见支付宝官方API https://openhome.alipay.com/doc/docIndex.htm
 */

#endif
