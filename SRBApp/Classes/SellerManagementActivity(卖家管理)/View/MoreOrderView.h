//
//  MoreOrderView.h
//  SRBApp
//
//  Created by zxk on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
#import "MenuBtn.h"

@class MoreOrderView;

@protocol moreOrderDelegate <NSObject>
- (void)moreOrderView:(MoreOrderView *)moreOrderView didSelectRow:(NSInteger)row;
@end
@interface MoreOrderView : ZZView

@property (nonatomic,assign)id<moreOrderDelegate>delegate;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * imgArr;
@end
