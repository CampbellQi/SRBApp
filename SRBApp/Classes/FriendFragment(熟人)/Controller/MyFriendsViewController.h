//
//  MyFriendsViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"


@class FriendBaseCell;
typedef void (^myBlock) ();
typedef void (^MoveBlock) (NSInteger);
/**
 *  @brief  我的熟人
 */
@interface MyFriendsViewController : ZZViewController
{
    NSMutableArray *tempDataArr;
    NSMutableArray *searchResults;
    NSMutableArray * _resourceGroupArray;   //分组
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    MBProgressHUD * HUD;
    NoDataView * noDataView;
}
@property (nonatomic, copy) myBlock showBlock;
@property (nonatomic,copy)MoveBlock moveBlock;
- (void)backBtn:(UIBarButtonItem *)sender;
- (void)urlRequestPost;
- (void)changeRequest:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
