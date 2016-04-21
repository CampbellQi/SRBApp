//
//  ZZTextPart.m
//  SRBApp
//
//  Created by zxk on 15/4/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTextPart.h"

@implementation ZZTextPart
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}
@end
