//
//  DanBaoMenuView.h
//  SRBApp
//
//  Created by zxk on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
#import "GuaranteeNumImageView.h"
#import "DanBaoRenModel.h"
@class DanBaoMenuView;
@protocol moreDanbaoDelegate <NSObject>
- (void)moreDanbaoView:(DanBaoMenuView *)danBaoMenuView didSelectRow:(NSInteger)row;
@end

@interface DanBaoMenuView : ZZView
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,assign)id<moreDanbaoDelegate>delegate;
@end
