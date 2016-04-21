//
//  CustomBtn.h
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBtn : UIButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
@end
