//
//  MineFragmentViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface MineFragmentViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic, weak) UIImageView *runImageV;

- (void)post;
- (void)postRun;
@end
