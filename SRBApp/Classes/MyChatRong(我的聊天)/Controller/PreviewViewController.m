//
//  PreviewViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PreviewViewController.h"
#import "GetColor16.h"
@interface PreviewViewController ()
{
    UIView *topBGView;

}
@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //自定义导航左按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt2"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);

    [rightBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];


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
