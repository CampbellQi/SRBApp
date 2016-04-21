//
//  PhotoListViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PhotoListViewController.h"

@interface PhotoListViewController ()
@property (nonatomic, strong)UIScrollView * scrollView;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
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
