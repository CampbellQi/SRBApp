//
//  DWTagLabel.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/4.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TagTappedBlock) (UILabel *tappedLabel);
@interface DWTagLabel : UILabel

@property (nonatomic, copy)TagTappedBlock tagTappedBlock;
@end
