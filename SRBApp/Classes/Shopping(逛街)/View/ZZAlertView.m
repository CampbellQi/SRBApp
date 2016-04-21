//
//  ZZAlertView.m
//  SRBApp
//
//  Created by zxk on 15/4/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZAlertView.h"


@interface ZZAlertView ()
/**
 *  @brief  背景view
 */
@property (nonatomic,strong)UIView * bgView;
/**
 *  @brief  提示文字
 */
@property (nonatomic,strong)UILabel * alertLabel;
/**
 *  @brief  确定按钮
 */
@property (nonatomic,strong)UIButton * sureBtn;
/**
 *  @brief  取消按钮
 */
@property (nonatomic,strong)UIButton * cancelBtn;
/**
 *  @brief  黑色背景
 */
@property (nonatomic,strong)UIView * blackView;

@end

@implementation ZZAlertView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blackView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bgView];
         self.sureBtn.frame = CGRectMake(15, self.bgView.height - 45, self.bgView.width - 30, 30);
        [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

+ (instancetype)zzAlertView
{
    return [[self alloc]init];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - 100)/2, SCREEN_WIDTH - 40, 100)];
        _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        _bgView.layer.cornerRadius = 6;
        _bgView.layer.masksToBounds = NO;
        _bgView.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(4, 3);
        _bgView.layer.shadowOpacity = 0.8;
        
    }
    return _bgView;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 2;
        [_sureBtn setTitleColor:WHITE forState:UIControlStateNormal];
        [_sureBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
        [self.bgView addSubview:_sureBtn];
    }
    return _sureBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"img_cancel"] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(self.bgView.width - 25, 5, 20, 20);
        [self.bgView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.bgView.width, 20)];
        _alertLabel.font = SIZE_FOR_IPHONE;
        _alertLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:_alertLabel];
    }
    return _alertLabel;
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blackView.alpha = 0.2;
        [self addSubview:_blackView];
    }
    return _blackView;
}

/**
 *  @brief  消失
 */
- (void)dismiss
{
    [self removeFromSuperview];
}

/**
 *  @brief  设置确定按钮点击事件
 *  @param target 调用哪个对象
 *  @param action 调用target的哪个方法
 */
- (void)setSureBtnEvent:(id)target action:(SEL)action
{
    [self.sureBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  @brief  显示的文字
 *  @param str NSString
 */
- (void)setAlertWord:(NSString *)str
{
    self.alertLabel.text = str;
}

/**
 *  @brief  显示alertView
 */
- (void)showAlert
{
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    self.frame = window.bounds;
}
@end
