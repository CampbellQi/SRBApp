//
//  CommonFriendViewController.h
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MJRefresh.h"
#import "CommonFriendCell.h"
#import "CommenFriendModel.h"
#import "NoDataView.h"
#import "RCIM.h"
#import "RichContentMessageViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
@interface CommonFriendViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

{
    MBProgressHUD * HUD;
    UITableView * tableview;
    NSMutableArray * dataArray;
    NoDataView * imageview;
    CommenFriendModel * tempCommentModel;
}
@property (nonatomic, strong) NSString * sellerAccount;
@property (nonatomic, strong) NSString *sellerNick;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *photo;//判断有无图片

- (void)chatBtn:(ZZGoPayBtn *)chatBtn;
@end
