//
//  SubOfAliPayViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubOfAliPayViewController.h"

@interface SubOfAliPayViewController ()

@end

@implementation SubOfAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)back
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
