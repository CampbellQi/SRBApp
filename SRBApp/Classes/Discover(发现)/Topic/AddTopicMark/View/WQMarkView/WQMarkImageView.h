//
//  WQImageView.h
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^TapBlock) (CGPoint point);
@interface WQMarkImageView : UIImageView

@property (nonatomic, copy)TapBlock tapBlock;
@end
