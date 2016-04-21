//
//  SPListController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseSPListController.h"

@interface SPListController : BaseSPListController
@property (weak, nonatomic) IBOutlet UIButton *latestBtn;
- (IBAction)latestBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *screeningBtn;
- (IBAction)screeningBtnClicked:(id)sender;

@end
