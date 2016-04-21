//
//  ShopCircleTableViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCircleTableViewController : UITableViewController
@property (nonatomic,strong)NSString * saleAndBuyType;
@property (nonatomic,strong)NSString * categoryID;
- (void)urlRequestPost;

@end
