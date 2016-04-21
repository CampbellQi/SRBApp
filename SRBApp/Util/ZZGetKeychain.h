//
//  ZZGetKeychain.h
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"
#import "KeychainItemWrapper.h"

@interface ZZGetKeychain : ZZBaseObject
+(NSDictionary *)getUsernameAndPass;
@end
