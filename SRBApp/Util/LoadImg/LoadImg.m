//
//  LoadImg.m
//  SRBApp
//
//  Created by zxk on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LoadImg.h"

@implementation LoadImg

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT - 64 - 64 - 120)/2, 60, 100)];
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int i = 1; i <= 2 ; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshFlash%d",i]];
            [tempArr addObject:image];
        }
        self.imgView = imgView;
        [imgView setAnimationImages:tempArr];
        [imgView setAnimationDuration:0.3];
        [imgView stopAnimating];
        [self addSubview:imgView];
        
        MyLabel * wordLabel = [[MyLabel alloc]initWithFrame:CGRectMake(0, imgView.frame.size.height + imgView.frame.origin.y + 2, SCREEN_WIDTH, 18)];
        wordLabel.hidden = YES;
        wordLabel.textAlignment = NSTextAlignmentCenter;
        wordLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        wordLabel.font = SIZE_FOR_IPHONE;
        self.wordLabel = wordLabel;
        wordLabel.text = @"加载中，请稍后...";
        self.shadowAnimation = [JTSlideShadowAnimation new];
        self.shadowAnimation.animatedView = wordLabel;
        self.shadowAnimation.shadowWidth = 40;
        self.shadowAnimation.duration = 1.2;
//        self.shadowAnimation.shadowBackgroundColor = [GetColor16 hexStringToColor:@"#434343"];
        
        [self addSubview:wordLabel];
    }
    return self;
}

- (void)imgStart
{
    [self.shadowAnimation start];
    self.wordLabel.hidden = NO;
    [self.imgView startAnimating];
}

- (void)imgStop
{
    [self.shadowAnimation stop];
    self.wordLabel.hidden = YES;
    [self.imgView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
