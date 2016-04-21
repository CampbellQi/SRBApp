//
//  NSString+calculateSize.m
//  testAutolayout
//
//  Created by fengwanqi on 15/10/27.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "NSString+CalculateSize.h"

@implementation NSString (CalculateSize)
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}
- (CGSize)calculateSize:(CGSize)size Attributes:(NSDictionary *)attributes {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:14.0]
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}
@end
