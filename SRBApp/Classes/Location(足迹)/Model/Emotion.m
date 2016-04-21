//
//  Emotion.m
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "Emotion.h"

@implementation Emotion
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

/**
 *  从文件中解析对象时调用
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.png = [aDecoder decodeObjectForKey:@"png"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

/**
 *  对象写入文件
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
}
/**
 *  常用来比较两个对象是否一样
 *  @param other 另外一个Emotiond对象
 *  @return
 */
- (BOOL)isEqual:(Emotion *)other
{
    return [self.code isEqualToString:other.code];
}

@end
