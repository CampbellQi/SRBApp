//
//  RecommendGoodsCollectionController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "BaseGoodsCollectionController.h"

@protocol RecommendGoodsCollectionControllerDelegate <NSObject>
-(void)scrollViewWillEndDraggingDelegate:(CGPoint)velocity;
@end
@interface RecommendGoodsCollectionController : BaseGoodsCollectionController
@property (nonatomic, strong)NSString *name;
@property (nonatomic, assign)id <RecommendGoodsCollectionControllerDelegate> delegate;
@end
