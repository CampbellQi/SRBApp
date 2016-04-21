//
//  TopicDetailSPListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPMarkModel.h"

@interface TopicDetailSPListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *orignLbl;
@property (weak, nonatomic) IBOutlet UILabel *refPriceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIV;

@property (nonatomic, strong)TPMarkModel *sourceModel;
@property (nonatomic, strong)NSString *cover;
@end
