//
//  CategoryTableViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol categoryTableDelegate <NSObject>

- (void)didSelectRow:(NSIndexPath *)indexpath;

@end

@interface CategoryTableViewController : UITableViewController
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,assign)id<categoryTableDelegate>categoryDelegate;
@end
