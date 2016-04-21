//
//  GetColor16.h
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

/*! @brief 16进制颜色转换RGB
 *  @description
 */
#import "ZZBaseObject.h"

@interface GetColor16 : ZZBaseObject
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
@end
