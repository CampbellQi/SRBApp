//
//  MoreViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface MoreViewController : ZZViewController
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSArray * imgArr;


@property (nonatomic,strong)NSDictionary * dataDic;
@end
