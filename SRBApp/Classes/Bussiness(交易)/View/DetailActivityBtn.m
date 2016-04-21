//
//  DetailActivityBtn.m
//  SRBApp
//
//  Created by liying on 15/11/9.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define IMAGE_WIDTH 23
#define IMAGE_HEIGHT 23
#import "DetailActivityBtn.h"

@interface DetailActivityBtn ()
@property (nonatomic,assign)CGSize titleSize;
@end

@implementation DetailActivityBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat btnX = (contentRect.size.width - IMAGE_WIDTH - self.titleSize.width) / 2;
    return CGRectMake(btnX, (contentRect.size.height - IMAGE_HEIGHT)/2, IMAGE_WIDTH, IMAGE_HEIGHT);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize titleSize = [self.currentTitle sizeWithFont:SetFont(TitleFont)];
    self.titleSize = titleSize;
    CGFloat titleX = (contentRect.size.width - IMAGE_WIDTH - self.titleSize.width)/2 + IMAGE_WIDTH + 5;
    CGFloat titleY = (contentRect.size.height - self.titleSize.height)/2;
    //return CGRectMake(titleX+3, 0, titleSize.width, contentRect.size.height);
    return CGRectMake(titleX+5, titleY, titleSize.width, titleSize.height);
}

@end
