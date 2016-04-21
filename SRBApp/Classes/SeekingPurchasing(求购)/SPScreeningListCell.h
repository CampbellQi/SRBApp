//
//  SPScreeningListCell.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BtnClickedBlock) (NSDictionary *dict);
@interface SPScreeningListCell : UITableViewCell
- (IBAction)btnClicked:(id)sender;

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)BtnClickedBlock btnClickedBlock;

-(void)resetBtnBgAtIndex:(long)index;
@end
