//
//  SearchController.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/3.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRBBaseViewController.h"
enum Type {
    Country,
    Currency,
    Brand
};

typedef void (^SelectedBlock) (NSString *item);
typedef void (^HideKeboardBlock) (void);
typedef void (^HideBlock) (void);
typedef void (^ShowBlock) (void);

@interface SearchController : SRBBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSString *keyWords;
@property (nonatomic, assign) enum Type type;

@property (nonatomic, copy)SelectedBlock selectedBlock;
@property (nonatomic, copy)HideBlock hideBlock;
@property (nonatomic, copy)ShowBlock showBlock;
@property (nonatomic, copy)HideKeboardBlock hideKeboardBlock;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSArray *sourceArray;

@end
