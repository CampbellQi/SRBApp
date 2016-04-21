//
//  ZZGetKeychain.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZGetKeychain.h"

@implementation ZZGetKeychain
+(NSDictionary *)getUsernameAndPass
{
    KeychainItemWrapper * keychain = [[KeychainItemWrapper alloc]initWithIdentifier:@"account" accessGroup:@"com.shurenbang"];
    NSString * name = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString * password = [keychain objectForKey:(__bridge id)kSecValueData];
    NSDictionary * dic = @{@"name":name,@"pwd":password};
    return dic;
}
@end
