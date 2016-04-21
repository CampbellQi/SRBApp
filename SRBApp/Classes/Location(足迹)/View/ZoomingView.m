//
//  ZoomingView.m
//  Car
//
//  Created by lizhen on 14-10-23.
//  Copyright (c) 2014年 Lizhen. All rights reserved.
//

#import "ZoomingView.h"

@implementation ZoomingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        
    }
    return self;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
