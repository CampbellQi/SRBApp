//
//  SubclassDetailViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubclassDetailViewController.h"

@interface SubclassDetailViewController ()

@end

@implementation SubclassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn
{
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
