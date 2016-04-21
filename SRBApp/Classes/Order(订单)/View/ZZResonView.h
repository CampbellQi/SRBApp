//
//  ZZResonView.h
//  SRBApp
//
//  Created by zxk on 14/12/20.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"

@class ZZResonView;
/*! @brief选择理由的代理
 *
 */
@protocol resonViewDelegate <NSObject>

- (void)resonView:(ZZResonView *)resonView didSelectRow:(NSInteger)row;

@end

@interface ZZResonView : ZZView
@property (nonatomic,assign)id<resonViewDelegate>delegate;
@property (nonatomic,strong)NSArray * array;
@end
