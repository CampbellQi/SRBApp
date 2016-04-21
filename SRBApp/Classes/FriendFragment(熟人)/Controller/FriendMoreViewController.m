//
//  FriendMoreViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FriendMoreViewController.h"
#import "MoreOrderView.h"
#import "TwoDimensionCodeViewController.h"
#import "AddressBookListActivityViewController.h"
#import "SonOfAskAddressViewController.h"
#import "SubclassInviteFriendsViewController.h"
#import "SubOfClassSuggestionViewController.h"
#import "SearchFriendViewController.h"
#import "YaoYiYaoViewController.h"
#import "AppDelegate.h"
#import "MyQrCodeController.h"

@interface FriendMoreViewController ()<moreOrderDelegate>

@end

@implementation FriendMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MoreOrderView * moreView = [[MoreOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    moreView.array = self.array;
    moreView.imgArr = self.imgArr;
    moreView.delegate = self;
    self.view = moreView;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = APPDELEGATE;
//    app.customTab.hidden = YES;
//    app.mainTab.tabBar.hidden = YES;
//    app.zhedangView.hidden = YES;
//    
//}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeFromParentViewController];
}

- (void)moreOrderView:(MoreOrderView *)moreOrderView didSelectRow:(NSInteger)row
{
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] isEqualToString:GUEST]) {
//        if (row == 0) {
//            SubOfClassSuggestionViewController * myAssureVC = [[SubOfClassSuggestionViewController alloc]init];
//            [self.navigationController pushViewController:myAssureVC animated:YES];
//        }
//    }else{
        if (row == 0) {
            AddressBookListActivityViewController * addressVC = [[AddressBookListActivityViewController alloc]init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        if (row == 1) {
            MyQrCodeController *vc = [[MyQrCodeController alloc] init];
            vc.account = ACCOUNT_SELF;
            
            //SubclassInviteFriendsViewController * myAssureVC = [[SubclassInviteFriendsViewController alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (row == 2) {
            TwoDimensionCodeViewController * TwoDimensionCodeVC = [[TwoDimensionCodeViewController alloc]init];
            [self presentViewController:TwoDimensionCodeVC animated:YES completion:nil];
        }
//    if (row == 3) {
//        YaoYiYaoViewController * vc = [[YaoYiYaoViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
//        if (row == 3) {
//            SubOfClassSuggestionViewController * myAssureVC = [[SubOfClassSuggestionViewController alloc]init];
//            [self.navigationController pushViewController:myAssureVC animated:YES];
//        }
    
//    }
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
