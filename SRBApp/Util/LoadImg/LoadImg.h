//
//  LoadImg.h
//  SRBApp
//
//  Created by zxk on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
#import "JTSlideShadowAnimation.h"

@interface LoadImg : ZZView
@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)MyLabel * wordLabel;
@property (nonatomic,strong)UIButton * wordBtn;
@property (strong, nonatomic) JTSlideShadowAnimation *shadowAnimation;
- (void)imgStart;
- (void)imgStop;
@end
