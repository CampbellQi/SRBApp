//
//  ZZKeychainSingleton.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ZZKeychainSingleton : ZZBaseObject
@property (nonatomic,copy)NSString * userName;
@property (nonatomic,copy)NSString * password;

+ (id)sharedKeychain;
@end
