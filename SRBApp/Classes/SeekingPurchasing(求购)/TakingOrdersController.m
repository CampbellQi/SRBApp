//
//  TakingOrdersController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TakingOrdersController.h"

@interface TakingOrdersController ()

@end

@implementation TakingOrdersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)helpPurchasingBtnClicked:(id)sender {
    if (self.takingTypeBlock) {
        self.takingTypeBlock(HelpPurchasing);
    }
}

- (IBAction)spotGoodsBtnClicked:(id)sender {
    if (self.takingTypeBlock) {
        self.takingTypeBlock(SpotGoods);
    }
}
@end
