//
//  SPScreeningListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SPScreeningListCell.h"
#import "UIColor+Dice.h"


@implementation SPScreeningListCell

- (void)awakeFromNib {
    // Initialization code
    for (int i = 100; i<104; i++) {
        UIView *view = [self viewWithTag:i];
        view.layer.cornerRadius = view.height * 0.5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)resetBtnBgAtIndex:(long)index {
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100 + i];
        if (i == index) {
            [btn setBackgroundColor:MAINCOLOR];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else {
            [btn setBackgroundColor:RGBCOLOR(230, 230, 230, 1)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
-(void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100 + i];
        if (dataArray.count > i) {
            NSDictionary *dict = dataArray[i];
            btn.hidden = NO;
            [btn setTitle:dict[@"categoryName"] forState:UIControlStateNormal];
        }else {
            btn.hidden = YES;
        }
    }
}
- (IBAction)btnClicked:(UIButton *)sender {
    NSDictionary *dict = _dataArray[sender.tag - 100];
    if (self.btnClickedBlock) {
        self.btnClickedBlock(dict);
    }
}
@end
