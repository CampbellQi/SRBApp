//
//  NewAttentionViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZTableViewController.h"
#import "MineFragmentViewController.h"

@interface NewAttentionViewController : ZZTableViewController
{
    NoDataView * noData;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic,strong)MineFragmentViewController * mineFragmentVC;
- (void)urlRequestForVIP;
@end
