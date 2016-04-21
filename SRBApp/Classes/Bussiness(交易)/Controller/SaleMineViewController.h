//
//  SaleMineViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "DetailModel.h"

@interface SaleMineViewController : ZZViewController
{
    BOOL isBack;
}
@property (nonatomic, strong)NSString * sign;
@property (nonatomic, strong)DetailModel * model;
@end
