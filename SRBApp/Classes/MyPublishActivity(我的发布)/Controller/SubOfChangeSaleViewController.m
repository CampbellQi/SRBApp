//
//  SubOfChangeSaleViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubOfChangeSaleViewController.h"

@interface SubOfChangeSaleViewController ()

@end

@implementation SubOfChangeSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)backBtn:(id)sender
//{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)changeNext
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"asd" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
