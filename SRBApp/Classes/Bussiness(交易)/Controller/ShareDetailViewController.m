//
//  ShareDetailViewController.m
//  SRBApp
//
//  Created by lizhen on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShareDetailViewController.h"
#import "RichContentMessageViewController.h"
#import "FriendFragmentModel.h"
#import "FriendGroupModel.h"
#import "ChangeBuyViewController.h"

@interface ShareDetailViewController ()

@end

@implementation ShareDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)backBtn:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        self.changeSaleVC.publishLater.hidden = NO;
        self.changeBuyVC.publishLater.hidden = NO;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        FriendFragmentModel * friendModel = searchResults[indexPath.row];
        [self chatRichAccount:friendModel.account andNickname:friendModel.nickname];
    }else{
        FriendGroupModel * groupModel = _resourceGroupArray[indexPath.section];
        NSArray * groupArr = groupModel.group;
        [self chatRichAccount:[groupArr[indexPath.row] objectForKey:@"account"] andNickname:[groupArr[indexPath.row] objectForKey:@"nickname"]];
    }
    
}
- (void)chatRichAccount:(NSString *)account andNickname:(NSString *)nickname
{
    //图文单聊
    RichContentMessageViewController *temp = [[RichContentMessageViewController alloc]init];
    
    temp.title = self.detailTitle;
    temp.content = self.content;
    temp.imageUrl = self.photoUrl;
    temp.photo = self.photo;
    temp.idNumber = self.idNumber;
    temp.currentTarget = account;
    temp.currentTargetName = nickname;
    temp.conversationType = ConversationType_PRIVATE;
    temp.enableSettings = NO;
    temp.portraitStyle = RCUserAvatarCycle;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    [temp sendDebugRichMessage];
    
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
