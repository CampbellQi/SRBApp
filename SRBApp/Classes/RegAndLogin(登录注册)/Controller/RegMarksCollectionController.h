//
//  SRBRegMarksCollectionController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface RegMarksCollectionController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@end
