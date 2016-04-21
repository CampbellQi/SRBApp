//
//  LCCircleButton.m
//  BillsTool
//
//  Created by JD on 11/3/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "FANavigationBar.h"
#import "UIColor+Dice.h"

@implementation FANavigationBar
@synthesize leftButton  = _leftButton;
@synthesize titleLabel  = _titleLabel;
@synthesize rightButton = _rightButton;

- (id)initWithLeftImage:(UIImage *)left withTitle:(NSString *)title rightImage:(UIImage *)right
{
    if (self = [self init]) {
        self.left = left;
        self.right = right;
        self.title = title;
    }
    return self;
}
- (id)initWithLeftImage:(UIImage *)left withTitle:(NSString *)title rightText:(NSString *)right
{
    if (self = [self init]) {
        self.left = left;
        self.rightText = right;
        self.title = title;
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor diceColorWithRed:236 green:236 blue:236 alpha:1];
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        
        NSMutableArray *constraints = [NSMutableArray array];
        NSDictionary *views = @{@"leftButton":self.leftButton,@"titleLabel":self.titleLabel,@"rightButton":self.rightButton};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftButton(44)]-3-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(44)]-3-|" options:0 metrics:nil views:views]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightButton(44)]-3-|" options:0 metrics:nil views:views]];
        [self addConstraints:constraints];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setLeft:(UIImage *)left
{
    [self.leftButton setImage:left forState:UIControlStateNormal];
}

- (void)setRight:(UIImage *)right
{
    [self.rightButton setImage:right forState:UIControlStateNormal];
    NSDictionary *views = @{@"leftButton":self.leftButton,@"titleLabel":self.titleLabel,@"rightButton":self.rightButton};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftButton(44)]-[titleLabel]-[rightButton(44)]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];

}

- (void)setRightText:(NSString *)rightText
{
    [self.rightButton setTitle:rightText forState:UIControlStateNormal];
    [self.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    NSDictionary *views = @{@"leftButton":self.leftButton,@"titleLabel":self.titleLabel,@"rightButton":self.rightButton};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[leftButton(44)]-46-[titleLabel]-[rightButton(80)]-10-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];

}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UIButton *)leftButton
{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.backgroundColor = [UIColor clearColor];
        _leftButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_leftButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorFromString:@"#414152"];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _titleLabel;
}


- (UIButton *)rightButton
{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.backgroundColor = [UIColor clearColor];
        [_rightButton addTarget:self action:@selector(onTouch:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:[UIColor colorFromString:@"999999"] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorFromString:@"#414152"] forState:UIControlStateHighlighted];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:36];
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightButton;
}

#pragma mark -
- (void)onTouch:(id)sender
{
    if (sender == self.leftButton) {
        if ([_delegate respondsToSelector:@selector(leftButtonDidTouch)]) {
            [_delegate leftButtonDidTouch];
        }
    } else if (sender == self.rightButton) {
        if ([_delegate respondsToSelector:@selector(rightButtonDidTouch)]) {
            [_delegate rightButtonDidTouch];
        }
    }
}

@end
