//
//  CopyLabel.m
//  SRBApp
//
//  Created by zxk on 15/2/25.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CopyLabel.h"

@implementation CopyLabel

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    UIPasteboard * pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
}



- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        //    UIMenuItem * copyLink = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copy:)];
        //    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        self.backgroundColor = RGBCOLOR(161, 161, 161, 1);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
        self.layer.borderColor = [GetColor16 hexStringToColor:@"#f6f6f6"].CGColor;
        self.layer.borderWidth = 1;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
