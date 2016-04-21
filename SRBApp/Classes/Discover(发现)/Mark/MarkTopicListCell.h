//
//  MarkTopicListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/10.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

@interface MarkTopicListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *IV1;
@property (weak, nonatomic) IBOutlet UIImageView *IV2;
@property (weak, nonatomic) IBOutlet UIImageView *IV3;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *collectCountLbl;


@property (nonatomic, strong)BussinessModel *bussinessModel;
@end
