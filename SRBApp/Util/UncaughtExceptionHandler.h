//
//  UncaughtExceptionHandler.h
//  SRBApp
//
//  Created by zxk on 15/2/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface UncaughtExceptionHandler : ZZBaseObject
{
    BOOL dismissed;
}
void InstallUncaughtExceptionHandler();
@end
