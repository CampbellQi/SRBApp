//
//  EmotionPopView.m
//  SRBApp
//
//  Created by zxk on 15/4/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "EmotionPopView.h"
#import "EmotionButton.h"

@interface EmotionPopView ()
@property (weak, nonatomic) IBOutlet EmotionButton *emotionButton;
@end

@implementation EmotionPopView
+ (instancetype)popView
{
    UIView * tempView = [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
    NSLog(@"%@",tempView);
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(EmotionButton *)btn
{
    if (btn == nil) return;
    //popView传递数据
    self.emotionButton.emotion = btn.emotion;
    
    //取得最上面的window
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    //btn在window中的frame
    //    [btn.superview convertRect:btn.frame toView:nil];
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
}

@end
