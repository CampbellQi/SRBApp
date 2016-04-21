//
//  ChangeSizeOfNSString.m
//  SRBApp
//
//  Created by zxk on 15/3/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ChangeSizeOfNSString.h"

@implementation ChangeSizeOfNSString

+ (NSInteger)returnIndexWithStr:(NSString *)toBeString
{
    __block NSInteger tempIndex = 0;
    __block int length = 0;
    
    [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
        if ([tempData length] == 3) {
            length += 2;
        }else if ([tempData length] >= 4){
            length += 4;
        }
        else{
            length += 1;
        }
        if (length > 12) {
            *stop = YES;
        }
        tempIndex = substringRange.location;
    }];
    return tempIndex;
}

+ (int)convertToInts:(NSString *)str
{
    __block int length = 0;
    
    NSString * tempStr = str;
    [tempStr enumerateSubstringsInRange:NSMakeRange(0, tempStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
        if ([tempData length] == 3) {
            length += 2;
        }else if ([tempData length] >= 4){
            length += 4;
        }
        else{
            length += 1;
        }
        
    }];
    
    return length;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
     return returnValue;
}

@end
