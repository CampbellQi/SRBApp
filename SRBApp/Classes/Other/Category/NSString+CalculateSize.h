//
//  NSString+calculateSize.h
//  testAutolayout
//
//  Created by fengwanqi on 15/10/27.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (CalculateSize)
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
- (CGSize)calculateSize:(CGSize)size Attributes:(NSDictionary *)attributes;
@end
