//
//  UIView+Extension.h
//  SinaWeiBo
//
//  Created by zxk on 15/3/31.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGSize size;
@property (nonatomic,assign)CGPoint origin;

-(void)addTapAction:(SEL)action forTarget:(id) aTarget;
@end
