//
//  SPScreeningCollectionHeaderView.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPScreeningListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextField *price1TF;
@property (weak, nonatomic) IBOutlet UITextField *price2TF;
- (IBAction)priceBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *topView;

@end
