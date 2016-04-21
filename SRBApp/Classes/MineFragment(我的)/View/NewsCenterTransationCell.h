//
//  NewsCenterTransationCell.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCenterTransationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *kindIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIView *contentSuperView;

@property (nonatomic, strong)NSDictionary *sourceDict;
@end
