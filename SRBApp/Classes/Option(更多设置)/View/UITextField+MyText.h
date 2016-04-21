//
//  UITextField+MyText.h
//  SRBApp
//
//  Created by zxk on 15/3/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MyText)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
