//
//  EvaluateViewController.h
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "RelationTable.h"
#import "CircleTable.h"
#import "GoodFriendViewController.h"
#import "TatolEvaluateViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface EvaluateViewController : ZZViewController<UIScrollViewDelegate>
{
    UIView * lineView;
    UIButton * relationBtn;
    UIButton * circleBtn;
}

@property (nonatomic, strong) GoodFriendViewController *goodFriendVC;
@property (nonatomic, strong) TatolEvaluateViewController *totalEvaluateVC;
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) NSString *idNumber;

- (void)relationBtn:(UIButton *)sender;
- (void)circleBtn:(UIButton *)sender;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
