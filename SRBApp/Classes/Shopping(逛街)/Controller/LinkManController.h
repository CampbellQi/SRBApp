//
//  TopicToGoodsController.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZViewController.h"
#import "CDRTranslucentSideBar.h"
#import "NewRightSideBarViewController.h"

@interface LinkManController : ZZViewController<UIScrollViewDelegate,CDRTranslucentSideBarDelegate>
@property (nonatomic,assign)BOOL isSquareShow;
@end
