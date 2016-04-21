//
//  UserDetailViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "UserDetailViewController.h"
#import "RCThemeDefine.h"
@interface UserDetailViewController ()
@property (nonatomic) RCUserAvatarStyle portaitStyle;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.portaitStyle = RCUserAvatarCycle;
    
    self.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    //自定义导航左按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 12, 25);
    [customLeftBtn setImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];

}

- (void)leftBarButtonItemPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
