//
//  TopicDetailHeaderView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/10.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTagList.h"
#import "BussinessModel.h"

typedef void (^AvaterClickedBlock) (NSString *account);

@interface TopicDetailHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet DWTagList *markView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;
@property (weak, nonatomic) IBOutlet UILabel *accountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *markIV;
//@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (nonatomic, strong)BussinessModel *bussinessModel;

@property (nonatomic, copy)TagClickedBlock tagClickedBlock;

@property (nonatomic, copy)AvaterClickedBlock avaterClickedBlock;
@end
