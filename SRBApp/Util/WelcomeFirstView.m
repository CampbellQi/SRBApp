//
//  WelcomeFirstView.m
//  SRBApp
//
//  Created by 刘若曈 on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WelcomeFirstView.h"
#import "AppDelegate.h"
#import "ShoppingViewController.h"

@implementation WelcomeFirstView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ] ;
        _scrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.bounces = NO;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        UIImageView * view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view1.contentMode = UIViewContentModeScaleAspectFill;
        view1.clipsToBounds = YES;
        view1.image = [UIImage imageNamed:@"bg_1"];
        [_scrollView addSubview:view1];
        
        UIImageView * upview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH / 540 * 773 /2,  SCREEN_WIDTH / 540 * 147 /2)];
        upview1.image = [UIImage imageNamed:@"slg1"];
        upview1.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.15);
        [view1 addSubview:upview1];
        
        UIImageView * midview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 1242 /2,  SCREEN_WIDTH / 540 * 916 /2)];
        midview1.image = [UIImage imageNamed:@"p1"];
        midview1.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.5);
        [view1 addSubview:midview1];
        
        _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH / 540 * 345,  SCREEN_WIDTH / 540 * 112)];
        _image1.image = [UIImage imageNamed:@"jujuemosheng"];
        _image1.center = CGPointMake(SCREEN_WIDTH / 2, - _image1.frame.size.height);
        [view1 addSubview:_image1];
        
        
        
        UIImageView * view2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH , SCREEN_HEIGHT)];
        view2.image = [UIImage imageNamed:@"bg_2"];
        view2.contentMode = UIViewContentModeScaleAspectFill;
        view2.clipsToBounds = YES;
        [_scrollView addSubview:view2];
        
        UIImageView * upview2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH / 540 * 598 /2,  SCREEN_WIDTH / 540 * 600 /2)];
        upview2.image = [UIImage imageNamed:@"slg2"];
        upview2.center = CGPointMake(SCREEN_WIDTH / 2 + SCREEN_WIDTH / 540 * 70, SCREEN_HEIGHT * 0.25);
        [view2 addSubview:upview2];
        
        UIImageView * midview2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 1242 /2,  SCREEN_WIDTH / 540 * 575 /2)];
        midview2.image = [UIImage imageNamed:@"p2"];
        midview2.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.5);
        [view2 addSubview:midview2];
        
        _image2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 345,  SCREEN_WIDTH / 540 * 112)];
        _image2.image = [UIImage imageNamed:@"jujuejiahuo"];
        _image2.center = CGPointMake(SCREEN_WIDTH / 2, - _image2.frame.size.height);
        [view2 addSubview:_image2];
        
        
        
        _view3 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _view3.image = [UIImage imageNamed:@"bg_3"];
        _view3.contentMode = UIViewContentModeScaleAspectFill;
        _view3.clipsToBounds = YES;
        _view3.userInteractionEnabled = YES;
        [_scrollView addSubview:_view3];
        
        UIImageView * upview3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH / 540 * 466 /2,  SCREEN_WIDTH / 540 * 394 /2)];
        upview3.image = [UIImage imageNamed:@"slg3"];
        upview3.center = CGPointMake(SCREEN_WIDTH / 2 + SCREEN_WIDTH / 540 * 15, SCREEN_HEIGHT * 0.3);
        [_view3 addSubview:upview3];
        
        UIImageView * midview3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 1242 /2,  SCREEN_WIDTH / 540 * 535 /2)];
        midview3.image = [UIImage imageNamed:@"p3"];
        midview3.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.5);
        [_view3 addSubview:midview3];
        
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH / 540 * 495 /2,  SCREEN_WIDTH / 540 * 189 /2)];
        [_button setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
        _button.center = CGPointMake(SCREEN_WIDTH / 2, midview3.frame.origin.y + midview3.frame.size.height + 10 + _button.frame.size.height / 2);
        [_view3 addSubview:_button];
        
        _image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 540 * 345,  SCREEN_WIDTH / 540 * 112)];
        _image3.image = [UIImage imageNamed:@"chengxinyoujia"];
        _image3.center = CGPointMake(SCREEN_WIDTH / 2, - _image3.frame.size.height);
        [_view3 addSubview:_image3];
        
        
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.9, SCREEN_WIDTH, 8)];
        _page.currentPageIndicatorTintColor = [UIColor whiteColor];
        [_page setNumberOfPages:3];
        [self addSubview:_page];
        
    }
    return self;
}

+ (void)animation:(UIImageView *)imageView
{
    [UIView animateWithDuration:0.3 animations:^{
        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.85);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.85 - 15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.85);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.85 - 7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.85);
                    }];
                }];
            }];
        }];
    }];
}

+(void)closeView:(UIView *)view
{
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
        
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
