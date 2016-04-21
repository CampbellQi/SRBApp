//
//  ChangeSizeOfNSString.h
//  SRBApp
//
//  Created by zxk on 15/3/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZBaseObject.h"

@interface ChangeSizeOfNSString : ZZBaseObject
+ (NSInteger)returnIndexWithStr:(NSString *)toBeString;
+ (int)convertToInts:(NSString *)str;
+ (BOOL)stringContainsEmoji:(NSString *)string;
@end
