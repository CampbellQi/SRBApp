//
//  SRBRegMarksCollectionCell.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegMarksCollectionCell : UICollectionViewCell

@property (nonatomic, strong)NSDictionary *dataDict;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UIImageView *selectIV;
@end
