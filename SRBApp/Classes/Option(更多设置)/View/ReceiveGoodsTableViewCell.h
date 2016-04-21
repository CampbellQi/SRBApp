//
//  ReceiveGoodsTableViewCell.h
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveModel.h"

typedef void (^EditBlock) (NSIndexPath *indexPath);
@interface ReceiveGoodsTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *receivePeople;   //收货人
@property (nonatomic, strong) UILabel *mobile;           //联系电话
@property (nonatomic, strong) UILabel *receiveAddress;  //收货地址
@property (nonatomic, strong) UILabel *receivePeopleLB;
@property (nonatomic, strong) UILabel *phoneLB;
@property (nonatomic, strong) UILabel *receiveAddrLB;
@property (nonatomic, strong) NSIndexPath * indexpath;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, copy)EditBlock editBlock;

@end
