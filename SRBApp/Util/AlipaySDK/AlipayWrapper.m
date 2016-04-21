//
//  AlipayWrapper.m
//  SRBApp
//
//  Created by yujie on 14/12/29.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "AlipayWrapper.h"
#import "AlipaySDK/AlipaySDK.h"
#import "AliOrder.h"
#import "DataSigner.h"

static CompletionBlock s_successBlock;
static CompletionBlock s_failureBlock;

@implementation AlipayWrapper

+ (void) alipaySync:(AliOrder*)order success:(CompletionBlock)success failure:(CompletionBlock)failure {
    s_successBlock = success;
    s_failureBlock = failure;
    NSString *partner = @"2088711541352256";
    NSString *seller = @"shurenbang@shurenbang.net";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALsWCepkZbyAlPbqoNsuLzUISSbu4H1+u9GLJ/zc11MjFJqda10GoA+KCpqB3BAHr00f2Lfn+OQcBulcgXHhw8gFh1Mxm+xFC3iFo4KdHUenHrUUSbhKnVgfDtqzYPosXa7vMesgDboRvOgenVTArDLdfCrwTvIjvfDWabEcttGNAgMBAAECgYAC2hAmoYcne3JJ3UO8c5TGoyyySjvjzdXBGPTwFtG1c7hxruqfDWXNNtZ4ing3Slayv0SHcSLLH14/mmhiuwVH9ZOo1SbTDk3j+OMEgr07TOFgQckfAJCBlE2YC8JELK+ip9B0baNOLIH6FGk5rq8SigZNhf9bA0U7POfTbfFaoQJBAO3YzQH9bjYwqEjaPARP0syzp5uK7bYFpW1Tb7j3WmuG/q7nrDolF2mzuKsfE+FS6pQ+oF6+wRWA6brDXCAE7nkCQQDJXXE4rQu8GQNKHTnYrSh1ytt11F8Ii9+WhkiMp6e1nK/hMNBtiVs1c2GT9aUXiB6/aj7lY9tOPWj2eenuZma1AkAdXDfiWQBz3AnKBHaIKbph3oOAJeQ2JfhHyJbwBEi7IUzrFloiS1XajH7tUMbJd8zRQ/HUAEQhfWpczaTfpvwxAkEAutp4y8zYDM1xHf8MxKG538RD7Y0KOpYA/l7RR6PznjUth9uSLXK+LlVJANF7RuDLF3hxsM7+nBWkJsNubgib2QJBAKZmtcQuaDRoXoNtz/KChkYzMW4MjmxnPxc6FCDk3eCKFJfOHtBslLMaTTjc4IQ2TUeqTVOmxi1YrVKL9tYjav0=";
    
    order.partner = partner;
    order.seller = seller;
    
    order.notifyURL = [NSString stringWithFormat:@"http://mapi.shurenbang.net/pay/alipay/client_notify_url.jsp"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    order.appID = [[NSBundle mainBundle] bundleIdentifier];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"srbapp2088711541352256";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //从网页端支付时回调
            [AlipayWrapper handleResultDic:resultDic];
        }];
    }
}

+ (void) alipaySyncPay:(NSString*)tradeID amount:(CGFloat)amount productName:(NSString*)productName desc:(NSString*)desc orderID:(NSString *)orderID success:(CompletionBlock)success failure:(CompletionBlock)failure {
    AliOrder *order = [[AliOrder alloc] init];
    order.tradeNO = tradeID; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = desc; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    [AlipayWrapper alipaySync:order success:success failure:failure];
}

+ (void) alipaySyncRecharge:(NSString*)orderNum orderID:(NSString *)orderID amount:(CGFloat)amount success:(CompletionBlock)success failure:(CompletionBlock)failure {
    AliOrder *order = [[AliOrder alloc] init];
    order.tradeNO = orderNum; //订单ID（由商家自行制定）
    order.productName = orderNum; //商品标题
    order.productDescription = @"充值"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    [AlipayWrapper alipaySync:order success:success failure:failure];
}

+ (BOOL) handleResult:(NSURL*)resultURL {
    if ([resultURL.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:resultURL standbyCallback:^(NSDictionary *resultDic) {
            [AlipayWrapper handleResultDic:resultDic];
         }];
        return YES;
    } else if ([resultURL.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:resultURL standbyCallback:^(NSDictionary *resultDic) {
            [AlipayWrapper handleResultDic:resultDic];
        }];
        return YES;
    } else {
        return NO;
    }
}

+ (void) handleResultDic:(NSDictionary *)resultDic {
    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
    NSLog(@"process order result = %ld", (long)resultStatus);
    if (resultStatus == 9000) {
        if (s_successBlock) {
            s_successBlock(resultDic);
        }
    } else {
        if (s_failureBlock) {
            s_failureBlock(resultDic);
        }
    }
}
@end
