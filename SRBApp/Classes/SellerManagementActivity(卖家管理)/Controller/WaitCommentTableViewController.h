//
//  WaitCommentTableViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TosellerModel.h"
#import "WaitCommentCell.h"
#import "MJRefresh.h"
#import "ZZGoPayBtn.h"

@interface WaitCommentTableViewController : UITableViewController
{
    NSMutableArray * dataArray;
    NSMutableArray * totalArray;
}
- (void)urlRequestPost;
@end
