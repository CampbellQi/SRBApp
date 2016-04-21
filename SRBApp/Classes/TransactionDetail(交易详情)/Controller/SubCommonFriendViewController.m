//
//  SubCommonFriendViewController.m
//  SRBApp
//
//  Created by lizhen on 15/3/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubCommonFriendViewController.h"

@interface SubCommonFriendViewController ()

@end

@implementation SubCommonFriendViewController

- (void)chatBtn:(ZZGoPayBtn *)chatBtn
{
    tempCommentModel = dataArray[chatBtn.indexpath.row];
    UIActionSheet *chatActionSheet = [[UIActionSheet alloc] initWithTitle:@"是否发送信息链接" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送",@"不发送", nil];
    [chatActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self chatRichContentMessage];
    }if (buttonIndex == 1) {
        [self chat];
    }
}


//单聊
- (void)chat
{
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = tempCommentModel.account;
    user.name = tempCommentModel.nickname;
    user.portraitUri = tempCommentModel.avatar;
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myChatVC animated:YES];
}

//图文聊天
- (void)chatRichContentMessage
{
    
    //图文单聊
    
    RichContentMessageViewController *temp = [[RichContentMessageViewController alloc]init];
    
    temp.title = self.title;
    temp.content = self.content;
    temp.imageUrl = self.imageUrl;
    temp.idNumber = self.idNumber;
    temp.currentTarget = tempCommentModel.account;
    temp.currentTargetName = tempCommentModel.nickname;
    temp.conversationType = ConversationType_PRIVATE;
    temp.enableSettings = NO;
    temp.photo = self.photo;
    temp.portraitStyle = RCUserAvatarCycle;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    [temp sendDebugRichMessage];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
