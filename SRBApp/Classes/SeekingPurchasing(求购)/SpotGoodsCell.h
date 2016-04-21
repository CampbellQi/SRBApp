//
//  SpotGoodsCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/12/15.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BussinessModel.h"

typedef void (^EditBlock) (BussinessModel *editModel);
@interface SpotGoodsCell : UICollectionViewCell

@property (nonatomic, strong)BussinessModel *sourceModel;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIV;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (nonatomic, copy)EditBlock editBlock;
- (IBAction)editBtnClicked:(id)sender;
@end
