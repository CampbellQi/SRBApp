//
//  GuideView.h
//  tusstar
//
//  Created by fengwanqi on 15/8/21.
//  Copyright (c) 2015年 zxk. All rights reserved.
//
typedef void (^GuideViewRemoveBlock) (void);

#import <UIKit/UIKit.h>

@interface WQGuideView : UIView

@property (nonatomic, copy)GuideViewRemoveBlock guideViewRemoveBlock;
+(id)share;
-(void)showAtIndex:(int)aIndex GuideViewRemoveBlock: (void (^)(void))guideViewRemoveBlock;
@end
