//
//  ModifiRemarkViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "PersonalViewController.h"

@interface ModifiRemarkViewController : ZZViewController
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic,strong)PersonalViewController * personalVC;
@property (nonatomic,strong)NSString * friendRemark;
@end
