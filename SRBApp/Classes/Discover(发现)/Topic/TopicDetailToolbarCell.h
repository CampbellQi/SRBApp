//
//  TopicDetailToolbarCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
enum BtnType {
    purchiseBtn,
    usedBtn,
    grassBtn,
    turnBtn
};


#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"

typedef void (^BtnClickedBlock) (enum BtnType type, TopicDetailModel *model);

@interface TopicDetailToolbarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *purchiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *usedBtn;
@property (weak, nonatomic) IBOutlet UIButton *grassBtn;
@property (weak, nonatomic) IBOutlet UIButton *turnBtn;

@property (nonatomic, strong)TopicDetailModel *sourceModel;
@property (weak, nonatomic) IBOutlet UILabel *purchiseCountLlb;
@property (weak, nonatomic) IBOutlet UILabel *grassCountLbl;

@property (nonatomic, copy)BtnClickedBlock btnClickedBlock;
@end
