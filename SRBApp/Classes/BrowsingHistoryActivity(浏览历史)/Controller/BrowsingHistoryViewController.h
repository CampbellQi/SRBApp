//
//  BrowsingHistoryViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MineFragmentViewController.h"

@interface BrowsingHistoryViewController : ZZViewController
{
    NoDataView * noData;
}
@property (nonatomic,strong)MineFragmentViewController * mineFragmentVC;
@end
