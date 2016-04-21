//
//  WQCheckboxController.h
//  testWQCheckbox
//
//  Created by fengwanqi on 15/7/9.
//  Copyright (c) 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectItemBlock) (NSString *item);;


@interface WQCheckboxController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
+(void)showWithSourceData:(NSArray *)dataArray Message:(NSString *)msg CurrentSelItem:(NSString *)currentSelItem SelectItemBlock:(void (^) (NSString *selectItem))selectItemBlock;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
+(void)hide;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
