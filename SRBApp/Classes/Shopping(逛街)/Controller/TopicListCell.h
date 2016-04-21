//
//  GoodsOrderListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/8/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"
#import "DWTagList.h"
#define CELL_HEIGHT 410 + SCREEN_WIDTH / 320.0 * 228  - 228

typedef void (^AvaterClickedBlock) (NSString *account);
@interface TopicListCell : UITableViewCell
@property (nonatomic, strong)BussinessModel *bussinessModel;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet DWTagList *markView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *lineIV;
@property (weak, nonatomic) IBOutlet UIImageView *markIV;

@property(nonatomic) NSRange highlightedRange;

@property (nonatomic, copy)TagClickedBlock tagClickedBlock;

@property (nonatomic, copy)AvaterClickedBlock avaterClickedBlock;
@end
