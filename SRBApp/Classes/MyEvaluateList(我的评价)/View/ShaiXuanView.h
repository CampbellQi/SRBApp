//
//  ShaiXuanView.h
//  SRBApp
//
//  Created by zxk on 15/1/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@class ShaiXuanView;

/*! @brief选择评价等级的代理
 *
 */
@protocol shaiXuanViewDelegate <NSObject>

- (void)shaiXuanView:(ShaiXuanView *)shaiXuanView didSelectRow:(NSInteger)row;

@end
@interface ShaiXuanView : ZZView
@property (nonatomic,assign)id<shaiXuanViewDelegate>delegate;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * imgArr;
@end
