//
//  MoreViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreOrderView.h"
#import "PersonalViewController.h"
#import "ModifiRemarkViewController.h"
#import "MyChatViewController.h"
#import "MyTwoDimensionCodeViewController.h"
#import "CommonFriendViewController.h"
#import "MyChatViewController.h"
#import "RCIM.h"
#import "AppDelegate.h"

@interface MoreViewController ()<moreOrderDelegate>

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MoreOrderView * moreView = [[MoreOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    moreView.array = self.array;
    moreView.imgArr = self.imgArr;
    moreView.delegate = self;
    self.view = moreView;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
}

- (void)moreOrderView:(MoreOrderView *)moreOrderView didSelectRow:(NSInteger)row
{
    PersonalViewController * personVC = (PersonalViewController *)[self parentViewController];
    if ([[self.dataDic objectForKey:@"isFriended"]isEqualToString:@"1"]) {
        if (row == 0) {
            ModifiRemarkViewController *modifiRemarkVC = [[ModifiRemarkViewController alloc] init];
            modifiRemarkVC.friendId = personVC.friendId;
            modifiRemarkVC.personalVC = personVC;
            modifiRemarkVC.friendRemark = [self.dataDic objectForKey:@"memo"];
            [self.navigationController pushViewController:modifiRemarkVC animated:YES];
        }
        if (row == 1) {
            [personVC operationFriend];
        }
        if (row == 2) {
            CommonFriendViewController *commonFriendVC = [[CommonFriendViewController alloc] init];
            commonFriendVC.sellerAccount = personVC.account;
            [self.navigationController pushViewController:commonFriendVC animated:YES];
        }
        if (row == 3) {
            [personVC operationBlack];
        }
        if (row == 4) {
            MyTwoDimensionCodeViewController *myQRcodeVC = [[MyTwoDimensionCodeViewController alloc] init];
            myQRcodeVC.account = [self.dataDic objectForKey:@"account"];
            [self.navigationController pushViewController:myQRcodeVC animated:YES];
        }
    }else{
        if (row == 0) {
            if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
                AppDelegate *app = APPDELEGATE;
                [app showLoginAlertView];
            }else{
            [personVC operationFriend];
            }
        }
        if (row == 1) {
            CommonFriendViewController *commonFriendVC = [[CommonFriendViewController alloc] init];
            commonFriendVC.sellerAccount = personVC.account;
            [self.navigationController pushViewController:commonFriendVC animated:YES];
        }
        if (row == 2) {
            MyTwoDimensionCodeViewController *myQRcodeVC = [[MyTwoDimensionCodeViewController alloc] init];
            myQRcodeVC.account = [self.dataDic objectForKey:@"account"];
            [self.navigationController pushViewController:myQRcodeVC animated:YES];
        }

    }
    
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
