//
//  CustomTabBarBtn.h
//  SRBApp
//
//  Created by lizhen on 15/1/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TabButton.h"

@interface CustomTabBarBtn : TabButton
@property (nonatomic,strong)NSIndexPath * indexpath;

- (CGRect)imageRectForContentRect:(CGRect)contentRect;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
@end

