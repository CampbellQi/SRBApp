//
//  Singleton.m
//  SRBApp
//
//  Created by zxk on 15/2/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
+ (Singleton *)sharedInstance
{
    static Singleton * singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleton = [[Singleton alloc]init];
    });
    return singleton;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pinglunTap = NO;
        _isShow = NO;
        _isScrolling = NO;
    }
    return self;
}

@end
