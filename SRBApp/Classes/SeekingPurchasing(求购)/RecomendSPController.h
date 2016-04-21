//
//  RecomendSPController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/22.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#import "BaseSPListController.h"

@protocol RecomendSPControllerDelegate <NSObject>
-(void)scrollViewWillEndDraggingDelegate:(CGPoint)velocity;
@end

@interface RecomendSPController : BaseSPListController

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *brand;

@property (nonatomic, assign)id <RecomendSPControllerDelegate> delegate;
@end
