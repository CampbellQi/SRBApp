//
//  ZZKeychainSingleton.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZKeychainSingleton.h"

@implementation ZZKeychainSingleton
+(id)sharedKeychain
{
    static ZZKeychainSingleton * keychain = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        keychain = [[ZZKeychainSingleton alloc]init];
    });
    return keychain;
}
@end
