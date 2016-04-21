//
//  GuideView.m
//  tusstar
//
//  Created by fengwanqi on 15/8/21.
//  Copyright (c) 2015年 zxk. All rights reserved.
//
#define GUIDE_COUNT 11
#import "WQGuideView.h"
#import "AppDelegate.h"
static WQGuideView * _guideView;
static UIImageView *_contentIV;
@implementation WQGuideView

+(id)share{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _guideView = [[WQGuideView alloc] initWithFrame:(APPDELEGATE).window.bounds];
            _contentIV = [[UIImageView alloc] initWithFrame:_guideView.bounds];
            [_guideView addSubview:_contentIV];
            NSArray *guideArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"guide_df"];
            if (!guideArray) {
                NSMutableArray *tempArray = [NSMutableArray new];
                for (int i=0; i<GUIDE_COUNT; i++) {
                    [tempArray addObject:[NSString stringWithFormat:@"guide%d", i]];
                }
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:tempArray forKey:@"guide_df"];
                [defaults synchronize];
            }
            
            [_guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_guideView action:@selector(remove)]];
        });
        return _guideView;
}
-(void)showAtIndex:(int)aIndex GuideViewRemoveBlock: (void (^)(void))guideViewRemoveBlock{
    NSArray *guideArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"guide_df"];
    if (guideArray && guideArray.count > aIndex && ![[guideArray objectAtIndex:aIndex] isEqualToString:@"0"]) {
        _contentIV.image = [UIImage imageNamed:[guideArray objectAtIndex:aIndex]];
        _contentIV.tag = 100 + aIndex;
        [(APPDELEGATE).window addSubview:_guideView];
        self.guideViewRemoveBlock = guideViewRemoveBlock;
    }
}
-(void)remove {
    int index = (int)_contentIV.tag - 100;
    [_guideView removeFromSuperview];
    NSMutableArray *guideArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"guide_df"]];
    [guideArray replaceObjectAtIndex:index withObject:@"0"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:guideArray forKey:@"guide_df"];
    [defaults synchronize];
    if (_guideView.guideViewRemoveBlock) {
        _guideView.guideViewRemoveBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
