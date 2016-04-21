//
//  RCInterruptMessage.h
//  iOS-IMKit
//
//  Created by xugang on 15/1/12.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCMessageContent.h"

#define RCInterruptMessageTypeIdentifier @"RC:SpMsg"

@interface RCSuspendMessage : RCMessageContent<RCMessageCoding,RCMessagePersistentCompatible>



-(instancetype)init;

@end
