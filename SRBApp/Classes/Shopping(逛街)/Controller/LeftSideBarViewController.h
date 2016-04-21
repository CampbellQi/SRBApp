//
//  LeftSideBarViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "CDRTranslucentSideBar.h"
#import "ShoppingViewController.h"
#import "GroupModel.h"
//typedef void (^restBlock) ();

@interface LeftSideBarViewController : ZZViewController
@property (nonatomic,strong)NSMutableArray * dealTypeArr;
@property (nonatomic,strong)NSMutableArray * groupArr;
@property (nonatomic,strong)CDRTranslucentSideBar * rightSideBar;
@property (nonatomic,strong)ShoppingViewController * shoppingVC;
//@property (nonatomic,copy)restBlock isRestBlock;.
- (void)restAllState;
@end
