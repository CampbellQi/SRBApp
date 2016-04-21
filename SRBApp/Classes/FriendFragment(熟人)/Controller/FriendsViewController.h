//
//  FriendsViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "RCChatListViewController.h"
#import "MyChatListViewController.h"
#import "ZuiJinChatListViewController.h"


@class FriendBaseCell;
typedef void (^myBlock) ();
typedef void (^MoveBlock) (NSInteger);
@interface FriendsViewController : RCChatListViewController<RCSelectPersonViewControllerDelegate>

{
    MBProgressHUD * HUD;
    //NSDictionary * tempDataDic;
    BOOL isHaveTime;
}
@property (nonatomic, copy) myBlock showBlock;
@property (nonatomic,copy)MoveBlock moveBlock;
@property (nonatomic, strong) UIButton * button1;
@property (nonatomic, strong) UIView * topBGView;
@property (nonatomic, strong) MyChatListViewController *myChatListVC;//会话列表

-(void)showGuideView;
//@property (nonatomic, strong) ZuiJinChatListViewController *zuijinChatListVC;//最近联系人

//- (void)urlRequestPost;
//- (void)changeRequest:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum;
@end
