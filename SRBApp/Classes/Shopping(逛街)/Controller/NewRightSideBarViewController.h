//
//  NewRightSideBarViewController.h
//  SRBApp
//
//  Created by zxk on 15/6/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "CDRTranslucentSideBar.h"
#import "GroupModel.h"
@class NewShoppingViewController;

@interface NewRightSideBarViewController : ZZViewController
@property (nonatomic,strong)NSMutableArray * dealTypeArr;
@property (nonatomic,strong)NSMutableArray * groupArr;
@property (nonatomic,strong)CDRTranslucentSideBar * rightSideBar;
@property (nonatomic,strong)NewShoppingViewController * shoppingVC;

- (void)restAllState;
@end
