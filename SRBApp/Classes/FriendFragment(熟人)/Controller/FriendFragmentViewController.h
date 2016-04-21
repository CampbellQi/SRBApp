//
//  FriendFragmentViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/25.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
@class FriendBaseCell;
typedef void (^myBlock) ();
typedef void (^MoveBlock) (NSInteger);
@interface FriendFragmentViewController : ZZViewController

{
    MBProgressHUD * HUD;
}
@property (nonatomic, copy) myBlock showBlock;
@property (nonatomic,copy)MoveBlock moveBlock;
- (void)urlRequestPost;
- (void)changeRequest:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum;
- (void)getNewNewsCount;
@end
