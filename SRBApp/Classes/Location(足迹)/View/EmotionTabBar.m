//
//  EmotionTabBar.m
//  SRBApp
//
//  Created by zxk on 15/4/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionTabBar.h"
#import "TabButton.h"

@interface EmotionTabBar ()
@property (nonatomic,weak)UIButton * selectedBtn;
@end

@implementation EmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBtn:@"最近" buttonType:EmotionTabBarButtonTypeRecent];
        [self setupBtn:@"Smile" buttonType:EmotionTabBarButtonTypeSmile];
        [self setupBtn:@"Bell" buttonType:EmotionTabBarButtonTypeBells];
        [self setupBtn:@"Flower" buttonType:EmotionTabBarButtonTypeFlowers];
    }
    return self;
}

- (TabButton *)setupBtn:(NSString *)title buttonType:(EmotionTabBarButtonType)buttonType
{
    
    TabButton * btn = [[TabButton alloc]init];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn setTitleColor:WHITE forState:UIControlStateNormal];


    [btn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"bg_button_white"] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];

    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)setDelegate:(id<EmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    [self btnClick:(TabButton *)[self viewWithTag:EmotionTabBarButtonTypeSmile]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置按钮frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        TabButton * btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

/**
 *  按钮点击
 */
- (void)btnClick:(UIButton *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    //通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:(EmotionTabBarButtonType)btn.tag];
    }
}

@end
