//
//  AlipayWrapper.h
//  SRBApp
//
//  Created by yujie on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(NSDictionary *resultDic);

@interface AlipayWrapper : NSObject

+ (void) alipaySyncPay:(NSString*)tradeID amount:(CGFloat)amount productName:(NSString*)productName desc:(NSString*)desc orderID:(NSString *)orderID success:(CompletionBlock)success failure:(CompletionBlock)failure;
+ (void) alipaySyncRecharge:(NSString*)orderNum orderID:(NSString *)orderID amount:(CGFloat)amount success:(CompletionBlock)success failure:(CompletionBlock)failure;

+ (BOOL) handleResult:(NSURL*)resultURL;

@end
