//
//  ChooseDanbaoViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
 typedef void(^MyBlock2)(id result);
@interface ChooseDanbaoViewController : ZZViewController
@property (nonatomic, strong)NSMutableArray * nameArr;
@property (nonatomic ,copy)MyBlock2 block;

- (void)sendMessage:(MyBlock2)jgx;
@end
