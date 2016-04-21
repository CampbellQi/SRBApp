//
//  TopicCommentListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define CONTENT_LBL_XMARGIN 8
#import <UIKit/UIKit.h>
#import "TopicCommentModel.h"

typedef void (^AvaterClickedBlock) (NSString *account);
@interface TopicCommentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@property (nonatomic, strong)TopicCommentModel *sourceModel;

@property (nonatomic, copy)AvaterClickedBlock avaterClickedBlock;
@end
