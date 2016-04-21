//
//  SubofclassDrawRecordsViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/31.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubofclassDrawRecordsViewController.h"
#import "MyWalletActivityViewController.h"

@interface SubofclassDrawRecordsViewController ()

@end

@implementation SubofclassDrawRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn:(id)sender
{
//        MyWalletActivityViewController * vc = [[MyWalletActivityViewController alloc]init];
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:vc.class]) {
//                [self.navigationController popToViewController:controller animated:YES];
//            }
//        }
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
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

@end
