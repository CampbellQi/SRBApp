//
//  LeftImgAndRightTitleBtn.h
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftImgAndRightTitleBtn : UIButton
@property (nonatomic,strong)NSIndexPath * indexpath;

- (CGRect)imageRectForContentRect:(CGRect)contentRect;
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
@end
