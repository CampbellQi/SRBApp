//
//  PersonalSPController.h
//  SRBApp
//  我的求购
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"
#import "NavSliderScrollView.h"


@interface PersonalSPController : SRBBaseViewController<NavSliderScrollViewDelegate>

@property (nonatomic, assign)int startIndex;
-(void)reloadCurrentViewData;
@end
