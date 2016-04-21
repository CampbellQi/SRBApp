//
//  NewWQMarkView.h
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPMarkModel.h"

typedef void (^ResetFrameBlock) (void);
typedef void (^TappedBlock) (void);
typedef void (^ResetPointBlock) (void);

@interface WQMarkView : UIView
//中心btn距离center
@property (nonatomic, assign)CGSize toCenterSize;
+(id)produceWithData:(TPMarkModel *)markModel;

@property (nonatomic, copy)ResetFrameBlock resetFrameBlock;
@property (nonatomic, copy)TappedBlock tappedBlock;

@property (nonatomic, assign)CGPoint currentPoint;
@property (nonatomic, strong)TPMarkModel *sourceModel;

@property (nonatomic, assign)BOOL isFreeze;
@property (nonatomic, assign)BOOL needAnimation;

@property (nonatomic, copy)ResetPointBlock resetPointBlock;

-(void)resetCenter;
@end
