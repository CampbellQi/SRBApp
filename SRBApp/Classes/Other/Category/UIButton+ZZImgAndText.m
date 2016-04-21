//
//  UIButton+ZZImgAndText.m
//  SRBApp
//
//  Created by zxk on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "UIButton+ZZImgAndText.h"

@implementation UIButton (ZZImgAndText)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    CGRect rect = self.imageView.frame;
    rect.size.width = 15;
    rect.size.height = 15;
    self.imageView.frame = rect;
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0, 0.0, 0.0, -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];

    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}
@end
