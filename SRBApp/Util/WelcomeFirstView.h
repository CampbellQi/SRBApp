//
//  WelcomeFirstView.h
//  SRBApp
//
//  Created by 刘若曈 on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@interface WelcomeFirstView : ZZView
@property (nonatomic, strong)UIButton * button;
@property (nonatomic, strong)UIImageView * image1;
@property (nonatomic, strong)UIImageView * image2;
@property (nonatomic, strong)UIImageView * image3;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UIImageView * view3;
@property (nonatomic, strong)UIPageControl * page;

+ (void)animation:(UIImageView *)imageView;
+ (void)closeView:(UIView *)view;
@end
